#!/usr/bin/env ruby
# frozen_string_literal: true

# Scrapes EMBARC.online Grade 5 Moodle pages to build a structured JSON
# sitemap of all modules, topics, lessons, and resource links.
#
# Usage:
#   ruby scripts/scrape_embarc.rb
#
# Output:
#   data/embarc/grade-5-sitemap.json
#
# Rate limiting: 1 request per second to be respectful of the volunteer-run site.

require "open-uri"
require "nokogiri"
require "json"
require "fileutils"

BASE_URL = "https://embarc.online"
OUTPUT_DIR = File.expand_path("../data/embarc", __dir__)
OUTPUT_FILE = File.join(OUTPUT_DIR, "grade-5-sitemap.json")
DELAY = 1.0 # seconds between requests

# Grade 5 module course IDs on EMBARC (from our research)
GRADE_5_MODULES = {
  51 => { number: 0, title: "General Resources" },
   3 => { number: 1, title: "Place Value and Decimal Fractions" },
   4 => { number: 2, title: "Multi-Digit Whole Number and Decimal Fraction Operations" },
   6 => { number: 3, title: "Addition and Subtraction of Fractions" },
   7 => { number: 4, title: "Multiplication and Division of Fractions and Decimal Fractions" },
   9 => { number: 5, title: "Addition and Multiplication with Volume and Area" },
  11 => { number: 6, title: "Problem Solving with the Coordinate Plane" }
}.freeze

$request_count = 0

def fetch(url)
  $request_count += 1
  $stderr.print "\r  [#{$request_count}] Fetching: #{url[0..80].ljust(81)}"
  sleep(DELAY) if $request_count > 1
  html = URI.open(url, "User-Agent" => "CommonMath-Scraper/1.0 (educational project)").read
  Nokogiri::HTML(html)
rescue OpenURI::HTTPError => e
  $stderr.puts "\n  WARNING: HTTP error fetching #{url}: #{e.message}"
  nil
rescue StandardError => e
  $stderr.puts "\n  WARNING: Error fetching #{url}: #{e.message}"
  nil
end

def absolute_url(href)
  return nil if href.nil? || href.empty?
  return href if href.start_with?("http")
  "#{BASE_URL}/#{href.sub(%r{^/}, '')}"
end

def extract_resource_type(text, href)
  text_lower = text.downcase.strip
  return "video" if text_lower == "video" || text_lower.include?("video")
  return "lesson_pdf" if text_lower == "lesson pdf" || text_lower.include?("lesson pdf")
  return "homework_solutions" if text_lower.include?("homework solution")
  return "exit_ticket_solutions" if text_lower.include?("exit ticket solution")
  return "google_slides" if text_lower.include?("google slide") || text_lower.include?("slideshow")
  return "promethean_flipchart" if text_lower.include?("promethean") || text_lower.include?("flipchart")
  return "go_formative" if text_lower.include?("go formative") || text_lower.include?("formative exit")
  return "topic_quiz" if text_lower.include?("topic") && text_lower.include?("quiz")
  return "parent_newsletter" if text_lower.include?("parent newsletter")
  return "smartboard" if text_lower.include?("smartboard") || text_lower.include?("smart board")
  return "geogebra" if text_lower.include?("geogebra")
  return "online_practice" if text_lower.include?("online practice")
  return "pacing_guide" if text_lower.include?("pacing")
  return "mid_module_review" if text_lower.include?("mid-module") || text_lower.include?("mid module")
  return "end_module_review" if text_lower.include?("end-of-module") || text_lower.include?("end of module")
  return "application_problems" if text_lower.include?("application problem")
  return "eureka_essentials" if text_lower.include?("eureka essentials")
  return "fluency_games" if text_lower.include?("fluency")
  return "downloadable_resources" if text_lower.include?("downloadable")
  return "vocabulary" if text_lower.include?("vocabulary")
  return "number_talks" if text_lower.include?("number talk")
  "other"
end

# Parse a Moodle course page into sections.
# Moodle organizes content into <li class="section"> elements,
# each with a heading and a list of activities.
def parse_course_page(doc)
  sections = []

  # Moodle uses <li class="section ..."> or <div class="section ...">
  section_elements = doc.css("li.section")
  section_elements = doc.css(".section.main") if section_elements.empty?

  section_elements.each do |section|
    # Section header
    header_el = section.css(".sectionname, .section-title, h3.sectionname").first
    header = header_el&.text&.strip
    next if header.nil? || header.empty?

    # Activities/resources within this section
    activities = []
    section.css(".activity, .activityinstance, li.activity").each do |activity|
      link = activity.css("a[href]").first
      next unless link

      name = link.css(".instancename, .aalink").first&.text&.strip
      name ||= link.text.strip
      # Moodle sometimes appends resource type text — clean it
      name = name.sub(/\s*(File|Page|URL|Quiz|Forum|Assignment)\s*$/, "").strip
      href = link["href"]

      next if name.empty? || href.nil?

      activities << {
        name: name,
        url: absolute_url(href),
        resource_type: extract_resource_type(name, href)
      }
    end

    sections << { header: header, activities: activities } unless activities.empty?
  end

  sections
end

# Determine if a section header is a Topic (e.g., "Topic A: ...")
def parse_topic_header(header)
  if header =~ /Topic\s+([A-Z])[\s:.-]+(.+)/i
    { letter: $1.upcase, title: $2.strip }
  end
end

# Determine if a section header is a Lesson (e.g., "Lesson 1", "Lesson 12")
def parse_lesson_header(header)
  if header =~ /Lesson\s+(\d+)/i
    { number: $1.to_i }
  end
end

# Organize flat sections into a structured module with topics and lessons
def structure_module(sections, module_info)
  mod = {
    number: module_info[:number],
    title: module_info[:title],
    resources: [],
    topics: []
  }

  current_topic = nil

  sections.each do |section|
    header = section[:header]
    activities = section[:activities]

    topic_match = parse_topic_header(header)
    lesson_match = parse_lesson_header(header)

    if topic_match
      current_topic = {
        letter: topic_match[:letter],
        title: topic_match[:title],
        resources: activities,
        lessons: []
      }
      mod[:topics] << current_topic
    elsif lesson_match
      lesson = {
        number: lesson_match[:number],
        resources: activities
      }
      if current_topic
        current_topic[:lessons] << lesson
      else
        # Lesson outside a topic — attach to module level
        mod[:resources] += activities
      end
    else
      # Module-level section (general info, mid/end-module reviews, etc.)
      if current_topic && header =~ /mid.?module/i
        # Mid-module review — attach to module level
        mod[:resources] += activities
      elsif current_topic && header =~ /end.?of.?module/i
        mod[:resources] += activities
      else
        mod[:resources] += activities
      end
    end
  end

  mod
end

# For each resource page on EMBARC, fetch it and extract the actual
# content URL (Google Drive link, YouTube embed, etc.)
def extract_content_url(resource)
  return nil unless resource[:url]&.include?("embarc.online")

  # Only fetch EMBARC pages (not external URLs)
  doc = fetch(resource[:url])
  return nil unless doc

  content_urls = []

  # Look for Google Drive/Docs links
  doc.css("a[href]").each do |link|
    href = link["href"]
    next unless href
    if href.include?("drive.google.com") ||
       href.include?("docs.google.com") ||
       href.include?("youtube.com") ||
       href.include?("youtu.be") ||
       href.include?("vimeo.com") ||
       href.include?("geogebra.org")
      content_urls << href
    end
  end

  # Look for iframe embeds (YouTube, Vimeo, etc.)
  doc.css("iframe[src]").each do |iframe|
    src = iframe["src"]
    content_urls << src if src
  end

  # Look for video/source elements
  doc.css("video source[src], video[src]").each do |video|
    src = video["src"]
    content_urls << src if src
  end

  content_urls.uniq
end

def scrape_grade_5
  $stderr.puts "Starting EMBARC Grade 5 scrape..."
  $stderr.puts "Output: #{OUTPUT_FILE}"
  $stderr.puts ""

  grade = {
    grade: 5,
    source: "EMBARC.Online",
    source_url: "https://embarc.online/course/index.php?categoryid=6",
    license: "CC BY-NC-SA 4.0",
    attribution: "This work by EMBARC.Online based upon Eureka Math and is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.",
    scraped_at: Time.now.utc.iso8601,
    modules: []
  }

  GRADE_5_MODULES.each do |course_id, module_info|
    url = "#{BASE_URL}/course/view.php?id=#{course_id}"
    $stderr.puts "\n== Module #{module_info[:number]}: #{module_info[:title]} =="
    $stderr.puts "   #{url}"

    doc = fetch(url)
    unless doc
      $stderr.puts "   FAILED to fetch module page, skipping."
      next
    end

    sections = parse_course_page(doc)
    $stderr.puts "   Found #{sections.length} sections"

    mod = structure_module(sections, module_info)
    mod[:embarc_url] = url
    mod[:embarc_course_id] = course_id

    grade[:modules] << mod
  end

  $stderr.puts "\n\n== Summary =="
  grade[:modules].each do |mod|
    topic_count = mod[:topics].length
    lesson_count = mod[:topics].sum { |t| t[:lessons].length }
    resource_count = mod[:resources].length +
                     mod[:topics].sum { |t| t[:resources].length } +
                     mod[:topics].sum { |t| t[:lessons].sum { |l| l[:resources].length } }
    $stderr.puts "  Module #{mod[:number]}: #{mod[:title]}"
    $stderr.puts "    #{topic_count} topics, #{lesson_count} lessons, #{resource_count} resources"
  end

  total_resources = grade[:modules].sum do |mod|
    mod[:resources].length +
    mod[:topics].sum { |t| t[:resources].length } +
    mod[:topics].sum { |t| t[:lessons].sum { |l| l[:resources].length } }
  end
  $stderr.puts "\n  TOTAL: #{total_resources} resources across #{grade[:modules].length} modules"
  $stderr.puts "  Requests made: #{$request_count}"

  grade
end

def deep_scrape_content_urls(grade)
  $stderr.puts "\n== Phase 2: Extracting content URLs from resource pages =="

  grade[:modules].each do |mod|
    all_resources = mod[:resources] +
                    mod[:topics].flat_map { |t| t[:resources] } +
                    mod[:topics].flat_map { |t| t[:lessons].flat_map { |l| l[:resources] } }

    # Only scrape EMBARC page resources (not direct external links)
    embarc_pages = all_resources.select { |r| r[:url]&.include?("embarc.online/mod/") }

    $stderr.puts "\n  Module #{mod[:number]}: #{embarc_pages.length} EMBARC pages to scrape for content URLs"

    embarc_pages.each do |resource|
      urls = extract_content_url(resource)
      resource[:content_urls] = urls if urls && !urls.empty?
    end
  end
end

# Main execution
if __FILE__ == $0
  FileUtils.mkdir_p(OUTPUT_DIR)

  # Phase 1: Scrape the Moodle structure
  grade = scrape_grade_5

  # Phase 2: Deep scrape content URLs from each resource page
  # This is optional and much slower — pass --deep to enable
  if ARGV.include?("--deep")
    deep_scrape_content_urls(grade)
  else
    $stderr.puts "\n  (Run with --deep to also extract content URLs from each resource page)"
  end

  # Write output
  File.write(OUTPUT_FILE, JSON.pretty_generate(grade))
  $stderr.puts "\n\nDone! Output written to #{OUTPUT_FILE}"
end
