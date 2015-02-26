class Comment extends Backbone.Model

class Comments extends Backbone.Collection
  model: Comment



class ItemView extends Backbone.View

  events:
    'click .RatingButtonPlus' : 'incrementRating'
    'click .RatingButtonMinus' : 'decrementRating'
    'click .ReplyCommentButton' : 'showReplyForm'
    'click .SubmitButton': 'sendForm'

  elements:
    ratingInput: '.CommentRating'
    plusButton: '.RatingButtonPlus'
    minusButton: '.RatingButtonMinus'
    form: '.CreateComment'

  initialize: (item, collection, el, id, @formView) ->
    @articleId = id
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

  getFormData: ->
    articleId: @articleId
    deeps: @comment.get('deeps')+1
    parent: @comment.get('id')

  showReplyForm: ->
    @$el.append @formView.render(@getFormData())

  sendForm: ->

class FormView extends Backbone.View

  initialize: ->
    @template = JST.comment
    @setElement $("<div>")

    InitAjaxForm @$el, 'form.AjaxForm'
    @$el.on 'ajax_form:submit', 'form.AjaxForm', (e) =>
      console.log 'on submit'

  render: (data = {}) ->
    @$el.html @template(data)

class MainView extends Backbone.View
  el: '#TestTaskView'

  elements:
    articleId: '.ArticleIdInput'
    form: '.CreateComment'

  initialize:(collection) ->
    @formView = new FormView

    for key, selector of @elements
        @[key] = @$el.find(selector)
    @id = @articleId.val()
    @commentsCollection = new Comments
    _(collection).each (item, index) =>
      el = @$el.find('.CommentItem')[index]
      new ItemView(item, @commentsCollection, el, @id, @formView)
    @form.on 'submit', (e) -> e.preventDefault(); false

class Root extends BaseController
  @path: '(/)'

  initialize:->
    new MainView(gon.current_resource)

Route.map Root