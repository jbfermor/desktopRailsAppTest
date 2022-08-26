class ColumnsController < ApplicationController
  before_action :set_column

  def activate
    @column.toggle :active
    @column.save
    redirect_to @column.report
  end

  private

  def set_column
    @column = Column.find(params[:id])
  end

end
