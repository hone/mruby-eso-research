Trait = Struct.new(:name, :researched, :item, :craft, :type, :piece)

class Trait
  def to_s
    string = <<STRING
craft: #{craft}
type: #{type}
piece: #{piece["name"]} (#{piece["description"]})
name: #{name}
researched: #{researched}
STRING

    if item
      "#{string}item: #{item}\n"
    else
      string
    end
  end
end
