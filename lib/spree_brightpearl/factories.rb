FactoryGirl.define do
  #
  # Order
  #
  factory :order_ready_to_complete, parent: :order_with_line_items do
    state 'confirm'
    after(:create) do |order|
      create(:payment, amount: order.total, order: order)
    end
    
    factory :order_with_line_item do
      bill_address
      ship_address
      brightpearl_id 123

      ignore do
        line_items_count 1
      end

      after(:create) do |order, evaluator|
        create_list(:line_item, evaluator.line_items_count, order: order)
        order.line_items.reload

        create(:shipment, order: order)
        order.shipments.reload

        order.update!
      end
    end
  end
end
