class Type
  attr_reader :name, :pieces, :craft

  def initialize(hash, craft)
    @name   = hash.keys.first
    @pieces = build_pieces(hash.values.first)
    @craft  = craft
  end

  def to_yml_struct
    {@name => @pieces.map {|piece| piece.to_yml_struct } }
  end

  private
  def build_pieces(pieces)
    pieces.map do |piece_h|
      Piece.new(piece_h, self)
    end
  end
end
