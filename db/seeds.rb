require "date"
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)




99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:             password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(2)
40.times do |n|
  event = "練習#{n}"
  wd = ["日", "月", "火", "水", "木", "金", "土"]
  d = n.days.ago
  memo = "楽しみましょう"
  users.each { |user| user.events.create!(event: event,
                                          date:  d.strftime("%Y/%m/%d(#{wd[d.wday]})"),
                                          memo:  memo) }
end

