class Game
  attr_reader :bet, :bank
  attr_accessor :player, :dealer

  def initialize(player, dealer)
    @player = player
    @dealer = dealer
    @bet = 10
    @bank = 20
  end

  def show_cards(player)
    player.each.with_index(1) { |card, index| puts "#{index}. #{card.rank}#{card.suit}" }
  end

  def check_for_ace(user)
    if (user.cards[-1].value == user.cards[0].value) && (user.cards[0].value == 11)
      game.player.score += 1
    else
      user.score += user.cards[-1].value
    end
  end

  def check_for_ace_third_card
    if (dealer.score <= 10) && (dealer.cards[-1].value == 11)
      dealer.score += 11
    elsif (dealer.score >= 11) && (dealer.cards[-1].value == 11)
      dealer.score += 1
    else
      dealer.score += dealer.cards[-1].value
    end
  end

  def draw(user)
    user.balance += (bank / 2)
  end
end
