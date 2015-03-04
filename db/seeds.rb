# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Article.destroy_all

Article.create(
  title: 'PENGUINS',
  content: 'Penguins are aquatic, flightless birds that are highly adapted to life in the water. 
            Their distinct tuxedo-like appearance is called countershading, a form of camouflage that helps keep them safe in the water. 
            Penguins do have wing-bones, though they are flipper-like and extremely suited to swimming. 
            Penguins are found almost exclusively in the southern hemisphere, where they catch their food underwater and raise their young on land.'
)

Comment.destroy_all

Comment.create([
  { user_name: 'Lolo', 
    user_email: 'Jonh9@mail.com', 
    content: 'Penguins can be found on every continent in the Southern Hemisphere from the tropical Galapagos Islands (the Galapagos penguin) located near South America to Antarctica (the emperor penguin).', 
    article_id: Article.first.id, 
    rating: -9 }
  ])
Comment.create(
  { user_name: 'Pepe', 
    user_email: 'Linda@mail.com', 
    content: 'Penguins can spend up to 75% of their lives in the water. They do all of their hunting in the water. Their prey can be found within 60 feet of the surface, so penguins have no need to swim in deep water. They catch prey in their beaks and swallow them whole as they swim. Some species only leave the water for molting and breeding.', 
    article_id: Article.first.id,
    parent_id: Comment.first.id })
