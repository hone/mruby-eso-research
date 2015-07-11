Trait = Struct.new(:name, :researched, :item, :craft, :type, :piece)

class Trait
  def to_s
    <<STRING
craft: #{craft}
type: #{type}
piece: #{piece["name"]} (#{piece["description"]})
#{name}
researched: #{researched}
item: #{item}
STRING
  end
end
