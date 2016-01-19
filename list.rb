class List
    attr_accessor :items

    def initialize (items)
    	@items = items.values
    end

    def rotate
   		@items.push(@items.shift)
    end

    def fix_order (player)
      while player.id != @items.first.id
        rotate
      end
    end

    def first
        @items.first
    end
end
