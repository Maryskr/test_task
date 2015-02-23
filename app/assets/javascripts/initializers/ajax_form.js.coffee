add_errors = ($form, errors) ->
  clear_errors($form)
  for key, value of errors
    add_error $form, key, value.join("<br/>")

add_error = ($form, field, text) ->
  $field = $form.find("[data-field=#{field}]")
  $field.addClass('error')
  $field.append "<div class='ui red pointing above ui label ValidationError'>#{text}</div>"

clear_errors = ($form) ->
  $form.find('.ValidationError').remove()
  $form.find('[data-field]').removeClass('error')

OnPageLoad ->
  $("form.AjaxForm").on 'submit', (event) ->
    event.preventDefault()
    form = event.currentTarget
    $form = $(form)

    withValidation = $form.hasClass("Validation")
    if withValidation
      clear_errors $form

    $form.trigger 'ajax_form:submit', [event, form, $form]
    $.ajax
      url:  $form.attr('action')
      type: $form.attr('method')
      data: $form.serialize()
      dataType: $form.data('type') || 'json'
      success: (args...) ->
        $form.trigger 'ajax_form:success', args.concat([event, form, $form])
      error: (data, status, message) ->
        if withValidation
          response = data.responseJSON
          errors   = response.errors
          if errors
            add_errors $form, errors
          else if response?.error
            alertify.error response.error
          else
            console.error data, status, message
        $form.trigger 'ajax_form:error', [data, status, message, event, form, $form]
      complete: (data, status) ->
        $form.trigger 'ajax_form:complete', [data, status, event, form, $form]