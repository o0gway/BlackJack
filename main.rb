# coding: utf-8
# BlackJack
require 'byebug'
puts
puts '*' * 80
puts 'Добро пожаловать в игру BlackJack'
puts
class Interface
  def run
    print 'Пожалуйста введите ваше имя: '
    @username = gets.strip.capitalize

    @userbalance = 100
    @dealerbalance = 100
    @bet = 10

    loop do
      def goodbye
        puts "#{@username}, ваш баланс: $#{@userbalance}"
        puts 'Досвидание, будем ждать вас еще!'
        exit
      end

      goodbye if @userbalance == 0 || @dealerbalance == 0

      @cards = {
      "2\u2665": 2, "3\u2665": 3, "4\u2665": 4, "5\u2665": 5, "6\u2665": 6, "7\u2665": 7, "8\u2665": 8, "9\u2665": 9, "10\u2665": 10, "V\u2665": 10, "D\u2665": 10, "K\u2665": 10, "T\u2665": 11,
      "2\u2663": 2, "3\u2663": 3, "4\u2663": 4, "5\u2663": 5, "6\u2663": 6, "7\u2663": 7, "8\u2663": 8, "9\u2663": 9, "10\u2663": 10, "V\u2663": 10, "D\u2663": 10, "K\u2663": 10, "T\u2663": 11,
      "2\u2666": 2, "3\u2666": 3, "4\u2666": 4, "5\u2666": 5, "6\u2666": 6, "7\u2666": 7, "8\u2666": 8, "9\u2666": 9, "10\u2666": 10, "V\u2666": 10, "D\u2666": 10, "K\u2666": 10, "T\u2666": 11,
      "2\u2660": 2, "3\u2660": 3, "4\u2660": 4, "5\u2660": 5, "6\u2660": 6, "7\u2660": 7, "8\u2660": 8, "9\u2660": 9, "10\u2660": 10, "V\u2660": 10, "D\u2660": 10, "K\u2660": 10, "T\u2660": 11
      }
      @cards = @cards.to_a

      @bank = 0
      @dealer_score = 0
      @user_score = 0

      print 'Сыграем? Нажимите Enter, чтобы продложить...'
      userchoice = gets.strip

      goodbye if userchoice != ''

      puts '*' * 80
      puts "Баланс #{@username}: #{@userbalance} / Dealer: #{@dealerbalance}"
      puts "Ставка $10"
      @userbalance -= @bet
      @dealerbalance -= @bet
      @bank = 20
      @user_cards = []
      @dealer_cards = []

      def cards_on_hand(user)
        user << @cards.delete_at(rand(0..@cards.size))
        user[-1][1]
      end

      # byebug
      @user_score += cards_on_hand(@user_cards) # First card
      cards_on_hand(@user_cards) # Second card
      if @user_cards[-1][1] == @user_cards[0][1] && @user_cards[0][1] == 11
        @user_score += 1
      else
        @user_score += @user_cards[-1][1]
      end

      @dealer_score += cards_on_hand(@dealer_cards) # First card
      cards_on_hand(@dealer_cards) # Second card
      if @dealer_cards[-1][1] == @dealer_cards[0][1] && @dealer_cards[0][1] == 11
        @dealer_score += 1
      else
        @dealer_score += @dealer_cards[-1][1]
      end

      def show_cards(player)
        player.to_h.each_key.with_index(1) {|card, index| puts "#{index}. #{card}"}
      end
      puts "Ваши карты: "
      show_cards(@user_cards)
      puts
      puts "Ваши текущие очки: #{@user_score}"
      puts

      puts '1. Взять еще одну карту'
      puts '2. Пропустить ход'
      puts '3. Открыть карты'
      print 'Выберите действие: '
      user_choice = gets.to_i

      def check_score
        if (@user_score > 21 && @dealer_score > 21) || (@user_score == @dealer_score)
          puts '*' * 80
          puts "Карты игрока: "
          show_cards(@user_cards)
          puts
          puts "Карты Dealer: "
          show_cards(@dealer_cards)
          puts
          puts "#{@username}: #{@user_score} / Dealer: #{@dealer_score}"
          puts
          puts 'Ничья!'
          puts
          @userbalance += @bank/2
          @dealerbalance += @bank
        elsif @user_score > @dealer_score && @user_score <= 21
          puts '*' * 80
          puts "Карты игрока: "
          show_cards(@user_cards)
          puts
          puts "Карты Dealer: "
          show_cards(@dealer_cards)
          puts '*' * 80
          puts "#{@username}: #{@user_score} / Dealer: #{@dealer_score}"
          puts "Победил #{@username}!"
          puts
          @userbalance += @bank
        elsif @user_score < @dealer_score && @dealer_score <= 21
          puts '*' * 80
          puts "Карты игрока: "
          show_cards(@user_cards)
          puts
          puts "Карты Dealer: "
          show_cards(@dealer_cards)
          puts "#{@username}: #{@user_score} / Dealer: #{@dealer_score}"
          puts '*' * 80
          puts 'Победил Dealer!'
          puts
          @dealerbalance += @bank
        end
      end

      case user_choice
      when 1
        cards_on_hand(@user_cards) # Third card
        if @user_score <= 10 && @user_cards[-1][1] == 11
          @user_score += 11
        elsif @user_score >= 11 && @user_cards[-1][1] == 11
          @user_score += 1
        else
          @user_score += @user_cards[-1][1]
        end
      when 2
        puts
        puts 'Dealer думает...'
        sleep 3
        if @dealer_score > 17
          puts 'Dealer пропускает ход!'
          puts
        elsif @dealer_score < 17
          cards_on_hand(@dealer_cards)
          if @dealer_score <= 10 && @dealer_cards[-1][1] == 11
            @dealer_score += 11
          elsif @dealer_score >= 11 && @dealer_cards[-1][1] == 11
            @dealer_score += 1
          else
            @dealer_score += @dealer_cards[-1][1]
          end
        end
      when 3
        check_score
      end

      check_score if @user_cards.size == 3 && @dealer_cards.size == 3
    end
  end
end

Interface.new.run
