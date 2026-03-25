#!/usr/bin/env ruby
# frozen_string_literal: true

# Fetches YouTube metadata for all EMBARC lesson videos via the noembed oEmbed API.
#
# Usage:
#   ruby scripts/fetch_video_metadata.rb
#
# Input:  data/embarc/grade-5-sitemap.json
# Output: data/embarc/grade-5-video-metadata.json
#
# Rate limited to 1 request per second.

require "open-uri"
require "json"

SITEMAP_PATH = File.expand_path("../data/embarc/grade-5-sitemap.json", __dir__)
OUTPUT_PATH = File.expand_path("../data/embarc/grade-5-video-metadata.json", __dir__)
OEMBED_URL = "https://www.noembed.com/embed?url="
DELAY = 1.0

sitemap = JSON.parse(File.read(SITEMAP_PATH))

# Collect all video resources with their module/lesson context
videos = []

sitemap["modules"].each do |mod|
  (mod["topics"] || []).each do |topic|
    (topic["lessons"] || []).each do |lesson|
      (lesson["resources"] || []).each do |resource|
        next unless resource["resource_type"] == "video"

        (resource["content_urls"] || []).each do |url|
          match = url.match(%r{youtube\.com/embed/([^&?/]+)})
          next unless match

          videos << {
            video_id: match[1],
            embed_url: url,
            module_number: mod["number"],
            lesson_number: lesson["number"]
          }
        end
      end
    end
  end
end

$stderr.puts "Found #{videos.length} videos to fetch metadata for"

results = []
errors = 0

videos.each_with_index do |video, i|
  sleep(DELAY) if i > 0

  watch_url = "https://www.youtube.com/watch?v=#{video[:video_id]}"
  api_url = "#{OEMBED_URL}#{URI.encode_www_form_component(watch_url)}"

  $stderr.print "\r  [#{i + 1}/#{videos.length}] #{video[:video_id]}"

  begin
    response = URI.open(api_url).read
    meta = JSON.parse(response)

    results << {
      video_id: video[:video_id],
      title: meta["title"],
      author_name: meta["author_name"],
      author_url: meta["author_url"],
      thumbnail_url: meta["thumbnail_url"],
      embed_url: video[:embed_url],
      watch_url: watch_url,
      module: video[:module_number],
      lesson: video[:lesson_number]
    }
  rescue StandardError => e
    $stderr.puts "\n  ERROR #{video[:video_id]}: #{e.message}"
    errors += 1
    results << {
      video_id: video[:video_id],
      title: nil,
      author_name: nil,
      author_url: nil,
      thumbnail_url: nil,
      embed_url: video[:embed_url],
      watch_url: watch_url,
      module: video[:module_number],
      lesson: video[:lesson_number],
      error: e.message
    }
  end
end

output = {
  fetched_at: Time.now.utc.iso8601,
  total_videos: results.length,
  videos: results
}

File.write(OUTPUT_PATH, JSON.pretty_generate(output))
$stderr.puts "\n\nDone! #{results.length} videos written to #{OUTPUT_PATH}"
$stderr.puts "Errors: #{errors}" if errors > 0
