user1 = User.create(:username => "skittles123", :password => "iluvskittles", :email => "nempey2000@yahoo.com")

user2 = User.create(:username => "flatiron4lyfe", :password => "Rubie!", :email => "faithmp@att.net")

user3 = User.create(:username => "kittens1265", :password => "crazycatlady", :email => "gordmp@att.net")

collection1 = Collection.new(:name => "my album", :creation_date => '2007-01-01 10:00:00', :user_id => 1, :image_id => 1, :img_location => '../public/images/image1.jpeg')
