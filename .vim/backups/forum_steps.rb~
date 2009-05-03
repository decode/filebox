Before do
  @temp_user = Factory.create(:user, :login => 'temp', :email => 'e1@ma.il')
end
When /^I goto the forum first page$/ do
  visit topics_path
end

Given /^I am on a topic page named (.*)$/ do |name|
  @topic = Factory.create(:topic, :name => name)
  visit topic_path(@topic)
end

When /^I follow a topic titled (.*)$/ do |title|
  message = Factory.create(:message, :title => title)
  message.message_type = 'topic'
  message.user = @temp_user
  message.topic_id = @topic.id
  message.save
  visit message_path(message)
end

Given /^the existing post list:$/ do |posts|
  posts.hashes.each do |m|
    user = User.find_by_login(m["poster"])
    if user.nil?
      user = Factory.create :user, :login => m["poster"], :email => "#{m["poster"]}@test.net" unless m["poster"].nil?
    end
    post = Factory.create :message, :title => m["title"], :body => m["body"]
    post.user = user
    post.topic = Factory.create :topic, :name => m["topic"]
    post.message_type = 'topic'
    post.save
  end
  puts Message.find(:first).title
end

Given /^I am on a post thread named (.*)$/ do |name|
  post = Message.find_by_title(name)
  visit message_path(post)
end

And /^I reply a post titled (.*)$/ do |title|
  message = Factory.create(:message, :title => title)
  message.message_type = 'topic'
  message.user = @temp_user
  message.topic_id = @topic.id
  message.save
  reply_message = Factory.create(:message, :title => 'repost')
  reply_message.message_type = 'topic'
  reply_message.user = @user
  reply_message.topic_id = @topic.id
  reply_message.follow_message = message
  reply_message.save

  visit message_path(message)
  response.body.should =~ /repost/m
end

