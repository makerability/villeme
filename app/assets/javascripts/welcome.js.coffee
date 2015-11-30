# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->


  $('input[name="invite[persona_ids][]"]').on 'change', (e) ->
    if $('input[name="invite[persona_ids][]"]:checked').length > 2
      $(this).prop 'checked', false
    return



  # rola ate os beneficios
  $("a[href^=\"#beneficios\"]").on "click", (e) ->
    e.preventDefault()
    target = @hash
    $target = $(target)
    $("html, body").stop().animate
      scrollTop: $target.offset().top
    , 900, ->
      window.location.hash = target
      return

    return

  # esconde head ao rolar tela
#  h = window.innerHeight
#  if h > 750
#    $("#header-hide-on-scroll, #header-hide-on-scroll-dark").height h
#    $("#header-hide-on-scroll-dark").css "margin-top", -h
#  else
#    $("#header-hide-on-scroll, #header-hide-on-scroll-dark").height 750
#    $("#header-hide-on-scroll-dark").css "margin-top", -750

#  $(window).on "scroll", ->
#    st = $(this).scrollTop()
#    $("#header-hide-on-scroll").css "opacity", (1 - st / h)
#    $("#header-hide-on-scroll").css "background-position", "0px " + (0 - (st / 2)).toString() + "px"
#    $(".plataforms").css "top", (h / 9) + (st / 4)
#
#
#    return


  $(".plataforms img").hover (->
    $(".ButtonTryPortoAlegre").show()
    return
  ), ->
    $(".ButtonTryPortoAlegre").hide()
    return

  $(".ButtonTryPortoAlegre").hover ->
    $(this).show()
    return




  #troca a fotografia de fundo
#  setTimeout( ->
#    $("#header-hide-on-scroll").animate
#      opacity: 1
#    , 1200
#
#    $(".plataforms").animate
#      top: 25
#    , 800
#
#    $("#header-hide-on-scroll-dark").animate
#      opacity: 0
#    , 1200
#
#  , 2500
#  )


  # Gmail em breve
  $(".gmail").mouseover ->
    $(this).find(".text").text("disponível em breve")
    return

  $(".gmail").mouseleave ->
    $(this).find(".text").text("entrar com gmail")
    return


  $(".goals .has-modal").click ->
    city = $(this).attr('data-city')
    return

  $(".Gmap-inputAddress").one 'focus', ->
    Villeme.Gmap.newMap(-22.951916, -43.210487,
      draggable: true
      activeSearch: true
      zoomControl: true
      zoom: 15
    )

    setTimeout(->
      if navigator.geolocation
        map = $(".Gmap-map").gmap3("get")
        navigator.geolocation.getCurrentPosition ((position) ->
            latLng = new (google.maps.LatLng)(position.coords.latitude, position.coords.longitude)
            Villeme.Gmap.centralizeMapTo(latLng)
            Villeme.Gmap.putMarkerOnPosition(latLng,
              draggable: true
            )
            return
          ), ->
          handleNoGeolocation true
          return
    , 650)
    return


  return
