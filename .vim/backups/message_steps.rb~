Given /I am on the new message page/ do
  visit "/messages/new"
end

Given /^the existing messages:$/ do |messages|
  Message.create!(messages.hashes)
  visit messages_url
end

When /^I change the message:$/ do |messages|
  click_link "Edit"
  fill_in "title", :with => "new title 1"
  fill_in "body", :with => "new body 1"
end

Given /^the following messages:$/ do |messages|
  Message.create!(messages.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) message$/ do |pos|
  visit messages_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following messages:$/ do |messages|
  messages.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
        td.inner_text.chomp.strip.should == cell
      }
    end
  end
end

Given /^the posted messages:$/ do |messages|
  Message.create!(messages.hashes)
  visit messages_url
  click_link "Show"
end

When /^I reply the message with new message$/ do
#  visit "/messages/#{@message.id}/reply"
  click_link "Reply"
end
