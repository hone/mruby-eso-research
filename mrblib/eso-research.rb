class ESOResearch
  DATA_FILE = "research.yml"

  def initialize(argv)
    class << argv; include Getopts; end

    @opts   = argv.getopts(short_opts, long_opts)
    @data   = load_yml
    @traits = setup_data_structure
  end

  def run
    matched_traits = @traits.map do |trait|
      next if skip_trait(trait, "n", :name)
      next if skip_trait(trait, "i", :item)
      next if skip_trait(trait, "c", :craft)
      next if skip_trait(trait, "t", :type)

      next if (researched = @opts["r"]) && trait.researched.to_s != researched
      next if (piece = @opts["p"]) && !(trait.piece["name"].include?(piece) || trait.piece["description"].include?(piece))

      trait.to_s
    end.compact.join("---\n")

    puts matched_traits
  end

  private
  def short_opts
    "i:c:p:t:r:n:"
  end
  
  def long_opts
    "help"
  end

  def load_yml
    YAML.load(File.read(DATA_FILE)) if File.exist?(DATA_FILE)
  end

  def setup_data_structure
    results = []

    @data.each do |craft_h|
      craft_h.each do |craft, types|
        types.each do |type_h|
          type_h.each do |type, pieces|
            pieces.each do |piece_h|
              piece_h.each do |piece, traits|
                if traits
                  traits.each do |trait|
                    results << Trait.new(
                      trait["name"],
                      trait["researched"],
                      trait["item"],
                      craft,
                      type,
                      piece
                    )
                  end
                end
              end
            end
          end
        end
      end
    end

    results
  end

  def skip_trait(trait, opt, attribute)
    if arg = @opts[opt]
      unless trait.send(attribute) && trait.send(attribute).include?(arg)
        return true
      end
    end
    
    false
  end
end

def __main__(argv)
  ESOResearch.new(argv).run
end
