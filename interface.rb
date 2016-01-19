class Interface
	
	def self.get_data (msg)
		self.show_message msg
		
		gets
	end

	def self.show_message (msg)
		puts msg
	end

	def self.turn_status (turn, players, total_sticks)
		show_message "\n\n----------------------------"
		show_message "Palpites: \n"

		turn.each do |playerid, play|
			show_message players[playerid].name + " chamou: " + play['call'].to_s + " palitos \n"
		end

		show_message "Total de palitos: " + total_sticks.to_s + "\n"
		show_message "----------------------------"
	end
end