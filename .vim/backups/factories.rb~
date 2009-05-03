Factory.define :user do |u|
  u.login 'user'
  u.password 'password'
  u.password_confirmation 'password'
  u.email 'test@example.com'
end

Factory.define :role do |r|
  r.name "admin"
  #p.permissions { |p| [p.association(:user)] }
end

Factory.define :permission do |p|
  p.name "all" 
  p.perm_resource "topics" 
  p.perm_type "C"
end

Factory.define :message do |m|
  m.title "new message"
  m.body "message content"
end

Factory.define :topic do |t|
  t.name "Topic"
  t.description "Topic Desc"
end

Factory.define :gallary do |g|
  g.name "gallary"
end
