#= require modules/gmap/Gmap__accents-map

@Villeme = @Villeme or {}

Villeme.Gmap = do ->

  _addressArray = []

  _config =
    autocompleteWidth: $("#address").outerWidth()
    markerUser: "/images/marker-user.png"
    markerPlace: "/images/marker-place.png"


  _initialize = (options) ->
    activeSearch: _activeSearch() if options.activeSearch is true
    canvasSize: _setCanvasSize(options.canvasSize.width, options.canvasSize.height) if options.canvasSize isnt undefined
    buttonToSearchAddress: _buttonToSearchAddress.disable()
    showMapCanvasIfHidden: _showMapCanvasIfHidden()
    autocompleteToSearchAddress: _autocompleteToSearchAddress.active()
    autocompleteWidth: _config.autocompleteWidth = options.autocompleteWidth or $("#address").outerWidth()
    return


  _showMapCanvasIfHidden = ->
    if $('#map').css('display') is 'none'
      $('#map').show()

    return



  _setCanvasSize = (width, height) ->
    if width is undefined  and height is undefined
      $('#map').width('100%').height(350)
    else if width is undefined
      $('#map').width('100%').height(height)
    else if height is undefined
      $('#map').width(width).height(350)
    else
      $('#map').width(width).height(height)

    return

  _activeSearch = ->
    _buttonToGetLocation()
    _inputToGetLocationOnKeyup()
    _validInputToGetLocation.init()
    return



  _buttonToGetLocation = ->
    $('.js-btn-geocoder-address-for-map').click ->
      address = $('#address').val()
      @getLocationFrom(address,
        draggable: true
      )
      return
    return


  _inputToGetLocationOnKeyup = ->
    $('#address').keyup ->
      address = this.value
      if address.length > 5
        _validInputToGetLocation.searching()
        _autocompleteToSearchAddress.update(address)
        delay( ->
          Villeme.Gmap.getLocationFrom(address,
            draggable: true
          )
          return
        , 1100)

      return

    delay = do ->
      timer = 0
      (callback, ms) ->
        clearTimeout timer
        timer = setTimeout(callback, ms)
        return

    return



  _validInputToGetLocation =
    init: ->
      $("#address").focusout ->
        address = this.value.length
        if address <= 5
          _buttonToSearchAddress.disable()
          _validInputToGetLocation.invalid()

        return
      return

    searching: ->
      $("#address").css("border-color", "#5fcf80").parent().find(".Gmap-loadingResponse").text("Searching...")
      return

    invalid: ->
      $("#address").css("border-color", "#A94442").parent().find(".Gmap-loadingResponse").text("Address not found")

      shakeInput = ((intShakes=3, intDistance=10, intDuration=500) ->
        $("#address").css 'position', 'relative'
        x = 1
        while x <= intShakes
          $("#address").animate({ left: intDistance * -1 }, intDuration / intShakes / 4).animate({ left: intDistance }, intDuration / intShakes / 2).animate { left: 0 }, intDuration / intShakes / 4
          x++
      )()

      return

    valid: ->
      $("#address").css("border-color", "#5fcf80").parent().find(".Gmap-loadingResponse").text("")
      return




  _getAddressOfMarker = (map, marker) ->
    $(map).gmap3 getaddress:
      latLng: marker.getPosition()
      callback: (results) ->

        $map = $(this).gmap3("get")
        infowindow = $(this).gmap3(get: "infowindow")
        latLng = results[0].geometry.location
        infowindowMessage = (if results and results[0] then "Endereço encontrado!" else "Endereço não encontrado")
        address = (if results and results[0] then results and results[0].formatted_address else "no address")

        $("#address").val address

        if infowindow
          infowindow.open $map, marker
          infowindow.setContent infowindowMessage
        else
          $(map).gmap3 infowindow:
            anchor: marker
            options:
              content: infowindowMessage

        $map.panTo latLng

        return
    return



  _buttonToSearchAddress =
    disable: ->
      $(".js-btn-to-search-address").prop("disabled", true).addClass("disabled")
      return
    enable: ->
      $(".js-btn-to-search-address").prop("disabled", false).removeClass("disabled")
      return



  _autocompleteToSearchAddress =
    active: ->

      normalize = (term) ->
        ret = ''
        i = 0
        while i < term.length
          ret += Villeme.Gmap__accentsMap[term.charAt(i)] or term.charAt(i)
          i++
        ret

      $("#address").autocomplete
        source: (request, response) ->
          matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), 'i')
          response $.grep(_addressArray, (value) ->
            value = value.label or value.value or value
            matcher.test(value) or matcher.test(normalize(value))
          )
          return
        minLength: 3
        delay: 500
        appendTo: "#modal .modal-body"
        open: ->
          $(".ui-autocomplete").css
            "display": "absolute"
            "max-width": "auto"
            "width": _config.autocompleteWidth

          return
      return

    update: (address) ->
      $("#address").gmap3
        getlatlng:
          address: address
          callback: (results) ->
            if results.length > 0
              results = results.slice(0,5)
              _addressArray = (item.formatted_address for item in results)

            return

      return




  return {
    newMap: (latitude, longitude, options) ->

      _initialize(options)

      style = [{"featureType":"road","elementType":"geometry","stylers":[{"lightness":100},{"visibility":"simplified"}]},{"featureType":"water","elementType":"geometry","stylers":[{"visibility":"on"},{"color":"#d6defa"}]},{"featureType":"poi.business","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"geometry.fill","stylers":[{"color":"#dff5e6"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#D1D1B8"}]},{"featureType":"landscape","elementType":"geometry.fill","stylers":[{"color":"#ffffff"}]}]

      $("#map").gmap3
        map:
          options:
            center: [
              latitude
              longitude
            ]
            zoom: options.zoom or 13
            mapTypeId: google.maps.MapTypeId.ROADMAP
            mapTypeControl: false
            mapTypeControlOptions:
              style: google.maps.MapTypeControlStyle.DROPDOWN_MENU

            navigationControl: false
            streetViewControl: false
            scrollwheel: options.scrollwheel or false
            scaleControl: options.scaleControl or false
            zoomControl: options.zoomControl or false
            zoomControlOptions:
              style: google.maps.ZoomControlStyle.SMALL,
              position: google.maps.ControlPosition.RIGHT_TOP
            styles: style

        marker:
          latLng: [
            latitude
            longitude
          ]
          options:
            draggable: options.draggable or false
            icon: options.marker or _config.markerUser

          events:
            dragend: (marker) ->
              _getAddressOfMarker(this, marker)
              return
      return



    getLocationFrom: (address, options) ->
      $("#map").gmap3
        clear:
          name: "marker"

        getlatlng:
          address: address
          callback: (results) ->
            unless results
              _validInputToGetLocation.invalid()
              _buttonToSearchAddress.disable()
            else
              _validInputToGetLocation.valid()
              _buttonToSearchAddress.enable()

              $(this).gmap3 marker:
                latLng: results[0].geometry.location
                options:
                  draggable: options.draggable or false
                  icon: options.marker or _config.markerUser
                events:
                  dragend: (marker) ->
                    _getAddressOfMarker(this, marker)
                    return

              map = $(this).gmap3("get")
              latLng = results[0].geometry.location
              map.panTo latLng

            return

      return
  }

  return