namespace :ccss do
  desc "Import Common Core State Standards from JSON"
  task import: :environment do
    path = Rails.root.join("data/ccss-math-grades-4-6.json")
    data = JSON.parse(File.read(path))

    created = 0
    skipped = 0

    data["standards"].each do |s|
      existing = Standard.find_by(code: s["code"])
      if existing
        skipped += 1
        next
      end

      Standard.create!(
        code: s["code"],
        domain: s["domain"],
        cluster: s["cluster"],
        description: s["description"],
        grade_level: s["grade_level"]
      )
      created += 1
    end

    puts "Done! Created: #{created}, Skipped: #{skipped}"
    puts "Total standards: #{Standard.count}"
    Standard.group(:grade_level).count.sort.each { |g, c| puts "  Grade #{g}: #{c}" }
  end
end
