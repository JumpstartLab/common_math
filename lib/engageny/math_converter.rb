require "plurimath"

module Engageny
  # Project-specific wrapper around Plurimath for OMML → MathML conversion.
  #
  # Handles edge cases in the EngageNY curriculum that Plurimath doesn't
  # support yet, and maintains a manifest of where fixes were applied
  # so humans can prioritize second-looks at that content.
  #
  # Each fix has a unique key (e.g., :strip_track_changes) used in the
  # manifest to identify what was done and why.
  class MathConverter
    Fix = Data.define(:key, :description)

    FIXES = {
      strip_track_changes: Fix.new(
        key: :strip_track_changes,
        description: "Stripped Word revision tracking markup (<m:ins>/<m:del>) from equation"
      ),
      sym_to_unicode: Fix.new(
        key: :sym_to_unicode,
        description: "Converted <m:sym> special symbol reference to Unicode character"
      )
    }.freeze

    attr_reader :manifest

    def initialize
      # Manifest tracks every fix applied: [{ fix:, file:, context:, omml_text: }]
      @manifest = []
    end

    # Convert a single OMML XML string to MathML.
    # Returns { mathml:, fixes: [] } on success, or { error:, omml: } on failure.
    def convert(omml_xml, file: nil, context: nil)
      fixes_applied = []
      xml = omml_xml.dup

      # Apply project-specific fixes in order
      xml, applied = try_strip_track_changes(xml)
      fixes_applied << applied if applied

      xml, applied = try_sym_to_unicode(xml)
      fixes_applied << applied if applied

      # Attempt Plurimath conversion (two-step: parse OMML, then render MathML)
      formula = Plurimath::Math.parse(xml, :omml)
      begin
        mathml = formula.to_mathml
      rescue => e
        # Parse succeeded but MathML rendering failed — still record as our fix
        raise Plurimath::Math::ParseError, "MathML rendering failed: #{e.message}"
      end

      # Record any fixes in the manifest
      fixes_applied.each do |fix|
        omml_text = extract_text(omml_xml)
        @manifest << {
          fix: fix.key,
          description: fix.description,
          file: file,
          context: context,
          omml_text: omml_text
        }
      end

      { mathml: mathml, fixes: fixes_applied.map(&:key) }
    rescue Plurimath::Math::ParseError => e
      omml_text = extract_text(omml_xml)
      @manifest << {
        fix: :unconverted,
        description: "Plurimath could not parse this expression",
        file: file,
        context: context,
        omml_text: omml_text,
        error: e.message[0, 200]
      }
      { error: e.message, omml: omml_xml }
    end

    # Write the manifest to a JSON file for human review.
    def write_manifest(path)
      require "json"
      File.write(path, JSON.pretty_generate({
        generated_at: Time.current.iso8601,
        summary: manifest_summary,
        entries: @manifest
      }))
    end

    def manifest_summary
      by_fix = @manifest.group_by { |m| m[:fix] }
      by_fix.transform_values(&:count)
    end

    private

    # Fix: Strip Word track changes markup from inside equations.
    # Track changes use <w:ins> and <w:del> (Word namespace, not math namespace)
    # to wrap content that was inserted/deleted during editing.
    # We keep only the final (inserted) content and discard deletions.
    def try_strip_track_changes(xml)
      # Check for ins/del in either namespace
      return [xml, nil] unless xml.match?(/(?:<[mw]:ins\b|<[mw]:del\b)/)

      doc = Nokogiri::XML(xml)
      word_ns = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
      math_ns = "http://schemas.openxmlformats.org/officeDocument/2006/math"

      changed = false

      # Remove <w:del> and <m:del> elements entirely (deleted content)
      [["w", word_ns], ["m", math_ns]].each do |prefix, ns|
        doc.xpath("//#{prefix}:del", prefix => ns).each do |del|
          del.remove
          changed = true
        end
      end

      # Unwrap <w:ins> and <m:ins> elements (keep children, remove wrapper)
      [["w", word_ns], ["m", math_ns]].each do |prefix, ns|
        doc.xpath("//#{prefix}:ins", prefix => ns).each do |ins|
          ins.children.each { |child| ins.add_previous_sibling(child) }
          ins.remove
          changed = true
        end
      end

      [doc.root.to_xml, changed ? FIXES[:strip_track_changes] : nil]
    end

    # Fix: Convert <m:sym> special symbol references to Unicode.
    # Word uses <m:sym m:font="Symbol" m:char="F0B4"/> for characters
    # from symbol fonts. Map them to their Unicode equivalents.
    # Map special symbol font characters to Unicode.
    # Word uses <w:sym w:font="Wingdings" w:char="F0E0"/> for characters
    # from symbol fonts. Keys are "Font:CharCode".
    SYMBOL_MAP = {
      # Wingdings
      "Wingdings:F0E0" => "\u2192",  # right arrow →
      "Wingdings:F0E8" => "\u2193",  # down arrow ↓
      "Wingdings:F0E7" => "\u2191",  # up arrow ↑
      "Wingdings:F0DF" => "\u2190",  # left arrow ←
      # Symbol font
      "Symbol:F0B4" => "\u00D7",    # multiplication sign ×
      "Symbol:F0B7" => "\u2022",    # bullet •
      "Symbol:F0B0" => "\u00B0",    # degree °
      "Symbol:F070" => "\u03C0",    # pi π
      "Symbol:F071" => "\u03B8",    # theta θ
      "Symbol:F044" => "\u0394",    # Delta Δ
      "Symbol:F053" => "\u03A3",    # Sigma Σ
    }.freeze

    def try_sym_to_unicode(xml)
      # <w:sym> lives in the Word namespace, not math namespace
      return [xml, nil] unless xml.match?(/(?:<[mw]:sym\b)/)

      doc = Nokogiri::XML(xml)
      changed = false

      # Search for sym in any namespace
      doc.xpath("//*[local-name()='sym']").each do |sym|
        font = sym["w:font"] || sym["font"]
        char_code = sym["w:char"] || sym["char"]
        next unless font && char_code

        key = "#{font}:#{char_code.upcase}"
        unicode = SYMBOL_MAP[key]

        if unicode
          # Replace <w:sym> with an <m:t> containing the Unicode char
          math_ns = "http://schemas.openxmlformats.org/officeDocument/2006/math"
          t = Nokogiri::XML::Node.new("m:t", doc)
          t.default_namespace = math_ns
          t.content = unicode
          sym.replace(t)
          changed = true
        else
          # Unknown symbol — record it but don't block conversion
          t = Nokogiri::XML::Node.new("m:t", doc)
          t.content = "[?#{font}:#{char_code}]"
          sym.replace(t)
          changed = true
        end
      end

      [doc.root.to_xml, changed ? FIXES[:sym_to_unicode] : nil]
    end

    def extract_text(omml_xml)
      doc = Nokogiri::XML(omml_xml)
      math_ns = "http://schemas.openxmlformats.org/officeDocument/2006/math"
      doc.xpath("//m:t", "m" => math_ns).map(&:text).join(" ")
    end
  end
end
