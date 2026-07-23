require "ferrum"
require "fileutils"

module Engageny
  class PageComparator
    CHROME_PATH = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    OUTPUT_DIR = Rails.root.join("tmp/pdf-compare")
    DPI = 150

    def initialize(lesson)
      @lesson = lesson
    end

    # Run the full comparison:
    # 1. Render original PDF to PNGs
    # 2. Screenshot our HTML page-by-page
    # 3. Diff each pair with ImageMagick
    def compare!
      FileUtils.mkdir_p(OUTPUT_DIR)

      render_original_pdf
      screenshot_html
      generate_diffs
    end

    # Screenshot just the HTML (for iterating on CSS without re-rendering PDF)
    def screenshot_html
      lesson = @lesson
      controller = LessonsController.new
      # Build the HTML with injected page styles
      html = lesson.reconstructed_html
      page_css = Rails.root.join("app/assets/stylesheets/engageny_pages.css").read
      style_tag = "<style>#{page_css}</style>"
      html = html.sub("</head>", "#{style_tag}</head>").sub("<body", '<body class="engageny-pages"')

      browser = Ferrum::Browser.new(
        browser_path: CHROME_PATH,
        headless: "new",
        timeout: 30,
        window_size: [ 900, 1200 ]
      )

      begin
        browser.goto("data:text/html;charset=utf-8,#{ERB::Util.url_encode(html)}")
        browser.network.wait_for_idle

        # Screenshot the full page
        browser.screenshot(
          path: OUTPUT_DIR.join("html-full.png").to_s,
          full: true
        )
      ensure
        browser.quit
      end

      # Now split into page-sized chunks using ImageMagick
      # Each page is 612pt × 792pt. At 150 DPI, that's ~1275 × 1650 pixels
      # But our CSS renders at screen resolution, so we need to measure actual rendered size
      puts "HTML screenshot saved to #{OUTPUT_DIR}/html-full.png"
    end

    private

    def render_original_pdf
      return if Dir.glob(OUTPUT_DIR.join("original-*.png")).any?

      pdf_path = find_original_pdf
      unless pdf_path
        puts "No original PDF found — skipping PDF render"
        return
      end

      system("pdftoppm", pdf_path.to_s, OUTPUT_DIR.join("original").to_s, "-png", "-r", DPI.to_s)
      puts "Original PDF rendered to PNGs"
    end

    def find_original_pdf
      # Try to extract from the ZIP archive
      source = @lesson.source_file
      return nil unless source

      # Derive the PDF path from the HTML path
      pdf_name = File.basename(source, ".html") + ".pdf"
      grade_num = @lesson.topic.content_module.grade.number
      mod_num = @lesson.topic.content_module.number

      zip_path = Rails.root.join(
        "..", "concept-research", "paper-math-companion", "resources", "engageny",
        "grade-#{grade_num}", "Grade #{grade_num} Module #{mod_num}.zip"
      )

      return nil unless zip_path.exist?

      # Find the PDF inside the ZIP
      output = `unzip -l "#{zip_path}" 2>/dev/null | grep "#{pdf_name}" | grep -v Archived`
      return nil if output.strip.empty?

      # Extract the path from the unzip listing
      zip_entry = output.strip.split(/\s+/, 4).last
      return nil unless zip_entry

      dest = OUTPUT_DIR.join("original.pdf")
      system("unzip", "-o", zip_path.to_s, zip_entry, "-d", OUTPUT_DIR.to_s)

      extracted = OUTPUT_DIR.join(zip_entry)
      FileUtils.cp(extracted, dest) if extracted.exist?
      dest.exist? ? dest : nil
    end

    def generate_diffs
      originals = Dir.glob(OUTPUT_DIR.join("original-*.png")).sort
      return if originals.empty?

      puts "Generating diffs..."
      puts "Original pages: #{originals.count}"
      puts "HTML screenshot: #{OUTPUT_DIR}/html-full.png"
      puts "\nTo compare visually, open both in Preview:"
      puts "  open #{OUTPUT_DIR}/original-01.png #{OUTPUT_DIR}/html-full.png"
    end
  end
end
