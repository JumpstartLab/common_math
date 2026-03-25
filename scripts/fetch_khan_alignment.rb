#!/usr/bin/env ruby
# frozen_string_literal: true

# Builds the Khan Academy EngageNY Grade 5 alignment mapping.
#
# Khan Academy's site is a JavaScript SPA, so we can't scrape it directly.
# Instead, this script builds the mapping from their known URL structure,
# which follows a predictable pattern matching the EngageNY module/topic hierarchy.
#
# Usage:
#   ruby scripts/fetch_khan_alignment.rb
#
# Output: data/khan-academy-grade-5-alignment.json

require "json"

OUTPUT_PATH = File.expand_path("../data/khan-academy-grade-5-alignment.json", __dir__)
SITEMAP_PATH = File.expand_path("../data/embarc/grade-5-sitemap.json", __dir__)

BASE_URL = "https://www.khanacademy.org/math/5th-engage-ny"

# Khan Academy URL slugs for each module
MODULE_SLUGS = {
  1 => "engage-5th-module-1",
  2 => "engage-5th-module-2",
  3 => "engage-5th-module-3",
  4 => "engage-5th-module-4",
  5 => "engage-5th-module-5",
  6 => "engage-5th-module-6"
}.freeze

# Read the EMBARC sitemap to get accurate module/topic titles
sitemap = JSON.parse(File.read(SITEMAP_PATH))

modules = []

sitemap["modules"].each do |mod|
  mod_num = mod["number"]
  next if mod_num == 0 # Skip general resources

  mod_slug = MODULE_SLUGS[mod_num]
  mod_url = "#{BASE_URL}/#{mod_slug}"

  topics = (mod["topics"] || []).map do |topic|
    topic_slug = "5th-module-#{mod_num}-topic-#{topic['letter'].downcase}"
    {
      letter: topic["letter"],
      title: topic["title"],
      khan_url: "#{BASE_URL}/#{mod_slug}/#{topic_slug}"
    }
  end

  modules << {
    number: mod_num,
    title: mod["title"],
    khan_url: mod_url,
    topics: topics
  }
end

output = {
  source: "Khan Academy",
  course_url: BASE_URL,
  grade: 5,
  generated_at: Time.now.utc.iso8601,
  note: "URLs follow Khan Academy's predictable pattern for EngageNY-aligned content. " \
        "Topic titles sourced from EMBARC sitemap. Some URLs may not resolve if Khan Academy " \
        "doesn't have content for every topic.",
  modules: modules
}

File.write(OUTPUT_PATH, JSON.pretty_generate(output))

$stderr.puts "Done! #{modules.length} modules, #{modules.sum { |m| m[:topics].length }} topics"
$stderr.puts "Written to #{OUTPUT_PATH}"
modules.each do |m|
  $stderr.puts "  M#{m[:number]}: #{m[:title]} (#{m[:topics].length} topics)"
end
