When /^I send a friend invite request$/ do
  #response.body.should =~ /abc/m
  fill_in "message[title]", :with => "hello"
  fill_in "message[body]", :with => "I want add you to my friend"
  click_button "Send"
end

Then /^user (.*) should received a request from (.*)$/ do |receiver, sender|
  recv = User.find_by_login(receiver)
  send = recv.strangers.find_by_login(sender)
  send.nil?.should == false
end

Given /^I am on my request list page$/ do
  @user.login.should == "Jerry"
  visit "/user/#{@user.login}/panel"
  click_link "Friend Box"
end

Given /^the following list request:$/ do |requests|
  requests.hashes.each do |m|
    user = Factory.create :user, :login => m["sender"], :email => "#{m["sender"]}@test.net" unless m["sender"].nil?
    message = Factory.create :message, :title => m["title"], :body => m["body"]
    message.user = user
    message.receivers << @user
    message.save
    #Message.handle([*message.id]) { |m| m.change_to_request }
    message.handle(user, [*message.id]) { |m| m.change_to_request }

    @user.strangers << user
    @user.save

    unless m[:status].nil?
      # Add code for initial friend status
    end
  end
end

When /^I check the (\d+)(?:st|nd|rd|th) (.*) on friend page$/ do |pos, page_type|
  visit "/user/#{@user.login}/panel"
  click_link "Friend Box"
  within("table > tr:nth-child(#{pos.to_i})") do
    check "#{page_type}_users[]"
  end
end

Then /^I should see the user (.*) list:$/ do |list_type, messages|
  messages.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+1}) > td:nth-child(#{j+2})") { |td|
        td.inner_text.chomp.strip.should =~ /#{cell}/m
      }
    end
  end
end

Given /^the following list friends:$/ do |friends|
  friends.hashes.each do |m|
    user = Factory.create :user, :login => m["friend"], :email => "#{m["friend"]}@test.net" unless m["friend"].nil?
    @user.friends << user
    @user.handle([*user.id]) { |u| u.approve }
    @user.save

    unless m[:status].nil?
      # Add code for initial friend status
    end
  end
end


When /^I goto my friend list page$/ do
  visit "/user/#{@user.login}/panel"
  click_link "Friend Box"
end

Given /^I was blocked by user (.*)$/ do |friend|
  u = User.find_by_login friend
  user = u || Factory.create( :user, :login => friend, :email => "#{friend}@test.net" )
  user.blocked_users << @user
  user.handle([*@user.id]) { |u| u.block }
  user.save
end

Given /^I have blocked (.*)$/ do |friend|
  u = User.find_by_login friend
  user = u || Factory.create( :user, :login => friend, :email => "#{friend}@test.net" )
  @user.blocked_users << user
  @user.handle([*user.id]) { |u| u.block }
  @user.save
end

When /^I goto my block list page$/ do
  visit "/user/#{@user.login}/panel"
  click_link "Block Box"
end

