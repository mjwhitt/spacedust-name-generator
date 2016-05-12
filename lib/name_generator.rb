#!/usr/bin/env ruby

require 'name_parts'

class NameGenerator
  include NameParts

  # Modified weights so higher chances of short names and lower chances of really long names.
  LENGTH_CHANCES = [
    0, 0.00001, 0.0001, 0.001, 0.01,
    0.078889, 0.296667, 0.296667,
    0.128889, 0.088889, 0.0594445, 0.0394445,
  ]

  def inititialize(seed=nil)
  end

  def name(parts=[])
    if parts.empty?
      @length = choose_length
      @ending = SUFFIX.choose
      parts << PREFIX.choose
      parts << VOWELS.choose
    else
      parts << CONSONANTS.choose
      
      # don't start with a double consonant
      parts[-1] = parts[-1].to_s.chop if CONSONANTS.last.member?(parts[-1]) && parts[-2] =~ /[ \-']$/
      
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
  
      # apply numbers
      @ending.sub!(/#/, (rand(98)+2).to_s)
      @ending.sub!(/#/, (rand(98)+2).to_s)
  
      format(parts << @ending)
    end
  end

  # Choose a length for a name.
  def choose_length
    choice = rand
    LENGTH_CHANCES.length.times { |i| return i+1 if choice <= LENGTH_CHANCES[0..i].inject(:+) }
  end
  
  # Combine and capitalize.
  def format(n)
    n.join.split.map(&:capitalize).join(' ').gsub(/-(.)/, &:upcase)
  end

end
