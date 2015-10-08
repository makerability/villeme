<item onmouseenter={ mouseEnterEvents } onmouseleave={ mouseLeaveEvents }>

  <div class="Event-buttonsBox item-{ id }">

    <span title='{ period_that_occurs }' class='Event-button Event-dayButton Event--newsfeed js-EventDayButton is-schedule has-tooltip'>
      { day_of_week }   { start_hour }
    </span>

    <span onclick={ schedule } class="Event-button Event-agendaButton js-EventAgendaButton { is-schedule: scheduled }">
    <span class="Event-buttonText js-EventButtonText">{ button_text }</span>
      <span class="Event-agendedByCount js-agendedByCount has-tooltip" title="{ agended_by.text }">
        { agended_by.count }
      </span>
    </span>

  </div>

  <div class="js-EventNewsfeedTransitions panel panel-default shadow-animation">

    <div class="Event-content">

      <a href="{ link }" data-push="true">
        <div class="Event-overlay"></div>
      </a>

      <div class="Event-detailsBox">
        <div class="Event-place">
          <span class="glyphicon glyphicon-map-marker"></span>
          <a href="{ place.link }">{ place.name }</a>
        </div>
      </div>

      <div class="Event-imageBox b-lazy" data-src="{ image }"></div>

      <div class="caption">
        <span class="Event-subCat" if={ subcategories }>
            { subcategories }
        </span>
        <h2 class="Event-title">
          <a href="{ link }" data-push="true">{ name }</a>
        </h2>
        <span class="description">
          { description }
        </span>
        <div class="Event-infos">
          <span class="Event-infosPrice  event.price[:css_attributes]  Event-infosItem">
            { price }
          </span>
          <span if={ rating } class="Event-infosRating Event-infosItem">
              <span class="Event-infosRatingStar glyphicon glyphicon-star"></span>
              { rating }
          </span>
          <span class="Event-infosFriends pull-right Event-infosItem">
             <!--unless current_user.which_friends_will_this_event?(event).blank?-->
               <!--current_user.which_friends_will_this_event?(event).each do |friend|-->
                  <i class="has-tooltip avatar-icon" title=" friend.first_name  agendou o evento">
                    <!--get_avatar(friend, "22", "22") -->
                  </i>
               <!--end-->
             <!--end-->
          </span>
        </div>

      </div>
    </div>
  </div>


  <script>

    section = this.parent;

    if(this.is_agended){
      this.button_text = 'Agendado';
      this.scheduled = true;
    }else{
      this.button_text = 'Agendar';
      this.scheduled = false
    }


    mouseEnterEvents(event){
      item = this;

      _setCounter();
      _stopCounting();
      _showElements();

      function _setCounter() {
        section.timeouts = section.timeouts === undefined ? [] : section.timeouts;
      }

      function _stopCounting(){
        i = 0;
        while (i < section.timeouts.length) {
          clearTimeout(section.timeouts[i]);
          i++;
        }
      }

      function _showElements(){
        $(".SidebarMap-neighborhoodCount").hide();
        $(".SidebarMap-infoGroup").filter(":not(:animated)").fadeIn(200);
        $(".SidebarMap-address").fadeIn("fast");
        $(".SidebarMap-address span").html('<b>' + item.place.name + '</b><br/>' + item.full_address);
        $(".js-distanceWithWalking .data").fadeIn("fast").text(item.distance.walk);
        $(".js-distanceWithBike .data").fadeIn("fast").text(item.distance.bike);
        $(".js-distanceWithBus .data").fadeIn("fast").text(item.distance.bus);
        $(".js-distanceWithCar .data").fadeIn("fast").text(item.distance.car);
        var map = $('#map').gmap3("get");
        google.maps.event.trigger(map, "resize");
        Gmaps.panTo(item.latitude, item.longitude);
      }
    }

    mouseLeaveEvents(event){
      var delay = 4000;

      _startCounter();

      function _startCounter(){
        section.timeouts.push(setTimeout(_hideInfoGroup, delay));
      }

      function _hideInfoGroup(){
        $(".SidebarMap-infoGroup, .SidebarMap-address").hide();
        $(".SidebarMap-neighborhoodCount").show();
//        if(Gmaps !== undefined){
//          var latLng = new google.maps.LatLng(gon.latitude, gon.longitude);
//          Gmaps.panTo(latLng);
//        }
      }
    }



    schedule(event){
      var _agendaCounterRefresh, _updateStateOfButton, _updateStateOfAllItemsButtons, item;

      item = this;

      item.button_text = "Agendando...";

      $.ajax({
        url: item.actions.schedule
      }).done(function(data) {
        _updateStateOfButton(data);
        _updateStateOfAllItemsButtons(data);
        _agendaCounterRefresh(data.count);
        item.update();
      });

      _agendaCounterRefresh = function(new_value) {
        $(".js-agendaCounter").text("").text(new_value);
      };

      _updateStateOfButton = function(data){
        if (data.agended) {
          item.scheduled = true;
          item.button_text = "Agendado";
        } else {
          item.scheduled = false;
          item.button_text = "Agendar";
        }
        item.agended_by.count = data.agended_by_count;
        item.agended_by.title = data.new_title;
      };

      _updateStateOfAllItemsButtons = function(data){
        var _buttonText, _item
        _buttonText = data.agended ? 'Agendado' : 'Agendar';
        _item = ".item-" + item.id;

        $(_item).find('.Event-agendaButton').toggleClass('is-schedule');
        $(_item).find('.Event-buttonText').text(_buttonText);
        $(_item).find('.Event-agendedByCount').text(data.agended_by_count);
      };
    }



  </script>




</item>
