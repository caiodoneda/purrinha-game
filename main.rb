require_relative 'table'
require_relative 'player'
require_relative 'interface'

players = {}

Interface.show_message "\nBem vindo ao Porrinha! - Caio Doneda - Mariana Mattos - Osvaldo da Rocha\n\n"
n = (Interface.get_data("Digite o numero de jogadores humanos")).to_i

while (n < 1 || n > 5)
	n = (Interface.get_data "Minimo de 1, maximo de 5 jogadores humanos. Tente novamente!").to_i	
end

(1..n).each do |i|
	name = Interface.get_data "Digite o nome do jogador " + i.to_s
	players[i] = Player.new(i, name.chomp)
end

players[n+1] = Computer.new(n+1, "Computador")

Interface.show_message "\nJogadores:\n"
players.each do |player|
	Interface.show_message player.last.id.to_s + " - " + player.last.name
end

Interface.show_message "\nIniciando a partida..."

table = Table.new players
table.start_game