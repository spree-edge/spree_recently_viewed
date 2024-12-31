module SpreeRecentlyViewed
  module Spree
    module ProductsControllerDecorator
      def self.prepended(base)
        base.include ::Spree::RecentlyViewedProductsHelper
        base.helper_method [:cached_recently_viewed_products, :cached_recently_viewed_products_ids]
        base.before_action :set_current_order, except: :recently_viewed
        base.after_action :save_recently_viewed, only: :recently_viewed
        base.before_action :clear_recently_viewed_cookie_on_user_change
      end

      def recently_viewed
        render 'spree/products/recently_viewed', layout: false
      end

      private

      def save_recently_viewed
        id = params[:product_id]
        return unless id.present?
        rvp = (cookies["#{current_store.code}_recently_viewed_products"] || '').split(', ')
        rvp.delete(id)
        rvp << id unless rvp.include?(id.to_s)
        cookies["#{current_store.code}_recently_viewed_products"] = rvp.join(', ')
      end

      def clear_recently_viewed_cookie_on_user_change
        if spree_current_user.nil?
          reset_cookies_for_nil_user
          return
        end

        return if cookies["#{current_store.code}_previous_user_id"] == spree_current_user.id.to_s

        cookies.delete("#{current_store.code}_recently_viewed_products")
        cookies["#{current_store.code}_previous_user_id"] = spree_current_user.id
      end

      def reset_cookies_for_nil_user
        unless cookies["#{current_store.code}_previous_user_id"] == "0"
          cookies.delete("#{current_store.code}_recently_viewed_products")
          cookies["#{current_store.code}_previous_user_id"] = "0"
        end
      end
    end
  end
end

Spree::ProductsController.prepend SpreeRecentlyViewed::Spree::ProductsControllerDecorator
