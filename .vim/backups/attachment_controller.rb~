class AttachmentController < ApplicationController
  layout 'site'

  active_scaffold

  def index
    @attachments = Attachment.find :all    
  end
  
  def new
   @attachment = Attachment.new
   @user = User.find params[:user_id]
   @gallary = Gallary.find params[:gallary_id]
    respond_to do |format|
      format.html
      format.xml { render :xml => @attachment}
    end
  end

  def create
    @user = User.find params[:user_id]
    @gallary = Gallary.find params[:gallary_id]
    @attachment = @gallary.attachments.build(params[:attachment])
    if @attachment.save
      flash[:success] = 'Image has been saved!'
      redirect_to user_gallary_path(@user, @gallary)
    else
      flash[:error] = 'Image not saved'
      redirect_to user_gallary_path(@user, @gallary)
    end
  end

  def delete
    @attachment = Attachment.find params[:id]
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_back_or_default session[:return_to] }
      format.xml  { head :ok }
    end
  end

  def show
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      format.html
      format.xml { render :xml => @attachment }
    end
  end
  
end
