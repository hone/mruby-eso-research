class ESOResearch
  DATA_FILE = "research.yml"

  def initialize(argv)
    class << argv; include Getopts; end

    @opts   = argv.getopts(short_opts, long_opts)
    @crafts = build_crafts
  end

  def run
    if @opts["write"]
      craft = @crafts.dup.keep_if {|craft| craft.name.include?(@opts["c"]) }.first

      type = craft.types.dup.keep_if {|type| type.name.include?(@opts["y"]) }.first

      piece = type.pieces.dup.keep_if {|piece| piece.name.include?(@opts["p"]) || piece.description.include?(@opts["p"]) }.first

      piece.traits << Trait.new(@opts["t"], @opts["r"], @opts["i"], piece)

      File.open(DATA_FILE, 'w') do |file|
        file.print(YAML.dump(@crafts.map {|craft| craft.to_yml_struct }))
      end

      return
    end

    matched_traits = []
    @crafts.each do |craft|
      next if (arg = @opts["c"]) && !craft.name.include?(arg)

      craft.types.each do |type|
        next if (arg = @opts["y"]) && !type.name.include?(arg)

        type.pieces.each do |piece|
          next if (arg = @opts["p"]) && !(piece.name.include?(arg) || piece.description.include?(arg))

          piece.traits.each do |trait|
            next if (arg = @opts["t"]) && !trait.name.include?(arg)
            next if (arg = @opts["r"]) && trait.researched.to_s != researched
            next if (arg = @opts["i"]) && (!trait.item || !trait.item.include?(arg))

            matched_traits << trait
          end
        end
      end
    end

    puts matched_traits.map {|trait| trait.to_s }.join("\n")
  end

  private
  def short_opts
    "c:y:p:t:r:i:"
  end
  
  def long_opts
    "write"
  end

  def load_yml
    YAML.load(File.read(DATA_FILE)) if File.exist?(DATA_FILE)
  end

  def build_crafts
    data = load_yml
    return [] unless data

    data.map {|craft_h| Craft.new(craft_h) }
  end
end

def __main__(argv)
  ESOResearch.new(argv).run
end
