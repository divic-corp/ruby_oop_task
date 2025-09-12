require "terminal-table"  # If not already there

class Item
  attr_accessor :number, :name, :price, :quantity, :owner  # Add :owner here

  def initialize(number, name, price, quantity = 1, owner = nil)
    @number = number
    @name = name
    @price = price
    @quantity = quantity
    self.owner = owner  # This now works
  end

  def id
    @number
  end
  def label
    [id, @name, @price, @quantity]  # For table rows in items_list
  end
end