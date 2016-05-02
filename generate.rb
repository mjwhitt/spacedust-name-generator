#!/usr/bin/env ruby

# Make it easier to select something from the arrays of data.
class Array
  def choose
    item = self.sample
    item.is_a?(Array) ? item.choose : item
  end
end

# Modified weights so higher chances of short names and lower chances of really long names.
LENGTH_CHANCES = [
  0, 0.00001, 0.0001, 0.001, 0.01,
  0.078889, 0.296667, 0.296667,
  0.128889, 0.088889, 0.0594445, 0.0394445,
]

# Choose a length for a name.
def choose_length
  choice = rand
  LENGTH_CHANCES.length.times { |i| return i+1 if choice <= LENGTH_CHANCES[0..i].inject(:+) }
end

# Combine and capitalize.
def format(n)
  n.join.split.map(&:capitalize).join(' ').gsub(/-(.)/, &:upcase)
end

# Names start with more variety than simple consonants or vowels.
@prefix = [
  [:''], # none, so start with vowel
  [:b,[:bl,:br]],
  [:c,[:cl,:cr,:ch]],
  [:d,[    :dr]],
  [:f,[:fl,:fr]],
  [:g,[:gl,:gr]],
  [:h,],
  [:j,],
  [:k,],
  [:l,],
  [:m,],
  [:n,],
  [:p,[:pl,:pr]],
  [:q,],
  [:r,],
  [:s,[:sh,[:sl,:sp,:st,:sk,:sm,:sn,:sw]]],
  [:t,[:tr]],
  [:v,],
  [:w,[:wh]],
  [:x,],
  [:y,],
  [:z,],
  [:'',[:ph,:th,[:tw,:vr,[:end,:scl,:scr,:shr,:sph,:spl,:spr,:sth,:str,:thr]]]]
]
# Simple consonants for the middle of names.
@consonants = [
  [:b,],
  [:c,],
  [:d,],
  [:f,],
  [:g,],
  [:l,],
  [:m,],
  [:n,],
  [:p,],
  [:r,],
  [:s,],
  [:t,],
  [:j,:k,:v,:x,:z],
  [:sh,:ch,:th],
  [:bb,:dd,:ff,:gg,:ll,:mm,:nn,:pp,:rr,:ss,:tt,:ck],
]

# Simple vowels for the middle of names.
@vowels = [
  [:a, [:a, :'a ',[:'a-',:'a\'']]],
  [:e, [:e, :'e ',[:'e-',:'e\'']]],
  [:i, [:i, :'i ',[:'i-',:'i\'']]],
  [:o, [:o, :'o ',[:'o-',:'o\'']]],
  [:u, [:u, :'u ',[:'u-',:'u\'']]],
  [
    [:ee,[:ee, :'ee ',[:'ee-',:'ee\'']]],
    [:oi,[:oi, :'oi ',[:'oi-',:'oi\'']]],
    [:oo,[:oo, :'oo ',[:'oo-',:'oo\'']]],
    [] # for rare combinations
  ]
]

# Add super rare vowel combinations to @vowels.
[
      :ae,:ai,:ao,:au,
  :ea,    :ei,:eo,:eu,
  :ia,:ie,    :io,:iu,
  :oa,:oe,        :ou,
  :ua,:ue,:ui,:uo,
  :ooa,:ooi,
].each { |c| @vowels.last.last << [c,["#{c} ",["#{c}-", "#{c}'"]]] }

# Name endings can be more varied, have numbers, or certain vowel combos.
@suffix = [
  # no ending (vowel)
  [:''],
  # vowel + number
  [:'',[:' #',:' #',:' #',:' ##']],
  # some sort of ending
  [
   # normal consonant combinations
   [:b,:be,[:b,:bble,:ble,[:by,:bby]]],
   [:c,:ce,[:ce,:cle,:ckle,[:cy,:cky]]],
   [:d,:de,[:d,:ddle,:dle,[:dy,:ddy]]],
   [:f,:ff,:fe,[:ff,:ffle,[:fy,:ffy]]],
   [:g,:ge,[:g,:ggle,:gle,[:gy,:ggy]]],
   [:k,:kk,:ke,[:ke,:kkle,[:ky,:kky]]],
   [:l,:ll,:le,[:ll,:lle,[:ly,:lly]]],
   [:m,:me,[:m,[:mle,:mmle,:my,:mmy]]],
   [:n,:ne,[:n,:nnle,:nle,[:ny,:nny]]],
   [:p,:pe,[:p,:pple,:ple,[:py,:ppy]]],
   [:r,:re,[:r,[:rle,:ry,:rry]]],
   [:s,:ss,:se,[:s,:ss,:sle,:ssle,[:sy,:ssy]]],
   [:t,:tt,:te,[:t,:tt,:tle,:ttle,[:ty,:tty]]],
   [:v,:ve,[:ve,:vle,:vy]],
   [:x,:xe,[:xe,:xle,[:xy,:xxy]]],
   [:z,:zz,:ze,[:z,:zz,:zle,:zzle,[:zy,:zzy]]],

   # rare consonant combinations
   [:ch,:sh,[:th,:ck,[:que,:j,:lk,:lt,:nd,:ng,:nk,:nt,:ph,:pt,:rk,:rt,:sk,:st,:ft,:gh,[:lb,:rb,:ld,:rd,:lf,:rf,:rl,:lm,:rm,:ln,:rn,:lp,:mp,:rp,:sp,:lch,:nch,:rch,:lsh,:rsh]]]],

   # rare vowels that can only appear at the end
   [:ay,:aw,:ah,:ey,:ew,:eh,:oy,:ow,:oh,:uy,:uh,:ooy,:ooh,:oow],
  ],
]

### Name Generator ###

def name(parts=[])
  if parts.empty?
    @length = choose_length
    @ending = @suffix.choose
    parts << @prefix.choose
    parts << @vowels.choose
  else
    parts << @consonants.choose
    
    # don't start with a double consonant
    parts[-1] = parts[-1].to_s.chop if @consonants.last.member?(parts[-1]) && parts[-2] =~ /[ \-']$/
    
    parts << @vowels.choose
  end

  if (parts + [@ending]).join.delete(" '-").size < @length
    name(parts)
  else
    # remove last vowel if ending is also a vowel
    parts.pop if @suffix[-1][-1].member?(@ending)

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

puts name while true
