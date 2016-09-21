require_relative '../lib/bowling_game'

describe BowlingGame do
  let(:game) { BowlingGame.new() }

  it "correct counts the game with 0 hit" do
    bob_game = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    expect(game.rolls(bob_game).score).to eq(0)
  end

  it "correct counts the game without strikes and spares" do
    bob_game = [1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2]
    expect(game.rolls(bob_game).score).to eq(30)
  end

  it "correct counts the game withouth strikes, bit with spares" do
    bob_game = [1, 9, 5, 2, 1, 2, 1, 2, 1, 2, 1, 9, 2, 2, 1, 2, 1, 2, 1, 2]
    expect(game.rolls(bob_game).score).to eq(56)
  end

  it "correct counts the game withouth spares bit with strikes" do
    bob_game = [10, 5, 2, 1, 2, 1, 2, 1, 2, 10, 0, 2, 1, 2, 1, 2, 1, 2]
    expect(game.rolls(bob_game).score).to eq(56)
  end

  it "correct counts the game with strikes and spares" do
    bob_game = [1, 4, 4, 5, 6, 4, 5, 5, 10, 0, 1, 7, 3, 6, 4, 10, 2, 8, 6]
    expect(game.rolls(bob_game).score).to eq(133)
  end

  it "correct counts the game with all strikes" do
    bob_game = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
    expect(game.rolls(bob_game).score).to eq(300)
  end
end