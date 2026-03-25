require "ferrum"

module Engageny
  class PdfRenderer
    CHROME_PATH = if File.exist?("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")
      "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    end

    # Render HTML string to PDF bytes using headless Chrome.
    # Chrome's print engine respects @page CSS rules (size, margins)
    # which Aspose embeds to match the original Word layout.
    def self.render(html)
      browser = Ferrum::Browser.new(
        browser_path: CHROME_PATH,
        headless: "new",
        timeout: 30
      )

      begin
        browser.goto("data:text/html;charset=utf-8,#{ERB::Util.url_encode(html)}")

        # Wait for page to fully render (images, fonts)
        browser.network.wait_for_idle

        # Print to PDF using Chrome's built-in print.
        # preferCSSPageSize: true tells Chrome to use the @page size/margin
        # rules from the HTML rather than its own defaults.
        base64 = browser.pdf(
          preferCSSPageSize: true,
          printBackground: true
        )
        Base64.decode64(base64)
      ensure
        browser.quit
      end
    end

    # Render to a file instead of returning bytes.
    def self.render_to_file(html, output_path)
      pdf_bytes = render(html)
      File.binwrite(output_path, pdf_bytes)
      output_path
    end
  end
end
