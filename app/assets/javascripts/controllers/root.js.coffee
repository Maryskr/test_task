class Comment extends Backbone.Model

class Comments extends Backbone.Collection
  model: Comment



class ItemView extends Backbone.View

  events:
    'click .RatingButtonPlus' : 'incrementRating'
    'click .RatingButtonMinus' : 'decrementRating'
    'click .ReplyCommentButton' : 'showReplyForm'

  elements:
    ratingInput: '.CommentRating'
    plusButton: '.RatingButtonPlus'
    minusButton: '.RatingButtonMinus'
    dateDuration: '.CommentDateDuration'

  initialize: (comment, el, @formView) ->
    @comment = comment
    @articleId = @comment.get('article_id')
    @setElement(el)
    for key, selector of @elements
        @[key] = @$el.find(selector)
    @comment.view = @
    @setCommentTimeDuration()

  render: (template) ->
    @$el.html template
    
  setCommentTimeDuration: ->
    now = moment()
    duration = moment.duration(now.diff(@comment.get('created_at')));
    result = 
      switch
        when duration.days() > 0 then duration.days() + ' days ago'
        when duration.hours() > 0 then duration.hours() + ' hours ago'
        when duration.minutes() > 0 then duration.minutes() + ' min ago'
        when duration.minutes() == 0 then 'right now'
    @dateDuration.text(result)

  incrementRating: ->
    console.log @comment
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

class FormView extends Backbone.View

  initialize: (@collection) ->
    @template = JST.form
    @setElement $("<div>")

    InitAjaxForm @$el, 'form.AjaxForm'
    @$el.on 'ajax_form:submit', 'form.AjaxForm', (e) =>
     @$el.on 'ajax_form:complete', @onSuccess

  onSuccess:(e) =>
    alertify.success 'Comment added!'
    @newComment = new Comment {
      user_avatar: 'noavatar.png',
      user_name: @$el.find('.CommentUserName').val(),
      user_email: @$el.find('.CommentUserAvatar').val(),
      content: @$el.find('.CommentContent').val(),
      deeps: @$el.find('.CommentDeeps').val(),
      parent_id: @$el.find('.CommentParentId').val(),
      rating: 0
    }
    id = @$el.find('.ArticleId').val()
    @parent = @collection.get(@newComment.get('parent_id'))
    console.log @newComment.get('content')
    template = JST.comment(comment: @newComment)
    elem =  @parent.view.$el
    el = $(template)
    elem.after el

    subcomment = el.find('.CommentItem')[0]
    new ItemView(@newComment,subcomment, @)
    console.log subcomment
    @.remove()

  render: (data = {}) ->
    @$el.html @template(data)

class MainView extends Backbone.View
  el: '#TestTaskView'

  elements:
    articleId: '.ArticleIdInput'
    form: '.CreateComment'

  initialize:(collection, article) ->

    for key, selector of @elements
        @[key] = @$el.find(selector)
    @id = @articleId.val()
    @commentsCollection = new Comments
   
    _(collection).each (item) =>    
      @comment = new Comment(item)
      @comment.set('article_id', @id)
      @commentsCollection.push(@comment)

    @formView = new FormView(@commentsCollection)

    _(@commentsCollection.models).each (item, index) =>
      el = @$el.find('.CommentItem')[index]  
      new ItemView(item, el, @formView)
    
    @setArticleTimeDuration(article.created_at)

  setArticleTimeDuration: (articleTime) ->
    now = moment()
    duration = moment.duration(now.diff(articleTime));
    result = 
      switch
        when duration.days() > 0 then duration.days() + ' days ago'
        when duration.hours() > 0 then duration.hours() + ' hours ago'
        when duration.minutes() > 0 then duration.minutes() + ' min ago'
        when duration.minutes() == 0 then 'right now'
    @$el.find('.ArticleDateDuration').text(result)

class Root extends BaseController
  @path: '(/)'

  initialize:->
    new MainView(gon.current_resource, gon.article)

Route.map Root