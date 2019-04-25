class RemarksController < ApplicationController
  def index
    remarks = RemarkFilter.new(params.permit(:lng, :lat, :radius, :q, :current_lat, :current_lng)).run
    render json: { data: remarks.map { |remark| RemarkSerializer.new(remark) } }.to_json
  end

  def create
    remark = Remark.new(params.require(:remark).permit(:user_name, :body))
    remark.point = "POINT(#{params.require(:remark).require(:lng)} #{params.require(:remark).require(:lat)})"

    if remark.save
      render json: { data: RemarkSerializer.new(remark) }.to_json, status: :created
    else
      render json: { errors: remark.errors.full_messages }.to_json, status: :unprocessable_entity
    end
  end
end
