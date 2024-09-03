module Spree
  module Admin
    module StoresControllerDecorator
      def self.prepended(base)
        base.after_action :update_recently_viewed_products_max_count, only: [:update]
      end

      private

      def update_recently_viewed_products_max_count
        return unless @store.save

        Spree::RecentlyViewed::Config.set(recently_viewed_products_max_count: params[:recently_viewed_products_max_count])
      end
    end
  end
end
::Spree::Admin::StoresController.prepend Spree::Admin::StoresControllerDecorator
