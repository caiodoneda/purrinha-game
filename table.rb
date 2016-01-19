require_relative 'player'
require_relative 'computer'
require_relative 'list'
require_relative 'interface'

class Table
    attr_accessor :players, :order, :history, :turn, :winner, :sticks, :turn_winner

    def initialize players
    	@players = players
    	@order = List.new players
        @history = {}
        @turn = 0
        @winner = false
        @sticks = players.size * 3
    end

    def start_game
        while !end_game?
            next_turn
        end

        Interface.show_message "Fim de jogo."
    end

    #Rodada em si
    def next_turn
        @turn_winner = nil
        @turn += 1
        @history[@turn] = {}
        total_sticks = 0

        #puts @order.items

        @order.items.each do |p|
            current_sticks = p.play @order
            total_sticks += current_sticks
            @history[@turn][p.id] = {}
            @history[@turn][p.id]['hand'] = current_sticks
        end

        @order.items.each do |p|
            @history[@turn][p.id]['call'] = p.call(history, order, turn, @sticks)
        end

        Interface.turn_status @history[@turn], @players, total_sticks

        if winner_exists? total_sticks
            @turn_winner.won_turn
            @order.fix_order @turn_winner
            @winner = true if @turn_winner.sticks.eql? 0
            Interface.show_message "Jogador " + @turn_winner.name + " ganhou a rodada, e agora tem " + @turn_winner.sticks.to_s + " palitos \n"
        else
            @order.rotate
            Interface.show_message "Ninguem ganhou esta rodada \n"
        end
    end

    def winner_exists? total_sticks
       @history[@turn].each do |id, play|
           @turn_winner = @players[id] if play['call'].eql? total_sticks
       end

       @turn_winner
    end

    def end_game?
        @winner
    end

end
