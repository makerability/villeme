(($) ->

  Form =

    init: ->
      Form.more()
      return


    more: ->

      __open = (->
        $('.js-FormGroup--more__open').click ->
          $('.js-FormGroup--moreContent').removeClass('is-hidden')
          $(this).addClass('is-hidden')
          return
        return
      ) $


  $ ->
    Form.init()
    return


  return

) jQuery
