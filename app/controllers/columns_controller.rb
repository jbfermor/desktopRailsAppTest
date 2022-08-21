class ColumnsController < ApplicationController
  before_action :set_column

  def activate
    toggle = @column.toggle :active
    @column.update(active: toggle)
    redirect_to @column.report
  end

  private

  def set_column
    @column = Column.find(params[:id])
  end

end
