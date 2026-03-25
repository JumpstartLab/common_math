namespace :embarc do
  desc "Import EMBARC Grade 5 sitemap into supplemental_resources"
  task import: :environment do
    sitemap_path = Rails.root.join("data/embarc/grade-5-sitemap.json")

    unless File.exist?(sitemap_path)
      puts "ERROR: #{sitemap_path} not found."
      puts "Run `ruby scripts/scrape_embarc.rb` first."
      exit 1
    end

    data = JSON.parse(File.read(sitemap_path))
    grade_number = data["grade"]
    source = "embarc"

    grade = Grade.find_by(number: grade_number)
    unless grade
      puts "ERROR: Grade #{grade_number} not found in database."
      puts "Run `rake engageny:import` first."
      exit 1
    end

    created = 0
    skipped = 0
    orphaned = 0

    data["modules"].each do |mod_data|
      mod_number = mod_data["number"]

      # Module 0 = general resources, attach to Grade
      if mod_number == 0
        mod_data["resources"].each_with_index do |res, i|
          created += import_resource(grade, res, source, i + 1)
        end
        next
      end

      content_module = grade.content_modules.find_by(number: mod_number)
      unless content_module
        puts "  WARNING: Module #{mod_number} not found, skipping #{mod_data['resources'].length} module-level resources"
        orphaned += mod_data["resources"].length
        next
      end

      # Module-level resources (Eureka Essentials, mid/end reviews, etc.)
      mod_data["resources"].each_with_index do |res, i|
        created += import_resource(content_module, res, source, i + 1)
      end

      # Topics and their resources
      (mod_data["topics"] || []).each do |topic_data|
        topic = content_module.topics.find_by(letter: topic_data["letter"])
        unless topic
          total = (topic_data["resources"]&.length || 0) +
                  (topic_data["lessons"] || []).sum { |l| l["resources"]&.length || 0 }
          puts "  WARNING: Topic #{topic_data['letter']} in Module #{mod_number} not found, skipping #{total} resources"
          orphaned += total
          next
        end

        # Topic-level resources (parent newsletters, quizzes, etc.)
        (topic_data["resources"] || []).each_with_index do |res, i|
          created += import_resource(topic, res, source, i + 1)
        end

        # Lesson resources
        (topic_data["lessons"] || []).each do |lesson_data|
          lesson = topic.lessons.find_by(number: lesson_data["number"])
          unless lesson
            puts "  WARNING: Lesson #{lesson_data['number']} in Topic #{topic_data['letter']}, Module #{mod_number} not found, skipping #{lesson_data['resources']&.length || 0} resources"
            orphaned += (lesson_data["resources"]&.length || 0)
            next
          end

          (lesson_data["resources"] || []).each_with_index do |res, i|
            created += import_resource(lesson, res, source, i + 1)
          end
        end
      end
    end

    puts "\nDone!"
    puts "  Created: #{created}"
    puts "  Skipped (already exist): #{skipped}"
    puts "  Orphaned (no matching curriculum record): #{orphaned}"
    puts "  Total supplemental resources: #{SupplementalResource.count}"

    # Summary by resource type
    puts "\nBy resource type:"
    SupplementalResource.from_source(source).group(:resource_type).count
      .sort_by { |_, v| -v }
      .each { |type, count| puts "  #{type}: #{count}" }

    # Summary by attachment level
    puts "\nBy attachment level:"
    SupplementalResource.from_source(source).group(:resourceable_type).count
      .each { |type, count| puts "  #{type}: #{count}" }
  end

  desc "Clear all EMBARC supplemental resources"
  task clear: :environment do
    count = SupplementalResource.where(source: "embarc").delete_all
    puts "Deleted #{count} EMBARC supplemental resources."
  end

  desc "Show stats for imported EMBARC resources"
  task stats: :environment do
    total = SupplementalResource.where(source: "embarc").count
    puts "EMBARC supplemental resources: #{total}"

    if total > 0
      puts "\nBy resource type:"
      SupplementalResource.where(source: "embarc").group(:resource_type).count
        .sort_by { |_, v| -v }
        .each { |type, count| puts "  #{type}: #{count}" }

      puts "\nBy attachment level:"
      SupplementalResource.where(source: "embarc").group(:resourceable_type).count
        .each { |type, count| puts "  #{type}: #{count}" }

      with_content_urls = SupplementalResource.where(source: "embarc").where.not(url: nil).count
      puts "\nWith external URLs: #{with_content_urls}"

      with_content = SupplementalResource.where(source: "embarc").where.not(content_html: nil).count
      puts "With inline content: #{with_content}"
    end
  end
end

def import_resource(parent, res_data, source, position)
  resource_type = res_data["resource_type"] || "other"
  title = res_data["name"]
  return 0 if title.blank?

  # Determine the best URL: prefer extracted content_urls, fall back to EMBARC page URL
  content_urls = res_data["content_urls"] || []
  external_url = content_urls.first
  embarc_url = res_data["url"]

  existing = parent.supplemental_resources.find_by(
    resource_type: resource_type,
    source: source,
    title: title
  )

  if existing
    # Update if we have new data
    updates = {}
    updates[:url] = external_url if external_url.present? && existing.url.blank?
    updates[:source_page_url] = embarc_url if embarc_url.present? && existing.source_page_url.blank?
    existing.update(updates) if updates.any?
    return 0
  end

  parent.supplemental_resources.create!(
    resource_type: resource_type,
    source: source,
    title: title,
    url: external_url,
    source_page_url: embarc_url,
    position: position
  )
  1
rescue ActiveRecord::RecordInvalid => e
  puts "  ERROR creating resource '#{title}': #{e.message}"
  0
end
