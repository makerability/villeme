<style lang="sass">

@import 'app/assets/stylesheets/_variables.scss';

.SidebarLeft {
  padding-top: 25px;
  position: relative;

  &-section{
    padding: 0 0 25px 0;
  }

  &-agendaLink{
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 25px;
    transition: all 0.4s ease 0s;

    &.is-adding{
      position: relative;
      background: scale_color($green, $lightness: 60%);
      border-color: scale_color($green, $lightness: 40%);
    }

    &.is-removing{
      position: relative;
      background: rgba(0, 0, 0, 0.1);
    }
  }

  &-nav{
    padding: 0;
    margin: 0;
    list-style: none;

    & li{
      color: $grey;
      font-family: $font-family-default;
      font-weight: 400;
      font-size: 14px;
      padding: 8px 2px 4px 0;

      & .badge{
        background: transparent none repeat scroll 0 0;
        color: #a8b3b2;
        display: none;
        font-family: Helvetica, arial, sans-serif;
        font-size: 10px;
        margin-left: 8px;
        min-width: 17px;
        padding: 4px 4.5px;
        position: relative;
        right: 5px;
        top: -2px;
        vertical-align: inherit;

        &.is-show{
          display: inline-block;
        }
      }

      & .active{
        color: $white;
        background: $blue;
      }

      & a{
        padding: 0 10px;
        color: scale_color($grey, $lightness: 20%);
        margin: 0;
        width: 170px;

        &:hover{
          cursor: pointer;
        }

        &.is-active{
          color: $green;
          font-size: 16px;
          font-weight: 600;
          transition: all 0.2s ease 0s;
        }

        & .glyphicon{
          margin: 0 6px 0 0;
        }
      }

      &.active{

        & a{
          background: none;
          color: $green;
          margin-right: -1px;
          font-weight: 500;

          & .badge{
            background: $body-bg-color;
            color: $green;
            border: 1px solid $green;
            font-family: Helvetica,arial;
            font-size: 9px;
          }
        }
      }

      & .glyphicon{
        font-size: 12px;
        margin: 0 8px 0 0;
      }
    }

  }


  & ul > li{
    display: table;
    height: 32px;
  }

  & ul > li > a:hover{
    background: transparent;
  }

  ul .sub-nav {
    margin: 0 0 0 20px;
  }

  li.divider {
    border-top: 1px solid scale_color($body-bg-color, $lightness: -5%);
    height: 0;
    margin: 3px 0;
    min-height: 0;
  }

  &--fixed{
    width: 200px;
    height: 100%;
    position: fixed;
    left: 0;
    top: 0;
    background: $grey;
    z-index: 110;
    padding: 25px 0 0 12px;
  }
}

@media (max-width:1200px) {
  :scope{
    display: none;
  }
}

</style>

<template>

  <div id="SidebarLeft" class="SidebarLeft js-FixSidebarOnScroll">

    <section class="SidebarLeft-section">
      <ul class="SidebarLeft-nav">
        <li class="SidebarLeft-agendaLink js-SidebarLeft-agendaLink">
          <a href="{{ link }}" v-on:click="login" data-push="{{ data_push }}">
            Minha agenda
          </a>
          <span v-if="data.currentUser.agenda.count > 0" class="js-agendaCounter badge is-show">
            {{ counter }}
          </span>
        </li>
      </ul>
    </section>

    <section class="SidebarLeft-section">
      <ul class="SidebarLeft-nav js-SidebarLeft-nav">
        <li v-if="data.today.count > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="today">Eventos hoje</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ data.today.count }}</span>
        </li>
        <li v-if="data.activities_today.count > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="activities-today">Atividades hoje</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ data.activities_today.count }}</span>
        </li>
        <li v-if="data.persona.count > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="persona">Indicados p/ mim</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ data.persona.count }}</span>
        </li>
        <li v-if="data.neighborhood.count > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="neighborhood">No meu bairro</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ data.neighborhood.count }}</span>
        </li>
        <li v-if="data.fun.count > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="fun">Para se divertir</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ data.fun.count }}</span>
        </li>
        <li v-if="data.education.count > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="learn">Aprender algo novo</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ data.education.count }}</span>
        </li>
        <li v-if="data.health.count > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="health">Cuidar da saude</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ data.health.count }}</span>
        </li>
        <li v-if="data.trends.count > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="trends">Em alta</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ data.trends.count }}</span>
        </li>
      </ul>
    </section>
  </div>

</template>


<script>

var Vue = require('vue');
Vue.use(require('vue-resource'));
import store from './vuex/store'

export default{
  data(){
    return {
      data: {
        today: {
          count: 0
        },
        persona: {
          count: 0
        },
        trends: {
          count: 0
        },
        fun: {
          count: 0
        },
        education: {
          count: 0
        },
        neighborhood: {
          count: 0
        },
        health: {
          count: 0
        },
        currentUser: {
          agenda: {
            count: 0
          }
        },
        activities_today: {
          count: 0
        }
      },
      counter: 0,
      link: ''
    }
  },

  props: {
    city: {
      type: String
    }
  },

  ready: function(){
    var _self = this;

    Vue.http({url: '/pt-BR/api/v1/sections/items/' + this.city + '.json', method: 'GET'}).then(function (response) {
      _self.$set('data', response.data);
      _self.$set('link', 'user/' + response.data.currentUser.username + '/agenda/');
      store.dispatch('updateAgendaCounter', response.data.currentUser.agenda.count);
    }, function (response) {
      alert("Ops");
    });
  },

  methods: {
    setAgendaLink: function(){
      if (!currentUser.isGuest) {
        this.link = 'user/' + this.data.currentUser.username + '/agenda/';
        this.data_push = true;
        console.log('ok');
      } else {
        this.link = '#';
        this.data_push = false;
      }
    },

    login: function(){
      if(!data.currentUser.isGuest){
        false
      }else{
        Villeme.Ux.loginModal("Você precisa estar logado para ver sua agenda.");
      }
    },

    navEnter: function(event){
      $(event.target).find('.badge').addClass('is-show');
    },

    navLeave: function(event){
      $(event.target).find('.badge').removeClass('is-show');
    },

    updateCount: function(number){
      this.counter = number;
    },

    configure: function() {
      $('.js-SidebarLeft-nav a').on('click', function() {
        var scrollAnchor, scrollPoint;
        scrollAnchor = $(this).attr('data-scroll');
        scrollPoint = $('section[data-anchor="' + scrollAnchor + '"]').offset().top - 85;
        $('body,html').animate({
          scrollTop: scrollPoint
        }, 500);
        return false;
      });
      $(window).scroll(function() {
        var windscroll;
        windscroll = $(window).scrollTop();
        if (windscroll >= 110) {
          $('.Main section').each(function(i) {
            if ($(this).position().top <= windscroll + 86) {
              $('.js-SidebarLeft-nav a.is-active').removeClass('is-active');
              $('.js-SidebarLeft-nav a').eq(i).addClass('is-active');
            }
          });
        } else {
          $('.js-SidebarLeft-nav a.is-active').removeClass('is-active');
          $('.js-SidebarLeft-nav a:first').addClass('is-active');
        }
      }).scroll();

    }
  },

  computed: {
    counter: function(){
      return store.state.agendaCounter
    }
  }
}

</script>
