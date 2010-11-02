module WishlistItemsHelper
  def class_transit(transit_item)
    case transit_item.orders_status
      when 2 then 'ok'
      when 1 then 'transit'
      else 'not_ok'
    end
  end
  def class_history(history_item)
    case history_item.orders_status
      when 3 then 'ok'
      else 'not_ok'
    end
  end
  def wishlist_message_count(wishlist_size)
    if@wishlist_size == 0 
      t('wishlist_items.popular.film0')
    else
      "#{t('wishlist_items.popular.contains')} #{pluralize(wishlist_size, t('wishlist_items.popular.film'))}"
    end
  end
end