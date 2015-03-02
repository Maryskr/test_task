class Comment extends Backbone.Model

class Comments extends Backbone.Collection
  model: Comment



class ItemView extends Backbone.View

  events:
    'click .RatingButtonPlus' : 'incrementRating'
    'click .RatingButtonMinus' : 'decrementRating'
    'click .ReplyCommentButton' : 'showReplyForm'
    'click .ShowComment': 'showComment'

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
    newRating = parseInt(@comment.get('rating'))+1
    @ratingInput.text(newRating)
    @comment.set('rating', parseInt(newRating))
    @plusButton.addClass('disabled')
    @minusButton.addClass('disabled')
    @updateRating()

  decrementRating: ->
    newRating = parseInt(@comment.get('rating'))-1
    @ratingInput.text(newRating)
    @comment.set('rating', parseInt(newRating))
    @plusButton.addClass('disabled')
    @minusButton.addClass('disabled')
    @updateRating()

  updateRating: ->
    $.ajax
      url: '/comment/' + @comment.get('id')
      method: 'PUT'
      dataType: 'json'
      data:
        comment:
          rating: parseInt(@comment.get('rating'))
      success: (data) =>
        alertify.success 'Thanks!'
      error: (errors) =>
        console.log(errors.responseJSON.errors)

  getFormData: ->
    articleId: @articleId
    deeps: @comment.get('deeps')
    parent: @comment.get('id')

  showReplyForm: ->
    @$el.append @formView.render(@getFormData())

  hideComments: ->
    @mainBlock = @$el.offsetParent.offsetParent
    @mainBlock.find('.ChildCommentBlock').toggle()
    @mainBlock.find('.CommentActions').toggle()

  showComment: (e) ->
    @$el.find('.comment').toggle()
    @$(e.currentTarget).hide()

class FormView extends Backbone.View

  initialize: (@collection) ->
    @template = JST.form
    @setElement $("<div>")

    InitAjaxForm @$el, 'form.AjaxForm'
    # @$el.on 'ajax_form:submit', 'form.AjaxForm', (e) =>
    @$el.on 'ajax_form:success', @onSuccess

  onSuccess:(e) =>
    alertify.success 'Comment added!'
    @newComment = new Comment {
      user_avatar: 'noavatar.png',
      user_name: @$el.find('.CommentUserName').val(),
      user_email: @$el.find('.CommentUserAvatar').val(),
      content: @$el.find('.CommentContent').val(),
      deeps: @$el.find('.CommentDeeps').val(),
      parent_id: @$el.find('.CommentParentId').val() || null,
      rating: 0
    }
    id = @$el.find('.ArticleId').val()
    @parent = @collection.get(@newComment.get('parent_id'))
    template = JST.comment(comment: @newComment)
    if @parent
      elem =  @parent.view.$el
      @.remove() 
      el = $(template)
      elem.after el
    else
      elem =  $('.ParentCommentBlock')
      el = $(template)
      elem.append el
      @$el.find('input, textarea').val('')

    subcomment = el.find('.CommentItem')[0]
    new ItemView(@newComment,subcomment, @)
    $('.TestTaskPageContent').append @.render(articleId: @id, deeps: 0)

  render: (data = {}) ->
    @$el.html @template(data)

class MainView extends Backbone.View
  el: '#TestTaskView'

  elements:
    articleId: '.ArticleIdInput'

  events:
    'click .CommentActions': 'hideComments'

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
      el = @$el.find('.CommentItem[data-id='+item.get("id")+']')  
      new ItemView(item, el, @formView)
    
    @setArticleTimeDuration(article.created_at)
    @showReplyForm()


  showReplyForm: ->
    @$el.find('.TestTaskPageContent').append @formView.render(articleId: @id, deeps: 0)

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


  hideComments: (e) ->
    @mainBlock = @$(e.currentTarget.offsetParent.offsetParent)
    @mainBlock.find('.ChildCommentBlock').toggle()
    @mainBlock.find('.CommentActions').toggle()

class Root extends BaseController
  @path: '(/)'

  initialize:->
    new MainView(gon.current_resource, gon.article)

Route.map Root