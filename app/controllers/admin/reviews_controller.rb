class Admin::ReviewsController < Admin::BaseController
  resource_controller

  def index
    @unapproved_reviews = Review.not_approved.where("product_id in (?)",find_product).order("created_at DESC")
    @approved_reviews   = Review.approved.where("product_id in (?)",find_product).order("created_at DESC")
  end

  create.response do |wants|
    wants.html { redirect_to admin_reviews_path }
  end

  update.response do |wants|
    wants.html { redirect_to admin_reviews_path }
  end

  def approve
    r = Review.find(params[:id])

    if r.update_attribute(:approved, true)
       r.product.recalculate_rating
       flash[:notice] = t("info_approve_review")
    else
       flash[:error] = t("error_approve_review")
    end
    redirect_to admin_reviews_path
  end
def find_product
  product=Product.find(:all,:conditions=>["domain_url=?",current_user.domain_url]).map(&:id)
  return product
end
end
