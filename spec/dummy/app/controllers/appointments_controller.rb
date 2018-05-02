class AppointmentsController < ApplicationController
  def index
    @appointments = Physician.where("name LIKE ?", "%#{params[:term]}%").where.not(id: params[:added_obj]).order(:name)
    render json: @appointments.map { |u| { value: u.id, label: u.name, content: u.name }}
  end
end
