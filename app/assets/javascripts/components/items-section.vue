// out: .

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
              <a href="{{ data.policies.isGuestUser ? '#' : data.link_to_create }}" v-on:click={{ data.policies.isGuestUser ? login : false }}>Cria evento</a>
            </span>
          </div>
        </div>
      </div>

      <div v-if="data.snippet.length > 0" v-show="data.snippet != null" class="EventsSnippet Grid-cell u-size4of12 u-lg-size4of12 u-md-sizeFull">
        <div class="EventsSnippet-content">
          <div class="EventsSnippet-scroll">
            <ul class="EventsSnippet-lineGroup">
              <li v-for="item in data.snippet" v-on:click="saveScroll" class="EventsSnippet-line js-EventNewsfeedTransitions">
                <a href="{{ base_url + link }}" data-push="true">
                  <div class="EventsSnippet-image b-lazy" data-src="{{ item.image.thumb }}"></div>
                </a>
                <div class="EventsSnippet-linePrincipal u-sizeFull">
                  <span class="EventsSnippet-eventName">
                    <a href="{{ base_url + link }}" data-push="true">{{ item.name }}</a>
                  </span>
                </div>
                <div class="EventsSnippet-lineSecond">
                  <span class="EventsSnippet-eventDay EventsSnippet-lineSecondItem">
                    {{ item.day_of_week }}
                  </span>
                  <span class="EventsSnippet-eventHour EventsSnippet-lineSecondItem">
                    {{ item.start_hour }}
                  </span>
                  <span class="EventsSnippet-eventPrice EventsSnippet-lineSecondItem">
                    {{ item.price.currency }}  {{ item.price.value }}
                  </span>
                  <span v-if="data.rating" class="EventsSnippet-eventRating EventsSnippet-lineSecondItem">
                    <span class="Event-infosRatingStar glyphicon glyphicon-star"></span>
                    {{ item.rating }}
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
import store from './vuex/store';
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
    api: {
      type: Boolean,
      default: true
    },
    data: {
      type: Object,
      default: function(){
        return {count: 0}
      }
    },
    resource: {
      default: 'items',
      type: String
    },
    city: {
      type: String
    },
    params: {
      type: String
    }
  },

  ready: function(){
    this.fetchData();
    this.loadImages();
  },

  computed: {
    getParams: function(){
      if(this.params != undefined){
        return '?' + this.params
      }else{
        return ''
      }
    },

    getResource: function(){
      if(this.resource == ''){
        return 'items'
      }else{
        return this.resource
      }
    }
  },

  methods: {

    fetchData: function(){
      if(this.api == true){
        var _self = this;

        Vue.http({url: '/pt-BR/api/v1/sections/' + _self.getResource + '/' + _self.city + _self.getParams, method: 'GET'}).then(function (response) {
          var data = response.data;
          _self.setData(data);
          _self.setCurrentUser(data.currentUser);
        }, function (data) {
          alert("Error")
        });
      }
    },

    loadImages: function(){
      var blazy;

      setTimeout(function () {
        loadBlazy(revalidate);
      }, 1200);

      var loadBlazy = function(callback){
        blazy = new Blazy('');
        callback();
      };

      var revalidate = function(){
        setTimeout(function () {
          blazy.revalidate();
        }, 3000);
      };
    },

    setCurrentUser: function(user){
      store.dispatch('updateCurrentUser', user)
    },

    setData: function(data){
      this.$set('data', data)
    },

    login: function(){
      Villeme.Ux.loginModal("Você precisa estar logado para criar um evento.");
    },

    saveScroll: function(){
      window.Villeme.tempScroll = $(window).scrollTop();
    }
  }
}

</script>
