User.create!(name: "Pham Van Le",
             email: "phamvanle10dt2.bkdn@gmail.com",
             password: "123123",
             password_confirmation: "123123",
             admin: true)

User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password: "foobar",
             password_confirmation: "foobar")

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "123123"
  User.create!(name:  name,
               email: email,
               password: password,
               password_confirmation: password)
end
