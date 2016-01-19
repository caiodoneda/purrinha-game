class Computer < Player

	attr_accessor :bluff

	#blefe
	#Remover palpite do computador
	def play order
		@bluff = false;

		@current_play = rand(0..@sticks)

		if order.first.id.eql? @id
			@bluff = rand(0..10) <= 3;

			if @bluff
				@current_play = @sticks
			end
		end

		Interface.show_message "Computador jogou " + @current_play.to_s
		@current_play
	end

	def call history, order, turn, table_sticks
		if order.first.id.eql? @id
			return first_to_call table_sticks
		end

		regular_call history, order, turn, table_sticks
	end

	def first_to_call table_sticks

		guess = nil

		if @bluff
			Interface.show_message "Computador esta blefando!"
			guess = rand (0..@sticks -1)
		else
			guess = estimates_value table_sticks
		end

		Interface.show_message "Computador chamou: " + guess.to_s + " palitos"

		guess
	end

	def regular_call history, order, turn, table_sticks
		estimative = estimates_range table_sticks
		max_value = table_sticks - (@sticks - @current_play)
		min_value = @current_play

		last_guess = history[turn].first.last['call']
		
		history[turn].each do |playerid, p|
			if playerid.eql? @id
				break
			else
				last_guess = p['call']
			end
		end

		#elimina duplicação de palpites
		choosen_value = choose_value(estimative, table_sticks, history[turn], last_guess)

		Interface.show_message "Computador chamou: " + choosen_value.to_s + " palitos"
		choosen_value
	end

	def choose_value(estimative, table_sticks, history, last_guess)
		max_value = table_sticks - (@sticks - @current_play)
		min_value = @current_play

		#Cria um array com todos os valores possíveis.
		possible_values = []
		(min_value..max_value).each do |v|
			possible_values.push v
		end

		#Se o último palpite estiver fora do intervalo dos valores possíveis
		#retorna o valor mais provável dentre os possíveis que ainda não foi escolhido.
		if ((last_guess > max_value) || (last_guess < min_value))
			return choose_another_value possible_values, history 
		end

		possible_guesses = []

		estimative.each do |e|
			possible_guesses.push e if !was_called? history, e
		end

		if !possible_guesses.empty?
			if last_guess > possible_guesses.max
				last_guess -= 1
				return (last_guess) if !was_called? history, last_guess

				return possible_guesses.max
			else
				last_guess += 1
				return last_guess if !was_called? history, last_guess

				return possible_guesses.min
			end
		end

		return possible_guesses.sample if !possible_guesses.empty?

		possible_values = possible_values - estimative
		choose_another_value(possible_values, history)
	end

	def choose_another_value(possible_values, history)
		value = possible_values.size
		value = value / 2

		possible_values.delete possible_values[value]
		choose_another_value(possible_values) if was_called? history, possible_values[value]

		possible_values[value]
	end

	def estimates_value table_sticks
		max_value = table_sticks - (@sticks - @current_play)
		min_value = @current_play

		value = (max_value + min_value) / 2

		if ((max_value + min_value).odd?)
			if rand(0..1).even?
				value += 1
			end
		end

		value
	end

	def estimates_range table_sticks
		max_value = table_sticks - (@sticks - @current_play)
		min_value = @current_play

		value = []
		average = ((max_value + min_value) / 2)
		value.push average

		if ((max_value + min_value).odd?)
			value.push (average + 1)
		end

		value
	end

	def was_called? current_turn, value
		current_turn.each do |playerid, play|
			return true if play['call'].eql? value
		end

		return false
	end
end
