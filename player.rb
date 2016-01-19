require_relative 'interface'

class Player
	attr_accessor :name, :sticks, :id

	def initialize id, name
		@name = name
		@sticks = 3
		@id = id
	end

	def play order
		Interface.show_message "Eh a vez de: " + name + "\nVoce tem " + sticks.to_s + " palitos"
		sticks = (Interface.get_data "Escolha uma quantidade de palitos para jogar").to_i

		while (sticks < 0 || sticks > @sticks)
			sticks = (Interface.get_data "Voce nao pode jogar essa quantidade de palitos... Escolha novamente").to_i
		end

		sticks
	end

	def call history, order, turn, table_sticks

		exists = true
		_call = nil

		while exists
			_call = (Interface.get_data @name + ", quantos palitos voce acha que tem na mesa?").to_i

			turn_players = history[turn]
			exists = false

			turn_players.each do |playerid, play|
				p = play['call']
				if _call.eql? p
					Interface.show_message "Essa quantidade de palitos ja foi escolhida, por favor escolha outra"
					exists = true
					break
				end
			end
		end

		_call
	end

	def won_turn
		@sticks -= 1
	end

end
