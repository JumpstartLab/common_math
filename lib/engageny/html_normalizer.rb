require "nokogiri"

module Engageny
  class HtmlNormalizer
    # Normalize Aspose-generated HTML to remove meaningless whitespace
    # while preserving all rendering-significant content.
    #
    # Uses Nokogiri to walk the DOM and strip whitespace-only text nodes
    # that exist purely for indentation (between block elements).
    # Inline whitespace (e.g., space between spans) is preserved.
    def self.normalize(html)
      # Normalize line endings before parsing
      html = html.gsub("\r\n", "\n")

      doc = Nokogiri::HTML4(html)

      # Remove whitespace-only text nodes between block elements
      doc.xpath("//text()").each do |text_node|
        next unless text_node.content.match?(/\A\s+\z/)

        parent = text_node.parent
        prev_sib = text_node.previous_sibling
        next_sib = text_node.next_sibling

        if block_context?(parent) || (block_element?(prev_sib) && block_element?(next_sib))
          text_node.remove
        end
      end

      # Serialize without the DOCTYPE that Nokogiri adds
      result = doc.at_css("html").to_html
      result = "<html>\n#{result.sub(/\A<html>/, "")}" unless result.start_with?("<html")
      result
    end

    BLOCK_PARENTS = %w[body div table tr thead tbody tfoot head html].to_set.freeze
    BLOCK_ELEMENTS = %w[div p table tr td th thead tbody tfoot h1 h2 h3 h4 h5 h6
                        ul ol li blockquote pre hr br meta link style title].to_set.freeze

    def self.block_context?(node)
      node&.element? && BLOCK_PARENTS.include?(node.name)
    end

    def self.block_element?(node)
      node&.element? && BLOCK_ELEMENTS.include?(node.name)
    end
  end
end
