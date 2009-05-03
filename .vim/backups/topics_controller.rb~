class TopicsController < ApplicationController
  include AccessFilter

  layout 'site'

  active_scaffold :topics do | config |
    config.columns = [:name, :description, :parent_topic]
    #config.columns[:messages].includes = [:messageboxes]
    #config.columns[:last_transaction_date].sort_by :sql => "user_transactions.created_at"
  end

  # GET /topics
  # GET /topics.xml
  def index
    session[:return_to] = topics_path
    session[:view_style] = 'topic'
    @topics = Topic.find(:all, :conditions => 'parent_id is null')
    @topic_news = Message.find :all, :conditions => "message_type = 'topic'", :order => 'created_at DESC', :limit => 6
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    session[:target_message_id] = params[:id]
    @topic = Topic.find_by_id params[:id]
    @messages = @topic.posts.paginate :page => params[:page]||1, :order => 'updated_at DESC'
    @message = Message.new
    session[:view_style] = 'topic'
    session[:message_type] = 'topic'
    session[:return_to] = topic_url(@topic)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = Topic.new(params[:topic])

    respond_to do |format|
      if @topic.save
        flash[:success] = 'Topic was successfully created.'
        format.html { redirect_to(@topic) }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        flash[:success] = 'Topic was successfully updated.'
        format.html { redirect_to(@topic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    flash[:success] = "Topic has been delete"
    respond_to do |format|
      format.html { redirect_to(topics_url) }
      format.xml  { head :ok }
    end
  end

  def post
    session[:topic_id] = params[:id]
    session[:return_to] = "/topics/#{params[:id]}"
    session[:messages_type] = "topic"
    session[:target_message_id] = nil
    redirect_to :controller => "messages", :action => "new"
  end
end
