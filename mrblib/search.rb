module ESOResearch
  class Search
    def initialize(crafts)
      @crafts = crafts
    end

    def search(opts)
      matched_traits = []

      @crafts.each do |craft|
        next if (arg = opts["c"]) && !craft.name.include?(arg)

        craft.types.each do |type|
          next if (arg = opts["y"]) && !type.name.include?(arg)

          type.pieces.each do |piece|
            next if (arg = opts["p"]) && !(piece.name.include?(arg) || piece.description.include?(arg))

            piece.traits.each do |trait|
              next if (arg = opts["t"]) && !trait.name.include?(arg)
              next if (arg = opts["r"]) && trait.researched.to_s != arg
              next if (arg = opts["i"]) && (!trait.item || !trait.item.include?(arg))

              matched_traits << trait
            end
          end
        end
      end

      matched_traits
    end
  end
end
