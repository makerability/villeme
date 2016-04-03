<style scoped>
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
          <a href="{ link }" v-on:click="login" data-push="{{ data_push }}">
            Minha agenda
          </a>
          <span v-if="current_user.agenda.count > 0" class="js-agendaCounter badge is-show">
            {{ count }}
          </span>
        </li>
      </ul>
    </section>

    <section class="SidebarLeft-section">
      <ul class="SidebarLeft-nav js-SidebarLeft-nav">
        <li v-if="opts.today > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="today">Eventos hoje</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ today }}</span>
        </li>
        <li v-if="activities_today > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="activities-today">Atividades hoje</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ activities_today }}</span>
        </li>
        <li v-if="persona > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="persona">Indicados p/ mim</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ persona }}</span>
        </li>
        <li v-if="neighborhood > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="neighborhood">No meu bairro</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ neighborhood }}</span>
        </li>
        <li v-if="fun > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="fun">Para se divertir</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ fun }}</span>
        </li>
        <li v-if="education > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="learn">Aprender algo novo</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ education }}</span>
        </li>
        <li v-if="health > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="health">Cuidar da saude</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ health }}</span>
        </li>
        <li v-if="opts.trends > 0" v-on:mouseenter="navEnter" v-on:mouseleave="navLeave">
          <a href="#" data-scroll="trends">Em alta</a>
          <span class="badge" v-bind:class="{ 'is-show': is_hover }">{{ opts.trends }}</span>
        </li>
      </ul>
    </section>
  </div>

</template>


<script>

  export default {
    data: function(){
      return {
        count: current_user.agenda.count
      }
    },

    created: function(){
      setAgendaLink();
      configure();
    },

    methods: {

      setAgendaLink: function(){
        if (!opts.current_user.is_guest) {
          this.link = 'user/' + opts.current_user.username + '/agenda/';
          this.data_push = true;
          console.log('ok');
        } else {
          this.link = '#';
          this.data_push = false;
        }
      },

      login: function(){
        if(!opts.current_user.is_guest){
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
        this.count = number;
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

    }
  }

  </script>


