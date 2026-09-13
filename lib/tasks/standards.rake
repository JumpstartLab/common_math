def print_retarget_report(report)
  puts "Target framework: #{report.target_framework}"
  puts "Stored (confirmed exact/grade_shifted) rows: #{report.stored}"
  puts "Rows with no confirmed match: #{report.no_confirmed_match.size}"
  report.no_confirmed_match.each { |item_id| puts "  #{item_id}" }

  if report.invalid.any?
    puts "Invalid rows: #{report.invalid.size}"
    report.invalid.each { |row| puts "  #{row[:item_id]}: #{row[:error]}" }
  end

  puts "Marked stale (no longer confirmed): #{report.stale}" if report.stale.positive?
end

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

  desc "Submit every CCSS StandardTagging to Interstandard for TARGET_FRAMEWORK and store confirmed state matches"
  task :retarget, [ :target_framework ] => :environment do |_, args|
    target_framework = args[:target_framework]
    abort "Usage: bin/rails 'standards:retarget[target-framework-slug]'" if target_framework.blank?

    print_retarget_report(Standards::Retargeter.new.call(target_framework))
  end

  desc "Run standards:retarget for every framework in INTERSTANDARD_TARGETS (default: co-math-2020,tx-teks-math)"
  task retarget_all: :environment do
    Interstandard::DEFAULT_TARGETS.each do |target_framework|
      puts "== #{target_framework} =="
      print_retarget_report(Standards::Retargeter.new.call(target_framework))
      puts
    end
  end

  desc "Print, per target framework, the fraction of a grade's lessons with a confirmed state code (default grade: 5; pass 'all' for every grade)"
  task :coverage, [ :grade ] => :environment do |_, args|
    grade_arg = args[:grade].presence || "5"
    grade_numbers = grade_arg == "all" ? Grade.order(:number).pluck(:number) : [ Integer(grade_arg) ]

    Interstandard::DEFAULT_TARGETS.each do |framework|
      grade_numbers.each do |grade_number|
        result = Standards::Coverage.call(framework: framework, grade_number: grade_number)
        puts "#{framework} (grade #{grade_number}): #{result.with_confirmed}/#{result.total} lessons (#{result.percent}%)"
      end
    end
  end
end
