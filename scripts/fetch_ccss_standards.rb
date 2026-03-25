#!/usr/bin/env ruby
# frozen_string_literal: true

# Fetches Common Core State Standards for Mathematics (Grades 4-6) from the
# SirFizX/standards-data GitHub repo and structures them for CommonMath.
#
# Usage:
#   ruby scripts/fetch_ccss_standards.rb
#
# Output: data/ccss-math-grades-4-6.json

require "open-uri"
require "json"

OUTPUT_PATH = File.expand_path("../data/ccss-math-grades-4-6.json", __dir__)
SOURCE_URL = "https://raw.githubusercontent.com/SirFizX/standards-data/master/clean-data/CC/math/CC-math-0.8.0.json"

DOMAIN_NAMES = {
  "OA" => "Operations and Algebraic Thinking",
  "NBT" => "Number and Operations in Base Ten",
  "NF" => "Number and Operations—Fractions",
  "MD" => "Measurement and Data",
  "G" => "Geometry",
  "RP" => "Ratios and Proportional Relationships",
  "NS" => "The Number System",
  "EE" => "Expressions and Equations",
  "SP" => "Statistics and Probability"
}.freeze

TARGET_GRADES = %w[04 05 06].freeze
TARGET_GRADE_INTS = [4, 5, 6].freeze

$stderr.puts "Fetching CCSS data from #{SOURCE_URL}..."
raw = URI.open(SOURCE_URL).read
all_entries = JSON.parse(raw)

$stderr.puts "Parsing #{all_entries.length} total entries..."

# First pass: build cluster lookup (code => statement)
# Clusters have cls: "folder" and codes like "Math.5.OA.A"
clusters = {}
all_entries.each do |entry|
  next unless entry["cls"] == "folder"
  next unless entry["code"]

  grade_levels = entry["gradeLevels"] || []
  next unless (grade_levels & TARGET_GRADES).any?

  clusters[entry["code"]] = entry["statement"]
end

$stderr.puts "Found #{clusters.length} clusters for grades 4-6"

# Second pass: extract leaf standards
standards = []
all_entries.each do |entry|
  # Only leaf standards
  next unless entry.dig("ASN", "leaf") == "true"
  next unless entry["code"]

  grade_levels = entry["gradeLevels"] || []
  next unless (grade_levels & TARGET_GRADES).any?
  next unless entry["subject"] == "Math"

  code = entry["shortCode"] || entry["code"].sub(/^Math\./, "")
  full_code = entry["code"]

  # Parse: "5.OA.1" => grade=5, domain_code="OA"
  # Or: "5.NF.4a" => grade=5, domain_code="NF"
  parts = code.split(".")
  next unless parts.length >= 3

  grade = parts[0].to_i
  next unless TARGET_GRADE_INTS.include?(grade)

  domain_code = parts[1]
  domain_name = DOMAIN_NAMES[domain_code] || domain_code

  # Find the parent cluster by looking for the cluster code pattern
  # Standard "Math.5.OA.1" belongs to cluster "Math.5.OA.A"
  # We find it via the ASN parent ID, or infer from code structure
  cluster_statement = nil
  asn_parent = entry.dig("ASN", "parent")
  if asn_parent
    # Find the cluster entry with this ASN id
    cluster_entry = all_entries.find { |e| e.dig("ASN", "id") == asn_parent || e["asnIdentifier"] == asn_parent }
    cluster_statement = cluster_entry["statement"] if cluster_entry
  end

  description = entry["statement"]
  # Append clarifications if present
  if entry["clarifications"]&.any?
    description += " " + entry["clarifications"].join(" ")
  end

  standards << {
    code: code,
    domain: domain_name,
    domain_code: domain_code,
    cluster: cluster_statement,
    description: description,
    grade_level: grade
  }
end

# Sort by grade, domain, then code
standards.sort_by! { |s| [s[:grade_level], s[:domain_code], s[:code]] }

output = {
  source: "Common Core State Standards via SirFizX/standards-data (GitHub)",
  source_url: SOURCE_URL,
  fetched_at: Time.now.utc.iso8601,
  standards: standards
}

File.write(OUTPUT_PATH, JSON.pretty_generate(output))

$stderr.puts "\nDone! #{standards.length} standards written to #{OUTPUT_PATH}"
TARGET_GRADE_INTS.each do |g|
  grade_standards = standards.select { |s| s[:grade_level] == g }
  domains = grade_standards.map { |s| s[:domain_code] }.uniq.sort
  $stderr.puts "  Grade #{g}: #{grade_standards.length} standards (#{domains.join(', ')})"
end

# Show a sample
sample = standards.find { |s| s[:code] == "5.OA.1" }
if sample
  $stderr.puts "\nSample (5.OA.1):"
  $stderr.puts "  Domain: #{sample[:domain]}"
  $stderr.puts "  Cluster: #{sample[:cluster]}"
  $stderr.puts "  Description: #{sample[:description][0..80]}..."
end
