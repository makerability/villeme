<style>

</style>

<template>

  <div v-on:mouseenter="mouseEnterEvents" v-on:mouseleave="mouseLeaveEvents" v-on:click="saveScroll" class="Event Event--newsFeed grid Grid-cell u-size4of12 u-lg-size4of12 u-md-size4of12 u-sm-size6of12">

    <div class="Event-buttonsBox item-{{ data.id }}">

      <span title="{{ data.period_that_occurs }}" class="Event-button Event-dayButton Event--newsfeed js-EventDayButton is-schedule has-tooltip">
        {{ data.day_of_week }}   {{ data.start_hour }}
      </span>

      <span v-on:click="schedule" class="Event-button Event-agendaButton" v-bind:class="{ 'is-schedule': scheduled }">
        <span class="Event-buttonText js-EventButtonText">{{ button_text }}</span>
        <span class="Event-agendedByCount js-agendedByCount has-tooltip" title="{{ data.agended_by.text }}">{{ data.agended_by.count }}</span>
      </span>

    </div>

    <div class="js-EventNewsfeedTransitions panel panel-default shadow-animation">

      <div class="Event-content">

        <a href="{{ base_url + data.link }}" data-push="true">
          <div class="Event-overlay"></div>
        </a>

        <div class="Event-detailsBox" v-on:mouseenter="zoomInMap" v-on:mouseleave="zoomOutMap">
          <div class="Event-place">
            <span class="glyphicon glyphicon-map-marker"></span>
            <a href="{{ base_url + data.place.link }}" v-on:click="open_place_page">
              {{ data.place.name }}
            </a>
          </div>
        </div>

        <div class="Event-imageBox b-lazy" data-src="{{ data.image.medium }}"></div>

        <div class="caption">
          <span v-if="data.subcategories" class="Event-subCat">
            {{ data.subcategories }}
          </span>
          <h2 class="Event-title">
            <a href="{{ base_url + data.link }}" data-push="true">
              {{ data.name }}
            </a>
          </h2>
          <span class="Event-description">
            {{ data.description }}
          </span>
          <div class="Event-infos">
            <span class="Event-infosPrice  Event-infosItem {{ data.price.highlight }}">
              {{ data.price.value }}
            </span>
            <span v-if="data.rating" class="Event-infosRating Event-infosItem">
              <span class="Event-infosRatingStar glyphicon glyphicon-star"></span>
              {{ data.rating }}
            </span>
            <span v-if="data.friends.someone_will" class="Event-infosFriends Event-infosItem">
              <div v-for="friend in data.friends.will">
                <i class="has-tooltip avatar-icon" title="{{ friend.name }}  agendou o evento">
                  <img src="{{ friend.avatar.url + friend.avatar.origin == 'facebook' ? '&width=22&height=22' : '' }}" class="img-circle image" width="22" height="22">
                </i>
              </div>
            </span>

          </div>
        </div>
      </div>
    </div>

  </div>

</template>

<script>

var Vue = require('vue');
Vue.use(require('vue-resource'));

export default{
  data(){
    return {
      base_url: window.location.origin,
      button_text: "Agendar",
      scheduled: false
    }
  },

  props: {
    data: {
      type: Object,
      default: {}
    }
  },

  ready: function(){
    var _self = this;


    // Vue.http({url: '/pt-BR/api/v1/sections/rio-de-janeiro/items.json', method: 'GET'}).then(function (response) {
    //   _self.$set('data', response.data);
    // }, function (response) {
    //   alert("Ops");
    // });
  },

  methods: {
    mouseEnterEvents: function(event){
      this.$dispatch('setCounter');
      // this.$dispatch('stopCounting'),
      //
      // function _showElements(){
      //   Villeme.Observer.trigger('itemMouseOver', this);
      // }
    },

    mouseLeaveEvents: function(event){
      // var delay = 4000;
      //
      // _startCounter();
      //
      // function _startCounter(){
      //   section.timeouts.push(setTimeout(_hideInfoGroup, delay));
      // }
      //
      // function _hideInfoGroup(){
      //   Villeme.Observer.trigger('itemMouseLeave', item);
      // }
    },


    schedule: function(event){
      var _agendaCounterRefresh, _updateStateOfButton, _updateStateOfAllItemsButtons, _self;

      _self = this;
      _self.button_text = "Agendando...";

      $.ajax({
        url: _self.base_url + _self.data.actions.schedule
      }).done(function(data) {
        _updateStateOfButton(data);
        _updateStateOfAllItemsButtons(data);
        _agendaCounterRefresh(data);
      });

      _agendaCounterRefresh = function(data) {
        var timer;
        clearTimeout(timer);

        _self.$emit('updateAgendaCount', data.count);

        if(data.agended){
          _animateAgendaLink("is-adding");
        }else{
          _animateAgendaLink("is-removing");
        }
      };

      _animateAgendaLink = function(add_or_remove){
        $(".js-SidebarLeft-agendaLink").addClass(add_or_remove);
        timer = setTimeout(function(){
          $(".js-SidebarLeft-agendaLink").removeClass(add_or_remove);
        }, 300)
      };

      _updateStateOfButton = function(data){
        if (_self.data.agended) {
          _self.scheduled = true;
          _self.button_text = "Agendado";
        } else {
          _self.scheduled = false;
          _self.button_text = "Agendar";
        }
        _self.data.count = data.agended_by_count;
        _self.data.agended_by.title = data.new_title;
      };

      _updateStateOfAllItemsButtons = function(data){
        var _buttonText, _item;
        _buttonText = data.agended ? 'Agendado' : 'Agendar';
        _item = ".item-" + _self.data.id;

        $(_item).find('.Event-agendaButton').toggleClass('is-schedule');
        $(_item).find('.Event-buttonText').text(_buttonText);
        $(_item).find('.Event-agendedByCount').text(data.agended_by_count);
      };
    },


    open_place_page: function(){
      window.open(this.base_url + this.place.link)
    },

    saveScroll: function(){
      window.Villeme.tempScroll = $(window).scrollTop();
    },


    zoomInMap: function(){
      clearInterval(this.zoomTimer);
      this.zoomTimer = setTimeout(function(){
        Gmaps.zoomTo(15);
      }, 450);
    },

    zoomOutMap: function(){
      clearInterval(this.zoomTimer);
      Gmaps.zoomTo(13)
    }

  }
}
</script>
