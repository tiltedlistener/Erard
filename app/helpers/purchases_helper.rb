module PurchasesHelper
	include SessionsHelper

	def verify_user_purchase(id)
		u = get_user()
		p = u.purchases.find_by_id(id)

		if p.nil?
			return false
		else
			return true
		end

	end

end
