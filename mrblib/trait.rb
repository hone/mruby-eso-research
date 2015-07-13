module ESOResearch
  class Trait
    attr_reader :name, :piece
    attr_accessor :researched, :item

    def initialize(name, researched, item, piece)
      @name       = name
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
  end

  class ApparrelTrait < Trait
    TRAITS = %w(sturdy impenetrable reinforced well-fitted training infused exploration divines nirnhoned)

    def initialize(name, researched, item, piece)
      raise UnknownTrait, "For #{piece.name}, #{name} is not a known trait for #{self.class}." unless TRAITS.include?(name)
      super
    end
  end

  class WeaponTrait < Trait
    TRAITS = %w(powered charged precise infused defending training sharpened weighted nirnhoned)

    def initialize(name, researched, item, piece)
      raise UnknownTrait, "For #{piece.name}, #{name} is not a known trait for #{self.class}." unless TRAITS.include?(name)
      super
    end
  end
end
