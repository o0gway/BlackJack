# BlackJack

require 'byebug'
require_relative 'player'
require_relative 'dealer'
require_relative 'desk'

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


      @desk = Desk.new

      @bank = 0
      @dealer_score = 0
      @player_score = 0

      print 'Сыграем? Нажимите Enter, чтобы продложить...'
      player_choice  = gets.strip

      goodbye if player_choice != ''

      puts '*' * 80
      puts 'Ставка игры $10'
      @player.balance -= @bet
      @dealer.balance -= @bet
      @bank = 20
      @player_cards = []
      @dealer_cards = []

      def cards_on_hand(user)
        user << @desk.cards.delete_at(rand(0..(@desk.cards.size - 1)))
        user[-1][1]
      end

      @player_score += cards_on_hand(@player_cards) # First card
      cards_on_hand(@player_cards) # Second card
      if (@player_cards[-1][1] == @player_cards[0][1]) && (@player_cards[0][1] == 11)
        @player_score += 1
      else
        @player_score += @player_cards[-1][1]
      end

      @dealer_score += cards_on_hand(@dealer_cards) # First card
      cards_on_hand(@dealer_cards) # Second card
      if (@dealer_cards[-1][1] == @dealer_cards[0][1]) && (@dealer_cards[0][1] == 11)
        @dealer_score += 1
      else
        @dealer_score += @dealer_cards[-1][1]
      end

      def show_cards(player)
        player.to_h.each_key.with_index(1) { |card, index| puts "#{index}. #{card}" }
      end

      def player_turn
        cards_on_hand(@player_cards) # Third card
        if (@player_score <= 10) && (@player_cards[-1][1] == 11)
          @player_score += 11
        elsif (@player_score >= 11) && (@player_cards[-1][1] == 11)
          @player_score += 1
        else
          @player_score += @player_cards[-1][1]
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

        if @dealer_score >= 17
          puts 'Dealer пропускает ход!'
          puts
        elsif @dealer_score < 17
          cards_on_hand(@dealer_cards)
          if (@dealer_score <= 10) && (@dealer_cards[-1][1] == 11)
            @dealer_score += 11
          elsif (@dealer_score >= 11) && (@dealer_cards[-1][1] == 11)
            @dealer_score += 1
          else
            @dealer_score += @dealer_cards[-1][1]
          end
        end
      end

      def win_information
        puts '*' * 80
        puts 'Карты игрока: '
        show_cards(@player_cards)
        puts
        puts 'Карты Dealer: '
        show_cards(@dealer_cards)
        puts
        puts '*' * 80
        puts 'Очки игроков: '
        puts "#{@player.name}: #{@player_score} / Dealer: #{@dealer_score}"
        puts
      end

      def check_score
        if ((@player_score > 21) && (@dealer_score > 21)) || (@player_score == @dealer_score)
          win_information
          puts 'Ничья!'
          puts
          @player.balance += (@bank / 2)
          @dealer.balance += (@bank / 2)
        elsif ((@player_score > @dealer_score) && (@player_score <= 21)) || ((@player_score < @dealer_score) && (@dealer_score > 21))
          win_information
          puts "Победил #{@player.name}!"
          puts
          @player.balance += @bank
        elsif ((@player_score < @dealer_score) && (@dealer_score <= 21)) || ((@player_score > @dealer_score) && (@player_score > 21))
          win_information
          puts 'Победил Dealer!'
          puts
          @dealer.balance += @bank
        end
      end

      while @player_cards.size != 3 && @dealer_cards.size != 3
        begin
          puts 'Ваши карты: '
          show_cards(@player_cards)
          puts
          puts "Ваши текущие очки: #{@player_score}"
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
          if @dealer_cards.size != 3
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
