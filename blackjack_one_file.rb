# BlackJack

require 'byebug'
puts
puts '*' * 80
puts 'Добро пожаловать в игру BlackJack'
puts
class Interface
  def run
    begin
      print 'Пожалуйста введите ваше имя: '
      @player_name = gets.strip.capitalize
      raise 'Имя не может быть пустым!' if @player_name == ''
    rescue StandardError => e
      puts "Error: #{e.message}"
      retry
    end

    @userbalance = 100
    @dealerbalance = 100
    @bet = 10
    puts 'Баланс на начало игры: '
    puts "Игрок #{@player_name}: #{@userbalance} / Dealer: #{@dealerbalance}"
    puts

    loop do
      def goodbye
        puts "#{@player_name}, ваш баланс: $#{@userbalance}"
        puts 'Досвидание, будем ждать вас еще!'
        exit
      end

      goodbye if @userbalance.zero? || @dealerbalance.zero?

      @cards = {
      "2\u2665": 2, "3\u2665": 3, "4\u2665": 4, "5\u2665": 5, "6\u2665": 6, "7\u2665": 7, "8\u2665": 8, "9\u2665": 9, "10\u2665": 10, "V\u2665": 10, "D\u2665": 10, "K\u2665": 10, "T\u2665": 11,
      "2\u2663": 2, "3\u2663": 3, "4\u2663": 4, "5\u2663": 5, "6\u2663": 6, "7\u2663": 7, "8\u2663": 8, "9\u2663": 9, "10\u2663": 10, "V\u2663": 10, "D\u2663": 10, "K\u2663": 10, "T\u2663": 11,
      "2\u2666": 2, "3\u2666": 3, "4\u2666": 4, "5\u2666": 5, "6\u2666": 6, "7\u2666": 7, "8\u2666": 8, "9\u2666": 9, "10\u2666": 10, "V\u2666": 10, "D\u2666": 10, "K\u2666": 10, "T\u2666": 11,
      "2\u2660": 2, "3\u2660": 3, "4\u2660": 4, "5\u2660": 5, "6\u2660": 6, "7\u2660": 7, "8\u2660": 8, "9\u2660": 9, "10\u2660": 10, "V\u2660": 10, "D\u2660": 10, "K\u2660": 10, "T\u2660": 11
      }
      @cards = @cards.to_a

      @bank = 0
      @dealer_score = 0
      @player_score = 0

      print 'Сыграем? Нажимите Enter, чтобы продложить...'
      userchoice = gets.strip

      goodbye if userchoice != ''

      puts '*' * 80
      puts "Ставка игры $10"
      @userbalance -= @bet
      @dealerbalance -= @bet
      @bank = 20
      @player_cards = []
      @dealer_cards = []

      def cards_on_hand(user)
        user << @cards.delete_at(rand(0..(@cards.size - 1)))
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
        player.to_h.each_key.with_index(1) {|card, index| puts "#{index}. #{card}"}
      end

      def player_turn
        cards_on_hand(@player_cards) # Third card
        if @player_score <= 10 && @player_cards[-1][1] == 11
          @player_score += 11
        elsif @player_score >= 11 && @player_cards[-1][1] == 11
          @player_score += 1
        else
          @player_score += @player_cards[-1][1]
        end
      end

      def dealer_turn
        puts
        puts 'Dealer думает...'
        puts
        sleep 1

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

      def check_score
        if ((@player_score > 21) && (@dealer_score > 21)) || (@player_score == @dealer_score)
          puts '*' * 80
          puts "Карты игрока: "
          show_cards(@player_cards)
          puts
          puts "Карты Dealer: "
          show_cards(@dealer_cards)
          puts
          puts "Очки игроков: "
          puts "#{@player_name}: #{@player_score} / Dealer: #{@dealer_score}"
          puts
          puts 'Ничья!'
          puts
          @userbalance += (@bank / 2)
          @dealerbalance += (@bank / 2)
        elsif ((@player_score > @dealer_score) && (@player_score <= 21)) || ((@player_score < @dealer_score) && (@dealer_score > 21))
          puts '*' * 80
          puts "Карты игрока: "
          show_cards(@player_cards)
          puts
          puts "Карты Dealer: "
          show_cards(@dealer_cards)
          puts
          puts '*' * 80
          puts "Очки игроков: "
          puts "#{@player_name}: #{@player_score} / Dealer: #{@dealer_score}"
          puts "Победил #{@player_name}!"
          puts
          @userbalance += @bank
        elsif ((@player_score < @dealer_score) && (@dealer_score <= 21)) || ((@player_score > @dealer_score) && (@player_score > 21))
          puts '*' * 80
          puts "Карты игрока: "
          show_cards(@player_cards)
          puts
          puts "Карты Dealer: "
          show_cards(@dealer_cards)
          puts
          puts "Очки игроков: "
          puts "#{@player_name}: #{@player_score} / Dealer: #{@dealer_score}"
          puts '*' * 80
          puts 'Победил Dealer!'
          puts
          @dealerbalance += @bank
        end
      end

      while @player_cards.size != 3 && @dealer_cards.size != 3
        begin
          puts "Ваши карты: "
          show_cards(@player_cards)
          puts
          puts "Ваши текущие очки: #{@player_score}"
          puts

          puts '1. Взять еще одну карту'
          puts '2. Пропустить ход'
          puts '3. Открыть карты'
          print 'Выберите действие: '
          user_choice = gets.to_i
          puts
          raise 'Такого пункта в списке нет. Пожалуйста попробуйте еще раз!' if user_choice != 1 && user_choice != 2 && user_choice != 3
          puts
        rescue StandardError => e
          puts "Error: #{e.message}"
          retry
        end

        case user_choice
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
      puts "Игрок #{@player_name}: #{@userbalance} / Dealer: #{@dealerbalance}"
      puts '*' * 80
      puts
    end
  end
end

Interface.new.run
