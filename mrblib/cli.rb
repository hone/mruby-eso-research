module ESOResearch
  class CLI
    DATA_FILE  = "research.yml"
    SHORT_OPTS = "c:y:p:t:r:i:"
    LONG_OPTS  = "commit"

    def initialize(argv)
      class << argv; include Getopts; end

      @opts   = argv.getopts(SHORT_OPTS, LONG_OPTS)
      @crafts = build_crafts
    end

    def run
      if @opts["commit"]
        commit
      else
        search
      end
    end

    private
    def load_yml
      YAML.load(File.read(DATA_FILE)) if File.exist?(DATA_FILE)
    end

    def build_crafts
      data = load_yml
      return [] unless data

      data.map {|craft_h| Craft.new(craft_h) }
    end

    def commit
      craft = @crafts.dup.keep_if {|craft| craft.name.include?(@opts["c"]) }.first

      type = craft.types.dup.keep_if {|type| type.name.include?(@opts["y"]) }.first

      piece = type.pieces.dup.keep_if {|piece| piece.name.include?(@opts["p"]) || piece.description.include?(@opts["p"]) }.first

      if @opts["r"] == "true"
        piece.traits.each do |trait|
          if trait.name.include?(@opts["t"])
            trait.researched = true
            trait.item = nil
            break
          end
        end
      else
        piece.create_trait(@opts["t"], @opts["r"], @opts["i"])
      end

      File.open(DATA_FILE, 'w') do |file|
        file.print(YAML.dump(@crafts.map {|craft| craft.to_yml_struct }))
      end
    end

    def search
      matched_traits = []

      @crafts.each do |craft|
        next if (arg = @opts["c"]) && !craft.name.include?(arg)

        craft.types.each do |type|
          next if (arg = @opts["y"]) && !type.name.include?(arg)

          type.pieces.each do |piece|
            next if (arg = @opts["p"]) && !(piece.name.include?(arg) || piece.description.include?(arg))

            piece.traits.each do |trait|
              next if (arg = @opts["t"]) && !trait.name.include?(arg)
              next if (arg = @opts["r"]) && trait.researched.to_s != arg
              next if (arg = @opts["i"]) && (!trait.item || !trait.item.include?(arg))

              matched_traits << trait
            end
          end
        end
      end

      puts matched_traits.map {|trait| trait.to_s }.join("\n")
    end
  end
end
