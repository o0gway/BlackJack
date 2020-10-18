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
  def run

    begin
      print 'Пожалуйста введите ваше имя: '
      name = gets.strip.capitalize
      raise 'Имя не может быть пустым!' if name == ''

      @player = Player.new(name)
    rescue StandardError => e
      puts "Error: #{e.message}"
      retry
    end

    @dealer = Dealer.new

    @bet = 10

    puts 'Баланс на начало игры: '
    puts "Игрок #{@player.name}: #{@player.balance} / Dealer: #{@dealer.balance}"
    puts

    loop do
      def goodbye
        puts "#{@player.name}, ваш баланс: $#{@player.balance}"
        puts 'Досвидание, будем ждать вас еще!'
        exit
      end

      goodbye if @player.balance == 0 || @dealer.balance == 0


      @deck = Deck.new

      @bank = 0
      @dealer.score = 0
      @player.score = 0

      print 'Сыграем? Нажимите Enter, чтобы продложить...'
      player_choice  = gets.strip

      goodbye if player_choice != ''

      puts '*' * 80
      puts 'Ставка игры $10'
      @player.balance -= @bet
      @dealer.balance -= @bet
      @bank = 20
      @player.cards = []
      @dealer.cards = []

      def cards_on_hand(user)
        user << @deck.cards.delete_at(rand(0..(@deck.cards.size - 1)))
        user[-1].value
      end

      @player.score += cards_on_hand(@player.cards) # First card
      cards_on_hand(@player.cards) # Second card
      if (@player.cards[-1].value == @player.cards[0].value) && (@player.cards[0].value == 11)
        @player.score += 1
      else
        @player.score += @player.cards[-1].value
      end

      @dealer.score += cards_on_hand(@dealer.cards) # First card
      cards_on_hand(@dealer.cards) # Second card
      if (@dealer.cards[-1].value == @dealer.cards[0].value) && (@dealer.cards[0].value == 11)
        @dealer.score += 1
      else
        @dealer.score += @dealer.cards[-1].value
      end

      def show_cards(player)
        player.each.with_index(1) { |card, index| puts "#{index}. #{card.rank}#{card.suit}" }
      end

      def player_turn
        cards_on_hand(@player.cards) # Third card
        if (@player.score <= 10) && (@player.cards[-1].value == 11)
          @player.score += 11
        elsif (@player.score >= 11) && (@player.cards[-1].value == 11)
          @player.score += 1
        else
          @player.score += @player.cards[-1].value
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

        if @dealer.score >= 17
          puts 'Dealer пропускает ход!'
          puts
        elsif @dealer.score < 17
          cards_on_hand(@dealer.cards)
          if (@dealer.score <= 10) && (@dealer.cards[-1].value == 11)
            @dealer.score += 11
          elsif (@dealer.score >= 11) && (@dealer.cards[-1].value == 11)
            @dealer.score += 1
          else
            @dealer.score += @dealer.cards[-1].value
          end
        end
      end

      def win_information
        puts '*' * 80
        puts 'Карты игрока: '
        show_cards(@player.cards)
        puts
        puts 'Карты Dealer: '
        show_cards(@dealer.cards)
        puts
        puts '*' * 80
        puts 'Очки игроков: '
        puts "#{@player.name}: #{@player.score} / Dealer: #{@dealer.score}"
        puts
      end

      def check_score
        if ((@player.score > 21) && (@dealer.score > 21)) || (@player.score == @dealer.score)
          win_information
          puts 'Ничья!'
          puts
          @player.balance += (@bank / 2)
          @dealer.balance += (@bank / 2)
        elsif ((@player.score > @dealer.score) && (@player.score <= 21)) || ((@player.score < @dealer.score) && (@dealer.score > 21))
          win_information
          puts "Победил #{@player.name}!"
          puts
          @player.balance += @bank
        elsif ((@player.score < @dealer.score) && (@dealer.score <= 21)) || ((@player.score > @dealer.score) && (@player.score > 21))
          win_information
          puts 'Победил Dealer!'
          puts
          @dealer.balance += @bank
        end
      end

      while @player.cards.size != 3 && @dealer.cards.size != 3
        begin
          puts 'Ваши карты: '
          show_cards(@player.cards)
          puts
          puts "Ваши текущие очки: #{@player.score}"
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
          if @dealer.cards.size != 3
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
      puts "Игрок #{@player.name}: #{@player.balance} / Dealer: #{@dealer.balance}"
      puts '*' * 80
      puts
    end
  end
end

Interface.new.run
