(($) ->

  Form =

    init: ->
      Form.more()
      return


    more: ->

      __open = (->
        $('.js-FormGroup--more__open').click ->
          $('.FormGroup--moreContent').show()
          $(this).hide()
          return
        return
      ) $


  $ ->
    Form.init()
    return


  return

) jQuery
