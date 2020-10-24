# BlackJack

require 'byebug'
require_relative 'player'
require_relative 'dealer'
require_relative 'deck'
require_relative 'card'

puts
puts '*' * 80
puts 'Добро пожаловать в игру BlackJack'
puts
class Interface
  attr_accessor :game
  def initialize(game)
    @game = game
  end

  def start_game
    puts 'Баланс на начало игры: '
    puts "Игрок #{game.player.name}: #{game.player.balance} / Dealer: #{game.dealer.balance}"
    puts

    @bet = 10
    @bank = 20

    loop do
      def goodbye
        puts "#{game.player.name}, ваш баланс: $#{game.player.balance}"
        puts 'Досвидание, будем ждать вас еще!'
        exit
      end

      goodbye if game.player.balance.zero? || game.dealer.balance.zero?


      @deck = Deck.new

      game.dealer.score = 0
      game.player.score = 0

      print 'Сыграем? Нажимите Enter, чтобы продложить...'
      player_choice  = gets.strip

      goodbye if player_choice != ''

      puts '*' * 80
      puts 'Ставка игры $10'
      game.player.balance -= @bet
      game.dealer.balance -= @bet

      game.player.cards = []
      game.dealer.cards = []

      def cards_on_hand(user)
        user << @deck.cards.delete_at(rand(0..(@deck.cards.size - 1)))
        user[-1].value
      end

      game.player.score += cards_on_hand(game.player.cards) # First card
      cards_on_hand(game.player.cards) # Second card
      if (game.player.cards[-1].value == game.player.cards[0].value) && (game.player.cards[0].value == 11)
        game.player.score += 1
      else
        game.player.score += game.player.cards[-1].value
      end

      game.dealer.score += cards_on_hand(game.dealer.cards) # First card
      cards_on_hand(game.dealer.cards) # Second card
      if (game.dealer.cards[-1].value == game.dealer.cards[0].value) && (game.dealer.cards[0].value == 11)
        game.dealer.score += 1
      else
        game.dealer.score += game.dealer.cards[-1].value
      end

      def show_cards(player)
        player.each.with_index(1) { |card, index| puts "#{index}. #{card.rank}#{card.suit}" }
      end

      def player_turn
        cards_on_hand(game.player.cards) # Third card
        if (game.player.score <= 10) && (game.player.cards[-1].value == 11)
          game.player.score += 11
        elsif (game.player.score >= 11) && (game.player.cards[-1].value == 11)
          game.player.score += 1
        else
          game.player.score += game.player.cards[-1].value
        end
      end

      def dealer_turn
        print 'Dealer думает'
        5.times do
          sleep 0.4
          print '.'
        end
        puts
        puts

        if game.dealer.score >= 17
          puts 'Dealer пропускает ход!'
          puts
        elsif game.dealer.score < 17
          cards_on_hand(game.dealer.cards)
          if (game.dealer.score <= 10) && (game.dealer.cards[-1].value == 11)
            game.dealer.score += 11
          elsif (game.dealer.score >= 11) && (game.dealer.cards[-1].value == 11)
            game.dealer.score += 1
          else
            game.dealer.score += game.dealer.cards[-1].value
          end
        end
      end

      def win_information
        puts '*' * 80
        puts 'Карты игрока: '
        show_cards(game.player.cards)
        puts
        puts 'Карты Dealer: '
        show_cards(game.dealer.cards)
        puts
        puts '*' * 80
        puts 'Очки игроков: '
        puts "#{game.player.name}: #{game.player.score} / Dealer: #{game.dealer.score}"
        puts
      end

      def check_score
        if ((game.player.score > 21) && (game.dealer.score > 21)) || (game.player.score == game.dealer.score)
          win_information
          puts 'Ничья!'
          puts
          game.player.balance += (@bank / 2)
          game.dealer.balance += (@bank / 2)
        elsif ((game.player.score > game.dealer.score) && (game.player.score <= 21)) || ((game.player.score < game.dealer.score) && (game.dealer.score > 21))
          win_information
          puts "Победил #{game.player.name}!"
          puts
          game.player.balance += @bank
        elsif ((game.player.score < game.dealer.score) && (game.dealer.score <= 21)) || ((game.player.score > game.dealer.score) && (game.player.score > 21))
          win_information
          puts 'Победил Dealer!'
          puts
          game.dealer.balance += @bank
        end
      end

      while game.player.cards.size != 3 && game.dealer.cards.size != 3
        begin
          puts 'Ваши карты: '
          show_cards(game.player.cards)
          puts
          puts "Ваши текущие очки: #{game.player.score}"
          puts
          puts '1. Взять еще одну карту'
          puts '2. Пропустить ход'
          puts '3. Открыть карты'
          print 'Выберите действие: '
          player_choice = gets.to_i
          puts
          if player_choice != 1 && player_choice != 2 && player_choice != 3
            raise 'Такого пункта в списке нет. Пожалуйста попробуйте еще раз!'
          end
          puts
        rescue StandardError => e
          puts "Error: #{e.message}"
          retry
        end

        case player_choice
        when 1
          player_turn
          if game.dealer.cards.size != 3
            dealer_turn
            check_score
            break
          else
            check_score
            break
          end
        when 2
          dealer_turn
          check_score
          break
        when 3
          check_score
          break
        end
      end

      puts 'Баланс на конец игры: '
      puts "Игрок #{game.player.name}: #{game.player.balance} / Dealer: #{game.dealer.balance}"
      puts '*' * 80
      puts
    end
  end
end

class BlackJack
  def initialize

    dealer = Dealer.new
    game = Game.new(create_player, dealer)
    terminal = Interface.new(game)
    terminal.start_game
  end

  def create_player
    print 'Пожалуйста введите ваше имя: '
    name = gets.strip.capitalize
    raise 'Имя не может быть пустым!' if name == ''

    player = Player.new(name)
  rescue StandardError => e
    puts "Error: #{e.message}"
    retry
  end


end

class Game
  attr_accessor :player, :dealer

  def initialize(player, dealer)
    @player = player
    @dealer = dealer
  end

end

BlackJack.new



