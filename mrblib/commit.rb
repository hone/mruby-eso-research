module ESOResearch
  class Commit
    REQUIRED_OPTS = %w(c y p t r)

    def initialize(crafts)
      @crafts = crafts
    end

    def commit(opts)
      if (opts.keys & REQUIRED_OPTS).size != REQUIRED_OPTS.size
        raise MissingOptions, "These are the required opts for `--commit`: -#{REQUIRED_OPTS.join(" -")}"
      end

      craft = @crafts.dup.keep_if {|craft| craft.name.include?(opts["c"]) }.first
      raise NotFound, "Can't find craft #{opts["c"]}" unless craft

      type = craft.types.dup.keep_if {|type| type.name.include?(opts["y"]) }.first
      raise NotFound, "Can't find type #{opts["y"]}" unless type

      piece = type.pieces.dup.keep_if {|piece| piece.name.include?(opts["p"]) || piece.description.include?(opts["p"]) }.first
      raise NotFound, "Can't find piece #{opts["p"]}" unless piece

      new_trait = nil
      if opts["r"] == "true"
        piece.traits.each do |trait|
          if trait.name.include?(opts["t"])
            trait.researched = true
            trait.item       = nil
            new_trait        = trait
            break
          end
        end

        new_trait = piece.create_trait(opts["t"], opts["r"], nil) unless new_trait
      else
        new_trait = piece.create_trait(opts["t"], opts["r"], opts["i"])
      end

      [new_trait, @crafts]
    end
  end
end
