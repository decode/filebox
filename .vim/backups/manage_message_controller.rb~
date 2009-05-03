class ManageMessageController < ApplicationController
  layout 'admin'
  before_filter :update_table_config

  active_scaffold :messages do | config |
    config.label = ''
    #config.actions.exclude :create, :search
    config.columns = [:title, :body, :created_at, :updated_at]
    #config.columns[:messages].includes = [:messageboxes]
    #config.columns[:last_transaction_date].sort_by :sql => "user_transactions.created_at"
  end
  
  def conditions_for_collection
    #['login != ?', 'admin'] unless current_user.has_role? 'admin'
    return '' if session[:manage_type].nil?
    ['message_type = ?', session[:manage_type]]
  end

  def update_table_config         
    if session[:manage_type] != 'news'
      active_scaffold_config.exclude :create, :search
    else
      active_scaffold_config.label = "Site news manage"
    end
  end

  def before_create_save(record)
    record.message_type = session[:message_type]
    record.user = current_user
  end

end
