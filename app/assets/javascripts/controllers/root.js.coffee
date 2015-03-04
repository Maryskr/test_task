class @Comment extends Backbone.RelationalModel
  relations: [{
    type: Backbone.HasMany
    key: 'children'
    relatedModel: 'Comment'
    collectionType: 'Comments'
    reverseRelation: {
      key: 'parent'
      keySource: 'parent_id'
      includeInJSON: 'id'
    }
  }]

  defaults:
    user_avatar: 'noavatar.png'
    rating: 0

class @Comments extends Backbone.Collection
  model: Comment

class SubElementView extends Backbone.View

  elements: {}

  # setElement:
  #   super
  #   for key, selector of @elements
  #       @[key] = @$el.find(selector)


class ItemsView extends SubElementView

  elements:
    list: '.Comments'

  initialize: (@collection, el, @formView) ->
    @setElement el
    @listenTo @collection, 'add', @renderItem

  renderItem: (model) ->
    el = $("<div>")
    @list.append (new BlockView model, el, @formView).render()


class ItemView extends SubElementView

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
    @template = JST.comment
    @comment = comment
    @articleId = @comment.get('article_id')
    @setElement(el)
    @comment.view = @
    # @setCommentTimeDuration()
    @listenTo @comment, 'change', 'render'
    
  # setCommentTimeDuration: ->
  #   now = moment()
  #   duration = moment.duration(now.diff(@comment.get('created_at')));
  #   result = 
  #     switch
  #       when duration.days() > 0 then duration.days() + ' days ago'
  #       when duration.hours() > 0 then duration.hours() + ' hours ago'
  #       when duration.minutes() > 0 then duration.minutes() + ' min ago'
  #       when duration.minutes() == 0 then 'right now'
  #   @dateDuration.text(result)

  # incrementRating: ->
  #   newRating = parseInt(@comment.get('rating'))+1
  #   @ratingInput.text(newRating)
  #   @comment.set('rating', parseInt(newRating))
  #   @plusButton.addClass('disabled')
  #   @minusButton.addClass('disabled')
  #   @updateRating()

  # decrementRating: ->
  #   newRating = parseInt(@comment.get('rating'))-1
  #   @ratingInput.text(newRating)
  #   @comment.set('rating', parseInt(newRating))
  #   @plusButton.addClass('disabled')
  #   @minusButton.addClass('disabled')
  #   @updateRating()

  # updateRating: ->
  #   $.ajax
  #     url: '/comment/' + @comment.get('id')
  #     method: 'PUT'
  #     dataType: 'json'
  #     data:
  #       comment:
  #         rating: parseInt(@comment.get('rating'))
  #     success: (data) =>
  #       alertify.success 'Thanks!'
  #     error: (errors) =>
  #       console.log(errors.responseJSON.errors)

  getFormData: ->
    articleId: @articleId
    deeps: @comment.get('deeps')+1
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


class BlockView extends SubElementView

  elements:
    itemElement: '.Comment'
    itemsElement: '.Comments'

  initialize: (@comment, el, @formView) ->
    @setElement el
    @itemView = new ItemView @comment, @itemElement, @formView
    @itemsView = new ItemsView @comment.get('childrens'), @itemsElement, @formView

  render: ->
    @$el.html @template


class FormView extends Backbone.View

  initialize: (@collection) ->
    @template = JST.form
    @setElement $("<div>")

    InitAjaxForm @$el, 'form.AjaxForm'
    @$el.on 'ajax_form:success', @onSuccess

  onSuccess:(..., $form) =>
    alertify.success 'Comment added!'
    newComment = new Comment $form.serializeJSON().comment
    @collection.add newComment unless newComment.get('parent')

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
    console.log @commentsCollection
   
    _(collection).each (item) =>    
      @comment = new Comment(item)
      @comment.set('article_id', @id)
      @commentsCollection.push(@comment)

    @formView = new FormView(@commentsCollection)

    @commentsCollection.each (item, index) =>
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


Comment.setup()
Route.map Root