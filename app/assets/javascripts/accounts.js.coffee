
$(document).on 'ready page:load', ->

  $(":file").filestyle
    buttonText: "Escolher foto"
    classButton: "btn btn-default"
    iconName: "icon-plus"
    input: false

  $(".avatar-upload").click ->
    $("#user_avatar").click()
    return

  Gmaps.newMap(gon.latitude, gon.longitude,
    activeSearch: true
    draggable: true
  )

  $('#edit-user').bootstrapValidator
    message: 'Algo está errado, acho que não pode ficar vazio.'
    feedbackIcons:
      valid: 'glyphicon glyphicon-ok'
      invalid: 'glyphicon glyphicon-remove'
      validating: 'glyphicon glyphicon-refresh'

  $('.has-selectpicker').selectpicker()

  $('.has-selectpicker').change ->
    if $(this).val() == ''
      $(this).parent('.form-group').removeClass('has-success').addClass 'has-error'
    else
      $(this).parent('.form-group').removeClass('has-error').addClass 'has-success'
    return


return