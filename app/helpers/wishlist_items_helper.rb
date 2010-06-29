module WishlistItemsHelper
  def class_transit(transit_item)
    case transit_item.orders_status
      when 2 then 'ok'
      when 1 then 'transit'
      else 'not_ok'
    end
  end
end