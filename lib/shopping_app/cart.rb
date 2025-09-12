require "terminal-table"

class Cart
  attr_reader :owner, :items

  def initialize(owner)
    @owner = owner
    @items = {} # { id => { item: item, quantity: n } }
  end

  def add(item, quantity = 1)
    if @items[item.id]
      @items[item.id][:quantity] += quantity
    else
      @items[item.id] = { item: item, quantity: quantity }
    end
  end

  def total_amount
    @items.values.sum { |entry| entry[:item].price * entry[:quantity] }
  end

  def items_list
    if @items.empty?
      puts "Cart is empty."
    else
      rows = @items.values.map do |entry|
        i = entry[:item]
        [i.id, i.name, i.price, entry[:quantity]]
      end
      table = Terminal::Table.new(
        headings: ["ID", "Name", "Price", "Quantity"],
        rows: rows
      )
      puts table
    end
  end

  def check_out
    total = total_amount
    if owner.wallet.balance >= total
      owner.wallet.withdraw(total)
      @items.each_value do |entry|
        entry[:item].owner.wallet.deposit(entry[:item].price * entry[:quantity])
        # Fix: Create a new copy for each unit to avoid sharing objects
        entry[:quantity].times do
          new_item = Item.new(
            entry[:item].id,
            entry[:item].name,
            entry[:item].price,
            1,  # Each owned item has qty=1
            owner  # Now owned by customer
          )
          owner.add_item(new_item)
        end
      end
      @items.clear
      puts "🎉 Checkout successful!"
    else
      puts "⚠️ Not enough balance to complete checkout."
    end
  end
end