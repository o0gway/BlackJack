# BlackJack

require 'byebug'
require_relative 'player'
require_relative 'dealer'
require_relative 'deck'
require_relative 'card'
require_relative 'game'

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
      player_choice = gets.strip

      goodbye if player_choice != ''

      puts '*' * 80
      puts 'Ставка игры $10'
      game.player.balance -= game.bet
      game.dealer.balance -= game.bet

      game.player.cards = []
      game.dealer.cards = []

      game.player.score += game.player.take_card(game.player.cards, @deck) # First card
      game.player.take_card(game.player.cards, @deck) # Second card
      game.check_for_ace(game.player)

      game.dealer.score += game.player.take_card(game.dealer.cards, @deck) # First card
      game.player.take_card(game.dealer.cards, @deck) # Second card
      game.check_for_ace(game.dealer)

      def player_turn
        game.player.take_card(game.player.cards, @deck) # Third card
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
          sleep 0.3
          print '.'
        end
        puts
        puts

        if game.dealer.score >= 17
          puts 'Dealer пропускает ход!'
          puts
        elsif game.dealer.score < 17
          game.player.take_card(game.dealer.cards, @deck)
          game.check_for_ace_third_card
        end
      end

      def win_information
        puts '*' * 80
        puts 'Карты игрока: '
        game.show_cards(game.player.cards)
        puts
        puts 'Карты Dealer: '
        game.show_cards(game.dealer.cards)
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
          game.draw(game.player)
          game.draw(game.dealer)
        elsif ((game.player.score > game.dealer.score) && (game.player.score <= 21)) || ((game.player.score < game.dealer.score) && (game.dealer.score > 21))
          win_information
          puts "Победил #{game.player.name}!"
          puts
          game.player.balance += game.bank
        elsif ((game.player.score < game.dealer.score) && (game.dealer.score <= 21)) || ((game.player.score > game.dealer.score) && (game.player.score > 21))
          win_information
          puts 'Победил Dealer!'
          puts
          game.dealer.balance += game.bank
        end
      end

      while game.player.cards.size != 3 && game.dealer.cards.size != 3
        begin
          puts 'Ваши карты: '
          game.show_cards(game.player.cards)
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

    Player.new(name)
  rescue StandardError => e
    puts "Error: #{e.message}"
    retry
  end
end

BlackJack.new
