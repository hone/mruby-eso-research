class Piece
  attr_reader :name, :description, :traits, :type

  def initialize(hash, type)
    @name        = hash.keys.first["name"]
    @description = hash.keys.first["description"]
    @traits      = build_traits(hash.values.first)
    @type        = type
  end

  def to_yml_struct
    {
      {
        "name"        => @name,
        "description" => @description
      } => @traits.map {|t| t.to_yml_struct }
    }
  end

  private
  def build_traits(traits)
    if traits
      traits.map do |trait|
        Trait.new(
          trait["name"],
          trait["researched"],
          trait["item"],
          self
        )
      end
    else
      []
    end
  end
end
