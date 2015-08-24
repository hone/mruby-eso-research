module ESOResearch
  class Trait
    attr_reader :name, :piece
    attr_accessor :researched, :item

    def initialize(name, researched, item, piece)
      @name       = find_name(name)
      @researched = researched
      @item       = item
      @piece      = piece
    end

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

    def position
      predefined_traits.index(name)
    end

    private
    def predefined_traits
      raise NotImplementedError
    end

    def find_name(name)
      predefined_traits.each do |trait_name|
        return trait_name if trait_name.include?(name)
      end

      raise UnknownTrait, "For #{piece.name}, #{name} is not a known trait for #{self.class}." unless predefined_traits.include?(name)
    end
  end

  class ApparelTrait < Trait
    TRAITS = %w(sturdy impenetrable reinforced well-fitted training infused exploration divines nirnhoned)

    def predefined_traits
      TRAITS
    end
  end

  class WeaponTrait < Trait
    TRAITS = %w(powered charged precise infused defending training sharpened weighted nirnhoned)

    def predefined_traits
      TRAITS
    end
  end
end
