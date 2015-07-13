module ESOResearch
  class Craft
    attr_reader :name, :types

    def initialize(hash)
      @name  = hash.keys.first
      @types = build_types(hash.values.first)
    end

    def to_yml_struct
      {@name => @types.map {|type| type.to_yml_struct } }
    end

    private
    def build_types(types)
      types.map do |type_h|
        Type.new(type_h, self)
      end
    end
  end
end
