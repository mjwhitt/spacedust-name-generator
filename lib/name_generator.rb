#!/usr/bin/env ruby

require 'name_parts'
require 'bad_word_filter'

class NameGenerator
  include NameParts
  include BadWordFilter

  # Modified weights so higher chances of short names and lower chances of really long names.
  LENGTH_CHANCES = [ 0, 0.00001, 0.0001, 0.001, 0.00889, 0.09, 0.30, 0.30, 0.12, 0.09, 0.06, 0.03 ]

  def initialize(options)
    @options = options
    @rng = @options[:seed].nil? ? Random.new : Random.new(@options[:seed])
    setrng(@rng)
  end

  def name(parts=[])
    if parts.empty?
      @length = @options[:length].nil? ? choose_length : @options[:length]
      @ending = @options[:suffix].nil? ? SUFFIX.choose : @options[:suffix].dup
      parts << (@options[:prefix].nil? ? PREFIX.choose : @options[:prefix].dup)
      parts << VOWELS.choose
    else
      parts << CONSONANTS.choose
      
      # don't start with a double consonant
      parts[-1] = parts[-1].to_s.reverse.chop if CONSONANTS.last.member?(parts[-1]) && parts[-2] =~ /[ \-']$/
      
      parts << VOWELS.choose
    end
  
    if (parts + [@ending]).join.delete(" '-").size < @length
      name(parts)
    else
      # remove last vowel if ending is also a vowel
      parts.pop if SUFFIX[-1][-1].member?(@ending)
  
      # don't end with a dash or apostrophe
      parts[-1] = parts.last.to_s.sub(/-/, '')
      parts[-1] = parts.last.to_s.sub(/'/, '')
      
      @ending = @ending.to_s
  
      # don't end with a space before @ending unless @ending is one character
      parts[-1] = parts.last.to_s.sub(/ /, '') unless @ending.size == 1
 
      if @options[:simple]
        format(parts << @ending).gsub(/[@# \-']/, "").capitalize
      else
        # apply numbers
        @ending.sub!(/#/, (@rng.rand(98)+2).to_s)
        @ending.sub!(/#/, (@rng.rand(98)+2).to_s)

        # format then apply roman numerals
        format(parts << @ending).sub(/@/, (@rng.rand(19)+1).to_roman)
      end
    end
  end

  # Choose a length for a name.
  def choose_length
    choice = @rng.rand
    LENGTH_CHANCES.length.times { |i| return i+1 if choice <= LENGTH_CHANCES[0..i].inject(:+) }
  end
  
  # Combine and capitalize.
  def format(n)
    (@options[:filter] ? filter(n.join, @options[:verbose]) : n.join).split.map(&:capitalize).join(' ').gsub(/-(.)/, &:upcase)
  end

end
