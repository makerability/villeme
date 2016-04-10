<style>

</style>

<template>

  <section v-if="data.count > 0" class="Section" data-anchor="{{ data.type }}">

    <div class="Section-header">
      <h1 class="Section-title">{{ data.title }}
        <small>
          <a href="{{ data.link }}" data-push="true" v-on:click="saveScroll">
            Ver todos
          </a>
        </small>
      </h1>
    </div>

    <div class="Grid Grid--withGutter">


      <item v-for="item in data.items" :data="item"></item>


      <div v-show="data.count <= 2 || data.count == 5" v-if="data.snippet.length == 0" class="Grid-cell u-size4of12 u-lg-size4of12 u-md-sizeFull u-centralize">
        <div class="AlertCreateEvent AlertCreateEvent--withBorder">
          <div class="AlertCreateEvent-text u-posAbsoluteCenter">
            <span>
              Não há mais eventos no momento.<br/>
              <a href="{{ data.policies.is_guest_user ? '#' : data.link_to_create }}" v-on:click={{ data.policies.is_guest_user ? login : false }}>Cria evento</a>
            </span>
          </div>
        </div>
      </div>

      <div v-if="data.snippet.length > 0" v-hide="data.snippet == null" class="EventsSnippet Grid-cell u-size4of12 u-lg-size4of12 u-md-sizeFull">
        <div class="EventsSnippet-content">
          <div class="EventsSnippet-scroll">
            <ul class="EventsSnippet-lineGroup">
              <li each={ data.snippet } v-on:click="saveScroll" class="EventsSnippet-line js-EventNewsfeedTransitions">
                <a href="{{ base_url + link }}" data-push="true">
                  <div class="EventsSnippet-image b-lazy" data-src="{{ data.image.thumb }}"></div>
                </a>
                <div class="EventsSnippet-linePrincipal u-sizeFull">
                  <span class="EventsSnippet-eventName">
                    <a href="{{ base_url + link }}" data-push="true">{{ data.name }}</a>
                  </span>
                </div>
                <div class="EventsSnippet-lineSecond">
                  <span class="EventsSnippet-eventDay EventsSnippet-lineSecondItem">
                    {{ data.day_of_week }}
                  </span>
                  <span class="EventsSnippet-eventHour EventsSnippet-lineSecondItem">
                    {{ data.start_hour }}
                  </span>
                  <span class="EventsSnippet-eventPrice EventsSnippet-lineSecondItem {{ data.price.highlight }}">
                    {{ data.price.value }}
                  </span>
                  <span v-if="data.rating" class="EventsSnippet-eventRating EventsSnippet-lineSecondItem">
                    <span class="Event-infosRatingStar glyphicon glyphicon-star"></span>
                    {{ data.rating }}
                  </span>
                </div>
              </li>
            </ul>

          </div>
          <div class="EventsSnippet-seeAllEvents">
            <a href="{{ data.link }}" data-push="true" v-on:click="saveScroll">
              ver todos os {{ data.count }} eventos
            </a>
          </div>
        </div>
      </div>

    </div>



  </section>

</template>

<script>


var Vue = require('vue');
var Item = require('./item.vue');
Vue.use(require('vue-resource'));

export default{

  components: {
    'item': Item
  },

  data(){
    return {
      timeouts: [],
      base_url: window.location.origin
    }
  },

  props: {
    data: {
      default: {},
      type: Object
    }
  },

  ready: function(){
    var _self = this;

    var bLazy;
    setTimeout(function () {
      blazy(revalidate);
    }, 600);

    blazy = function(callback){
      bLazy = new Blazy('');
      callback();
    };

    revalidate = function(){
      setTimeout(function () {
        bLazy.revalidate();
      }, 3000);
    };

  },

  methods: {
    addTimer(){
      this.timeouts.push('timer')
    },

    removeTimer(){
      this.timeouts.pop()
    },

    login(){
      Villeme.Ux.loginModal("Você precisa estar logado para criar um evento.");
    },

    saveScroll(){
      window.Villeme.tempScroll = $(window).scrollTop();
    }
  }
}

</script>
