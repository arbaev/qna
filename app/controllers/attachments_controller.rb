class AttachmentsController < ApplicationController
  before_action :set_attachment
  before_action :authenticate_user!
  before_action :authority!

  def destroy
    @question = @attachment.record
    @attachment.purge
    flash.now[:notice] = "#{@attachment.filename} successfully deleted"
  end

  private

  def set_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  def authority!
    unless current_user.author_of?(@attachment.record)
      flash.now[:alert] = 'you must be owner of file'
      render 'questions/show'
    end
  end
end
