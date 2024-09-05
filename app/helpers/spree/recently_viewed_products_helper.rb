module Spree
  module RecentlyViewedProductsHelper
    def cached_recently_viewed_products_ids
      product_ids = (cookies["#{current_store.code}_recently_viewed_products"] || '').split(',').map(&:strip)
      product_ids.delete(params[:product_id]) if product_ids.include?(params[:product_id])
      product_ids
    end

    def cached_recently_viewed_products
      max_count = Spree::RecentlyViewed::Config.preferred_recently_viewed_products_max_count.to_i
      recent_ids = cached_recently_viewed_products_ids.last(max_count)
      Spree::Product.find_by_array_of_ids(recent_ids)
    end
  end
end
