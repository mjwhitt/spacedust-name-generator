#!/usr/bin/env ruby

# Make it easier to select something from the arrays of data.
class Array
  def setrng(rng)
    @rng = rng
  end

  def choose
    item = self.sample(random: @rng)
    item.is_a?(Array) ? item.choose_sub(@rng) : item
  end

  def choose_sub(rng)
    item = self.sample(random: rng)
    item.is_a?(Array) ? item.choose_sub(rng) : item
  end
end

module NameParts

  def setrng(rng)
    PREFIX.setrng(rng)
    CONSONANTS.setrng(rng)
    VOWELS.setrng(rng)
    SUFFIX.setrng(rng)
  end

  # Names start with more variety than simple consonants or vowels.
  PREFIX = [
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
  CONSONANTS = [
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
  VOWELS = [
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
  
  # Add super rare vowel combinations to VOWELS.
  [
        :ae,:ai,:ao,:au,
    :ea,    :ei,:eo,:eu,
    :ia,:ie,    :io,:iu,
    :oa,:oe,        :ou,
    :ua,:ue,:ui,:uo,
    :ooa,:ooi,
  ].each { |c| VOWELS.last.last << [c,["#{c} ",["#{c}-", "#{c}'"]]] }
  
  # Name endings can be more varied, have numbers, or certain vowel combos.
  SUFFIX = [
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

end
