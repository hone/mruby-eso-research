class TestCommit < MTest::Unit::TestCase
  def test_commit_adds_new_researched_trait
    commit = ESOResearch::Commit.new(setup_crafts)
    trait_name = "infused"
      
    new_trait, crafts = commit.commit({
      "c" => 'c',
      "y" => 'light',
      "p" => 'chest',
      "t" => trait_name,
      "r" => 'true'
    })

    assert_equal "infused", new_trait.name

    crafts.each do |craft|
      craft.types.each do |type|
        type.pieces.each do |piece|
          added_trait = nil

          piece.traits.each do |trait|
            if trait.name == trait_name
              added_trait = trait 
              break
            end
          end

          assert_true(added_trait != nil, "#{trait_name} not found in new crafts")
        end
      end
    end
  end

  def test_commit_errors_for_required_opts
    commit = ESOResearch::Commit.new([])

    assert_raise(ESOResearch::MissingOptions) { commit.commit({}) }
  end

  def test_commit_required_opts_in_any_order
    commit = ESOResearch::Commit.new(setup_crafts)

    assert_nothing_raised(ESOResearch::MissingOptions) do
      commit.commit({
        "c" => 'c',
        "r" => 'true',
        "y" => 'light',
        "p" => 'chest',
        "t" => 'well-fitted'
      })
    end
  end

  def test_commit_craft_not_found
    commit = ESOResearch::Commit.new(setup_crafts)

    assert_raise(ESOResearch::NotFound) do
      commit.commit({
        "c" => 'b',
        "y" => 'light',
        "p" => 'chest',
        "t" => 'well-fitted',
        "r" => 'true'
      })
    end
  end

  def test_commit_type_not_found
    commit = ESOResearch::Commit.new(setup_crafts)

    assert_raise(ESOResearch::NotFound) do
      commit.commit({
        "c" => 'c',
        "y" => 'heavy',
        "p" => 'chest',
        "t" => 'well-fitted',
        "r" => 'true'
      })
    end
  end

  private
  def setup_crafts
    yaml = <<YAML
---
- clothing:
  - light:
    - ? name: robe & jerkin
        description: chest
      : - name: well-fitted
          researched: true
...
YAML

    YAML.load(yaml).map {|craft_h| ESOResearch::Craft.new(craft_h) }
  end
end

MTest::Unit.new.run
