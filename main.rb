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
      @cards = {
      ch_2: 2, ch_3: 3, ch_4: 4, ch_5: 5, ch_6: 6, ch_7: 7, ch_8: 8, ch_9: 9, ch_10: 10, ch_v: 10, ch_d: 10, ch_k: 10, ch_t: 11,
      k_2: 2, k_3: 3, k_4: 4, k_5: 5, k_6: 6, k_7: 7, k_8: 8, k_9: 9, k_10: 10, k_v: 10, k_d: 10, k_k: 10, k_t: 11,
      b_2: 2, b_3: 3, b_4: 4, b_5: 5, b_6: 6, b_7: 7, b_8: 8, b_9: 9, b_10: 10, b_v: 10, b_d: 10, b_k: 10, b_t: 11,
      p_2: 2, p_3: 3, p_4: 4, p_5: 5, p_6: 6, p_7: 7, p_8: 8, p_9: 9, p_10: 10, p_v: 10, p_d: 10, p_k: 10, p_t: 11
      }
      @cards = @cards.to_a
      dealer_score = 0
      user_score = 0
      print 'Сыграем? Нажимите Enter, чтобы продложить...'
      userchoice = gets.strip

      if userchoice != ''
        puts "#{@username}, ваш баланс: $#{@userbalance}"
        puts 'Досвидание, будем ждать вас еще!'
        exit
      end

      puts '*' * 80
      puts "Ставка $10"
      @userbalance -= @bet
      @dealerbalance -= @bet
      user_cards = []
      dealer_cards = []


      def cards_on_hand(user)
        user << @cards.delete_at(rand(0..@cards.size))
        user[-1][-1]
      end

      # byebug
      user_score += cards_on_hand(user_cards) # First card
      user_score += cards_on_hand(user_cards) # Second card
      dealer_score += cards_on_hand(dealer_cards) # First card
      dealer_score += cards_on_hand(dealer_cards) # Second card




      puts "Ваши карты: "
      user_cards.to_h.each_key.with_index(1) {|card, index| puts "#{index}. #{card}"}
      puts
      puts "Ваши текущие очки: #{user_score}"

      puts 'Выберите действие:'
      puts '1. Взять еще одну карту'
      puts '2. Пропустить ход'
      user_choice = gets.to_i

      case user_choice
      when 1

      when 2

      end
    end
  end
end

Interface.new.run
