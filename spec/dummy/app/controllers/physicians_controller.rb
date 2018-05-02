class PhysiciansController < ApplicationController
  before_action :set_physician, only: [:show, :edit, :update, :destroy]

  # GET /physicians
  def index
    @physicians = Physician.all
  end

  # GET /physicians/1
  def show
  end

  # GET /physicians/new
  def new
    @physician = Physician.new
  end

  # GET /physicians/1/edit
  def edit
  end

  # POST /physicians
  def create
    @physician = Physician.new(physician_params)

    if @physician.save
      redirect_to @physician, notice: 'Physician was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /physicians/1
  def update
    if @physician.update(physician_params)
      redirect_to @physician, notice: 'Physician was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /physicians/1
  def destroy
    @physician.destroy
    redirect_to physicians_url, notice: 'Physician was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_physician
      @physician = Physician.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def physician_params
      params.require(:physician).permit(:name)
    end
end
