require "terminal-table"
require_relative "ownable"

class Seller
  include Ownable
  attr_reader :name, :wallet, :items

  def initialize(name)
    @name = name
    @wallet = Wallet.new(self)
    # Pre-populate with sample stock items (adjust as needed)
    @items = [
      Item.new(1, "Apple", 100, 10),      # ID 1, price 100, stock 10
      Item.new(2, "Banana", 50, 20),      # ID 2, price 50, stock 20
      Item.new(3, "Orange", 80, 5)        # ID 3, price 80, stock 5 (enough for qty 2)
    ]
  end

  def add_item(item)
    @items << item
  end

  def items_list
    if @items.empty?
      puts "No items available."
    else
      rows = @items.map(&:label) # Item#label returns [id, name, price, quantity]
      table = Terminal::Table.new(
        headings: ["ID", "Name", "Price", "Quantity"],
        rows: rows
      )
      puts table
    end
  end

  def pick_items(id, quantity)
    found = @items.find { |i| i.id == id }
    return nil unless found && found.quantity >= quantity

    found.quantity -= quantity
    Array.new(quantity) { Item.new(found.id, found.name, found.price, 1, self) }
  end
end