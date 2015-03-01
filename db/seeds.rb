# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Article.destroy_all

Article.create(
  title: 'The Beatles',
  content: 'The Beatles were an English rock band that formed in Liverpool in 1960. 
            With members John Lennon, Paul McCartney, George Harrison and Ringo Starr, they became widely regarded as the greatest and most influential act of the rock era.'
)

Comment.destroy_all

Comment.create([
  { user_name: 'John Lennon', user_email: 'Jonh9@mail.com', content: 'All you need is love', article_id: Article.first.id },
  { user_name: 'Paul McCartney', user_email: 'Linda@mail.com', content: 'Love is all you need', article_id: Article.first.id }
  ])