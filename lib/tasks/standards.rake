namespace :standards do
  desc "Tag topics (and their lessons) with CCSS focus standards parsed from EngageNY overview HTML"
  task tag_focus: :environment do
    report = Engageny::FocusStandardTagger::Report.new
    topics_with_html = 0
    topics_without_html = 0

    Topic.find_each do |topic|
      if topic.overview_html.blank?
        topics_without_html += 1
        next
      end

      topics_with_html += 1
      report.merge!(Engageny::FocusStandardTagger.tag_topic!(topic))
    end

    puts "Topics with overview HTML: #{topics_with_html}"
    puts "Topics without overview HTML (skipped): #{topics_without_html}"
    puts "Topic taggings created: #{report.topic_taggings}"
    puts "Lesson taggings created: #{report.lesson_taggings}"

    if report.unresolved.any?
      puts "\nUnresolved codes (no matching Standard row):"
      report.unresolved.sort_by { |_code, count| -count }.each do |code, count|
        puts "  #{code} (#{count})"
      end

      report_path = Rails.root.join("tmp/standards_tag_focus_unresolved.txt")
      File.write(report_path, report.unresolved.sort_by { |_code, count| -count }.map { |code, count| "#{code}\t#{count}" }.join("\n") + "\n")
      puts "\nWrote unresolved-code report to #{report_path}"
    else
      puts "\nNo unresolved codes."
    end
  end
end
