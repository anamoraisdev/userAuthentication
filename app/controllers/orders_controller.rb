class OrdersController < ApplicationController
    def create
      user = User.find(params[:order][:user_id])
      order_params = params.require(:order).permit(
        :payment_method, :coupon_code,
        :address_line1, :address_line2, :city, :state, :zip_code, :country,
        order_items: [:product_id, :quantity]
      )

  
      ActiveRecord::Base.transaction do
        order = user.orders.build(
            payment_method: order_params[:payment_method],
            status: :pending,
            address_line1: order_params[:address_line1],
            address_line2: order_params[:address_line2],
            city: order_params[:city],
            state: order_params[:state],
            zip_code: order_params[:zip_code],
            country: order_params[:country]
        )

  
        total = 0
  
        order_params[:order_items].each do |item|
          product = Product.find(item[:product_id])
          quantity = item[:quantity].to_i
          price = product.price
  
          order.order_items.build(
            product: product,
            quantity: quantity,
            price: price
          )
  
          total += quantity * price
        end

        coupon = Coupon.find_by(code: order_params[:coupon_code], active: true)

        if coupon
            if coupon.expires_at.present? && coupon.expires_at < Time.current
                return render json: { error: 'Coupon expired' }, status: :unprocessable_entity
            end

            if coupon.usage_limit.present? && coupon.usage_count.to_i >= coupon.usage_limit
                return render json: { error: 'Coupon usage limit reached' }, status: :unprocessable_entity
            end

            if CouponUsage.exists?(user_id: user.id, coupon_id: coupon.id)
                return render json: { error: 'Coupon already used by this user' }, status: :unprocessable_entity
            end

            # Apply discount
            discount_amount = case coupon.discount_type
                                when 'percent'
                                total * (coupon.discount_value.to_f / 100)
                                when 'fixed'
                                coupon.discount_value.to_f
                                else
                                0
                                end

            order.coupon = coupon
            order.total = [total - discount_amount, 0].max
            order.discount_amount = discount_amount # 👈 add this field via migration
        end

        order.save!

        if coupon
            coupon.increment!(:usage_count)
            CouponUsage.create!(user_id: user.id, coupon_id: coupon.id)
        end
          
        render json: order.as_json(include: { order_items: { include: :product } }).merge({discount_applied: order.discount_amount,}), status: :created
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
    end
  end
  