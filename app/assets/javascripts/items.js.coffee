#= require gmap3
#= require datetimepicker/jquery.datetimepicker.js
#= require jqueryte/dist/jquery-te-1.4.0.min
#= require jquery-maskMoney
#= require jquery.ui.autocomplete
#= require bootstrap-filestyle
#= require gmaps-builder
#= require autocomplete
#= require events/input
#= require modules/Form

(($) ->

  EventForm =

    init: ->
      # EventForm.inputTransitions()
      EventForm.opacityOnInputsNotRequireds()
      EventForm.removeImageFromUpload()
      EventForm.activeHelper()
      EventForm.applyPluginFileStyle()
      EventForm.addMoreHours()
      EventForm.moneyMask()
      EventForm.moreDetails()
      EventForm.descriptionTextTools()
      EventForm.datePickerTimeToPeriod()
      EventForm.datePickerTimeToTime()
      EventForm.daysOfWeekBetweenTwoDates()
      EventForm.dateTimeSectionHideShow()
      return


    inputTransitions: ->
      $("#event-form .has-focus-transition").each ->
        @input_assync = $(this)
        @input = new Input($(this))

        @input_assync.keyup ->
          console.log "Keyuped"
          @input.validSize()
          return

        return

      return


    opacityOnInputsNotRequireds: ->
      $(".not-required").mouseenter ->
        $(this).removeClass("not-required")
        return

      return


    removeImageFromUpload: ->
      $(".remove-img").click ->
        $(".event-img").css("background-image":"none")
        $(":file").filestyle('clear')
        $(".event-text").text("Enviar imagem")
        $(".event-img").removeClass("green-font green-border")
        return

      return

    applyPluginFileStyle: ->
      $(":file").filestyle
        buttonText: "Enviar imagem..."
        classButton: "btn btn-default"
        input: false

      $(".event-img").parents(".form-group").mouseover ->
        fileName = $("#event_image").val()

        if fileName
          $(".event-text").text("Imagem enviada!")
          $(".event-img").addClass("green-font green-border")
        else
          $(".event-text").text("Sem imagem")
          $(".event-img").removeClass("green-font green-border")

        return

      $(".image-upload").click ->
        $("#event_image").click()
        return

      return

    activeHelper: ->
      $(".has-helper").mouseenter ->
        helper = $(this).attr("helper")
        $(".helper-text").html("")
        $("#helper").fadeIn()
        $(".helper-text").html(helper)
        return

        $(".panel").mouseleave ->
          $("#helper").fadeOut()
          return

      return

    addMoreHours: ->
      $(".js-addHour").click ->
        $(this).hide()
        $(this).parents(".EventForm-hour").next(".EventForm-hour.is-hidden").removeClass("is-hidden")
        return

      return


    moneyMask: ->
      $('#event_cost_fake, #event_cost').maskMoney
        prefix: "R$ "
        allowNegative: false
        thousands: "."
        decimal: ","
        affixesStay: false


      $("#event_cost_fake").focusout ->
        dinheiro = $("#event_cost_fake").val()
        dinheiroConvertido = dinheiro.replace(",", ".").replace("R$","")
        $("#event_cost").val(dinheiroConvertido)
        return
      return



    moreDetails: ->
      $(".not-required-show").click ->
        $(this).hide()
        $(".not-required-block").show()
        return


      return


    dateTimeSectionHideShow: ->
      $('.js-date-timepicker').focus ->
        $('.js-datetime-section-hide-show').removeClass('is-Hidden').addClass('is-Visible')
        return
      return


    daysOfWeekBetweenTwoDates: ->

      Date::addDays = (days) ->
        dat = new Date(@valueOf())
        dat.setDate dat.getDate() + days
        dat

      stringToDate = (_date, _format, _delimiter) ->
        formatLowerCase = _format.toLowerCase()
        formatItems = formatLowerCase.split(_delimiter)
        dateItems = _date.split(_delimiter)
        monthIndex = formatItems.indexOf('mm')
        dayIndex = formatItems.indexOf('dd')
        yearIndex = formatItems.indexOf('yyyy')
        month = parseInt(dateItems[monthIndex])
        month -= 1
        formatedDate = new Date(dateItems[yearIndex], month, dateItems[dayIndex])
        formatedDate


      getDates = (dateStart, dateEnd) ->
        oneDay = 24 * 3600 * 1000
        arrayOfDaysOfWeek = []
        dateStartForm = dateStart * 1
        dateEndForm = dateEnd * 1

        if dateStartForm == dateEndForm
          [new Date(dateStartForm).getDay()]
        else
          while dateStartForm < dateEndForm
            arrayOfDaysOfWeek.push new Date(dateStartForm).getDay()
            dateStartForm += oneDay

          arrayOfDaysOfWeek.push new Date(dateEndForm).getDay()
          return arrayOfDaysOfWeek


      jQuery('#date_timepicker_start, #date_timepicker_end').datetimepicker
        onSelectDate: ->
          if $('#date_timepicker_start').val() and $('#date_timepicker_end').val()
            dateStart = $('#date_timepicker_start').val()
            dateEnd = $('#date_timepicker_end').val()
            arrayOfWeeks = getDates(stringToDate(dateStart, 'dd/MM/yyyy', '/'), stringToDate(dateEnd, 'dd/MM/yyyy', '/'))

            $('.js-days-of-week').prop 'checked', false

            arrayOfWeeks.forEach (day) ->
              if day == 0
                $('.js-day-0').prop 'checked', true
              else if day == 1
                $('.js-day-1').prop 'checked', true
              else if day == 2
                $('.js-day-2').prop 'checked', true
              else if day == 3
                $('.js-day-3').prop 'checked', true
              else if day == 4
                $('.js-day-4').prop 'checked', true
              else if day == 5
                $('.js-day-5').prop 'checked', true
              else if day == 6
                $('.js-day-6').prop 'checked', true
              else
              return

      return


    descriptionTextTools: ->
      $("#js-item-description").jqte
        center: false
        color: false
        fsize: false
        funit: false
        format: false
        indent: false
        left: false
        right: false
        outdent: false
        rule: false
        source: false
        sub: false
        sup: false
        focus: ->
          $(".jqte_editor").css
            'height': 360
          return
      return



    datePickerTimeToPeriod: ->
      jQuery('#date_timepicker_start').datetimepicker
        lang: 'pt-BR'
        format: 'd/m/Y'
        onShow: (ct) ->
          @setOptions
            maxDate: if jQuery('#date_timepicker_end').val() then jQuery('#date_timepicker_end').val() else false
            formatDate:'d/m/Y'
          return
        timepicker: false
      jQuery('#date_timepicker_end').datetimepicker
        lang: 'pt-BR'
        format: 'd/m/Y'
        onShow: (ct) ->
          @setOptions
            minDate: if jQuery('#date_timepicker_start').val() then jQuery('#date_timepicker_start').val() else false
            formatDate:'d/m/Y'
          return
        timepicker: false

      return



    datePickerTimeToTime: ->
      jQuery('.js-date-picker-time').datetimepicker
        datepicker: false
        format: 'H:i'
      return


  $ ->
    EventForm.init()
    return


  return

) jQuery
