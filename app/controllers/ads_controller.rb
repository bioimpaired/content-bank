class AdsController < ApplicationController
  before_action :set_ad, only: [:show, :edit, :update, :destroy]

  # GET /ads
  def index
    @preview_ads = Ad.where("sort <= ?", 6).order(:sort)
    
    if (filter_params[:brand_id].present? || filter_params[:country_id].present?)
      filter_params_blanks_removed = filter_params.to_h
      filter_params_blanks_removed.delete_if { |k, v| v.empty? }
      @ads = Ad.where(filter_params_blanks_removed)
    else
      @ads = Ad.where("sort > ?", 6).order(:sort)
    end
  end

  def sort
    previewed_ad = Ad.find_by(sort: sort_params[:sort])
    current_ad = Ad.find(sort_params[:id])

    respond_to do |format|
      if previewed_ad.nil?
        previewed_ad_sort_number = sort_params[:sort]
        if current_ad.update(sort: previewed_ad_sort_number)
          format.html { redirect_to ads_path, notice: 'sort successfully updated' }
        else
          format.html { redirect_to ads_path, notice: 'sort failed to updated' }
        end
      else
        previewed_ad_sort_number = previewed_ad.sort
        current_ad_sort_number = current_ad.sort 

        if previewed_ad.update(sort: current_ad_sort_number) && current_ad.update(sort: previewed_ad_sort_number)
          format.html { redirect_to ads_path, notice: 'sort successfully updated' }
        else
          format.html { redirect_to ads_path, notice: 'sort failed to updated' }
        end
      end
    end
  end

  # GET /ads/1
  def show
  end

  # GET /ads/new
  def new
    @ad = Ad.new
  end

  # GET /ads/1/edit
  def edit
  end

  # POST /ads
  def create
    @ad = Ad.new(ad_params)
    respond_to do |format|
      if @ad.save
        format.html { redirect_to @ad, notice: 'Ad was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /ads/1
  def update
    respond_to do |format|
      if @ad.update(ad_params)
        format.html { redirect_to @ad, notice: 'Ad was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /ads/1
  def destroy
    @ad.destroy
    respond_to do |format|
      format.html { redirect_to ads_url, notice: 'Ad was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ad
      @ad = Ad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ad_params
      params.require(:ad).permit(:title, :brand_id, :country_id, :image)
    end

    def filter_params
      params.fetch(:filter_params, {}).permit(:brand_id, :country_id)
    end

    def sort_params
      params.permit(:sort, :id)
    end
end
