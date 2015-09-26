$(document).on 'ready page:done', ->

  EventShow =

    init: ->
      EventShow.readMore()
      EventShow.createTip()
      EventShow.tipDescription()
      return


    readMore: ->
      url = $(location).attr('href')

      $(".js-EventSingle-readMore, .snippet").click ->
        $.ajax(
          url:  url + "/fulldescription"
        ).done (data) ->

          $(".EventSingle-readMore").hide()

          description = data.full_description
          $(".EventSingle-description").removeClass("snippet").html(description)
          return
        return
      return


    createTip: ->
      $("#new-tip").on 'ajax:success', (event, data, status, xhr) ->
        if data.valid
          $(".tips").prepend("<li class='list-group-item'><b>" + data.user + "</b> - " + data.description + " — <span class='grey-font-50'>Há " + data.created_at + "</span></li>")
        else
          $(".tips").prepend("<li class='list-group-item'><b>Você so pode enviar 2 dicas por evento.</b></li>")

        return
      return


    tipDescription: ->
      $("#tip_description").keyup ->
        max = 140
        len = $(this).val().length
        if len >= max
          $(".tip-counter b").text "Sua dica precisa ter menos de 140 caracteres."
        else
          char = max - len
          $(".tip-counter b").text char + " caracteres."
        return
      return

  $ ->
    EventShow.init()
    return


  return

