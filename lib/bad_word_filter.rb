#!/usr/bin/env ruby

module BadWordFilter
  BAD_WORDS = {
    :fuck   => :fack, 
    :shit   => :shet, 
    :cunt   => :cont, 
    :dick   => :duck, 
    :nigger => :nogger,
  }

  def filter(name, verbose=false)
    original = name.dup
    BAD_WORDS.each_pair { |word,sub| name.gsub!(/#{word}/i, sub.to_s) }
    $stderr.puts "Warning: Bad Word: Changed '#{original}' into '#{name}'." if original != name && verbose
    name
  end
end
