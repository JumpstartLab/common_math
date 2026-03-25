namespace :khan do
  desc "Import Khan Academy EngageNY alignment links as supplemental resources"
  task import: :environment do
    path = Rails.root.join("data/khan-academy-grade-5-alignment.json")
    data = JSON.parse(File.read(path))

    grade = Grade.find_by(number: data["grade"])
    unless grade
      puts "ERROR: Grade #{data['grade']} not found. Run rake engageny:import first."
      exit 1
    end

    created = 0
    skipped = 0

    data["modules"].each do |mod_data|
      content_module = grade.content_modules.find_by(number: mod_data["number"])
      unless content_module
        puts "  WARNING: Module #{mod_data['number']} not found, skipping"
        next
      end

      # Module-level Khan link
      existing = content_module.supplemental_resources.find_by(source: "khan_academy", resource_type: "khan_practice")
      if existing
        skipped += 1
      else
        content_module.supplemental_resources.create!(
          source: "khan_academy",
          resource_type: "khan_practice",
          title: "Khan Academy: #{mod_data['title']}",
          url: mod_data["khan_url"],
          position: 1
        )
        created += 1
      end

      # Topic-level Khan links
      (mod_data["topics"] || []).each do |topic_data|
        topic = content_module.topics.find_by(letter: topic_data["letter"])
        unless topic
          puts "  WARNING: Topic #{topic_data['letter']} in Module #{mod_data['number']} not found"
          next
        end

        existing = topic.supplemental_resources.find_by(source: "khan_academy", resource_type: "khan_practice")
        if existing
          skipped += 1
        else
          topic.supplemental_resources.create!(
            source: "khan_academy",
            resource_type: "khan_practice",
            title: "Khan Academy: #{topic_data['title']}",
            url: topic_data["khan_url"],
            position: 1
          )
          created += 1
        end
      end
    end

    puts "Done! Created: #{created}, Skipped: #{skipped}"
    puts "Khan Academy resources: #{SupplementalResource.where(source: 'khan_academy').count}"
  end

  desc "Clear all Khan Academy supplemental resources"
  task clear: :environment do
    count = SupplementalResource.where(source: "khan_academy").delete_all
    puts "Deleted #{count} Khan Academy resources."
  end
end
