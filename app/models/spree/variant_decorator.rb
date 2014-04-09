module Spree
  Variant.class_eval do
    def sync_stock(quantity)
      quantity = quantity - total_on_hand

      Spree::StockMovement.create({
        stock_item: stock_items.first,
        quantity: quantity,
        action: "Sync Brightpearl inventory"
      })
    end
  end
end
