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
      new_trait, new_crafts = Commit.new(@crafts).commit(@opts)

      File.open(DATA_FILE, 'w') do |file|
        file.print(YAML.dump(new_crafts.map {|craft| craft.to_yml_struct }))
      end

      puts new_trait
    end

    def search
      traits = Search.new(@crafts).search(@opts)
      puts traits.map {|trait| trait.to_s }.join("\n")
    end
  end
end
