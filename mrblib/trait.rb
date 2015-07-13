Trait = Struct.new(:name, :researched, :item, :piece)

class Trait
  def to_s
    string = <<STRING
craft: #{piece.type.craft.name}
type: #{piece.type.name}
piece: #{piece.name} (#{piece.description})
trait: #{name}
researched: #{researched}
STRING

    if item
      "#{string}item: #{item}\n"
    else
      string
    end
  end

  def to_yml_struct
    yml = {
      'name'       => name,
      'researched' => researched
    }

    if item
      yml.merge('item' => item)
    else
      yml
    end
  end
end
