require "date"
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

65.times do |n|
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

User.create!(name:  "豊泉　喜一郎",
             email: "sinnet_1220@ezweb.ne.jp",
             password:              "Roro1043",
             password_confirmation: "Roro1043",
             admin: true,
             activated: true,
             activated_at: 2.minutes.ago.to_datetime)

40.times do |n|
  event_name = "練習#{n+1}"
  date = (n+1).days.since.to_datetime
  memo = "楽しみましょう"
  user = User.find_by(id: n+1)
  user.events.create!(event_name:  event_name,
                      date:        date,
                      memo:        memo,
                      url_token:   SecureRandom.hex(10))

end

users = User.order(:created_at).take(6)
40.times do |n|
  x = n.modulo(3)
  if x == 1
    status = x
  elsif x == 2
    status = x
    reason  = "法事#{n+1}かも"
    remarks = "明日分かる"
  else
    status = x + 3
    reason = "旅行"
  end

  event = Event.find_by(id: n+1)
  users.each { |user| event.answers.create!(status:  status,
                                            reason:  reason,
                                            remarks: remarks,
                                            user_id: user.id)
                      #event.update_attribute(:hasAnswered, true)
  }
end

