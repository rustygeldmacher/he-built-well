require 'asciidoctor'
require 'asciidoctor/extensions'

module AsciidoctorExtensions
  # Extension that provides custom section number formatting based on the sectnumformat attribute
  class SectionNumberFormatterTreeProcessor < Asciidoctor::Extensions::TreeProcessor
    def process(document)
      # Only process if sectnums is enabled
      if document.attr?('sectnums')
        format_sections(document)
      end
      document
    end

    private

    def format_sections(node)
      # Process all section nodes recursively
      if node.context == :section && node.level > 0
        format_section_number(node)
      end

      # Process child nodes
      node.blocks.each { |block| format_sections(block) if block.respond_to?(:blocks) }
    end

    def format_section_number(section)
      # Skip if section has no number
      return unless section.numbered && section.caption.nil?

      # Get the sectnumformat for this section
      sectnumformat = section.document.attr('sectnumformat', '{sectnum}.')

      # Get the raw section number
      raw_sectnum = section.sectnum

      # Format the section number according to the specified format
      formatted_sectnum = format_number(raw_sectnum, sectnumformat)

      # Replace the section's caption with the formatted sectnum
      section.caption = formatted_sectnum
    end

    def format_number(sectnum, format)
      # Extract the number from the sectnum (remove trailing dot if present)
      number = sectnum.sub(/\.$/, '').split('.').last.to_i

      puts number

      case format
      when '(lower-roman)'
        # Convert to lowercase Roman numerals
        "#{to_roman(number).downcase}."
      when '(upper-roman)'
        # Convert to uppercase Roman numerals
        "#{to_roman(number)}."
      when '(lower-alpha)'
        # Convert to lowercase letters (a, b, c, ...)
        "#{to_alpha(number, false)}."
      when '(upper-alpha)'
        # Convert to uppercase letters (A, B, C, ...)
        "#{to_alpha(number, true)}."
      else
        # Use the format as a template, replacing {sectnum} with the section number
        format.gsub('{sectnum}', sectnum)
      end
    end

    def to_roman(num)
      roman_numerals = {
        1000 => "M", 900 => "CM", 500 => "D", 400 => "CD",
        100 => "C", 90 => "XC", 50 => "L", 40 => "XL",
        10 => "X", 9 => "IX", 5 => "V", 4 => "IV", 1 => "I"
      }

      result = ""
      roman_numerals.each do |value, letter|
        while num >= value
          result << letter
          num -= value
        end
      end
      result
    end

    def to_alpha(num, uppercase = true)
      base = uppercase ? 'A'.ord : 'a'.ord
      result = ""

      if num <= 0
        return ""
      elsif num <= 26
        result = (base + num - 1).chr
      else
        result = to_alpha((num - 1) / 26, uppercase) + (base + (num - 1) % 26).chr
      end

      result
    end
  end
end

# Register the extension
Asciidoctor::Extensions.register do
  tree_processor AsciidoctorExtensions::SectionNumberFormatterTreeProcessor
end
