class Comment extends Backbone.Model

class Comments extends Backbone.Collection
  model: Comment



class ItemView extends Backbone.View

  events:
    'click .RatingButtonPlus' : 'incrementRating'
    'click .RatingButtonMinus' : 'decrementRating'

  elements:
    ratingInput: '.CommentRating'
    plusButton: '.RatingButtonPlus'
    minusButton: '.RatingButtonMinus'

  initialize: (item, collection, el) ->
    @commentsCollection = collection
    @comment = new Comment(item)
    @setElement(el)
    for key, selector of @elements
        @[key] = @$el.find(selector)
    @comment.view = @
    @commentsCollection.push(@comment)

  incrementRating: ->
    newRating = @comment.get('rating')+1
    @ratingInput.text(newRating)
    @comment.set('rating', newRating)
    @plusButton.addClass('disabled')
    @minusButton.addClass('disabled')

  decrementRating: ->
    newRating = @comment.get('rating')-1
    @ratingInput.text(newRating)
    @comment.set('rating', newRating)
    @plusButton.addClass('disabled')
    @minusButton.addClass('disabled')


class MainView extends Backbone.View
  el: '#TestTaskView'

  initialize:(collection) ->
    @commentsCollection = new Comments
    _(collection).each (item, index) =>
      el = @$el.find('.CommetItem')[index]
      new ItemView(item, @commentsCollection, el)

class Root extends BaseController
  @path: '(/)'

  initialize:->
    new MainView(gon.current_resource)

Route.map Root