class PrintersController < ApplicationController
before_action :set_column

  def activate
    @printer.toggle :active
    @printer.save
    redirect_to @printer.report
  end

  private

  def set_column
    @printer = Printer.find(params[:id])
  end
end
