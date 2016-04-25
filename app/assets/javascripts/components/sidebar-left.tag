<sidebar-left>

  <div id="SidebarLeft" class="SidebarLeft js-FixSidebarOnScroll">

    <section class="SidebarLeft-section">
      <ul class="SidebarLeft-nav">
        <li class="SidebarLeft-agendaLink js-SidebarLeft-agendaLink">
          <a href="{ link }" onclick="{ login }" data-push="{ data_push }">
            Minha agenda
          </a>
          <span if={ opts.current_user.items_agenda > 0 } class="js-agendaCounter badge is-show">
            { count }
          </span>
        </li>
      </ul>
    </section>

    <section class="SidebarLeft-section">
      <ul class="SidebarLeft-nav js-SidebarLeft-nav">
        <li if={ opts.today > 0 } onmouseenter={ navEnter } onmouseleave={ navLeave }>
          <a href="#" data-scroll="today">Eventos hoje</a>
          <span class="badge {is-show: is_hover}">{ opts.today }</span>
        </li>
        <li if={ opts.activities_today > 0 } onmouseenter={ navEnter } onmouseleave={ navLeave }>
          <a href="#" data-scroll="activities-today">Atividades hoje</a>
          <span class="badge {is-show: is_hover}">{ opts.activities_today }</span>
        </li>
        <li if={ opts.persona > 0 } onmouseenter={ navEnter } onmouseleave={ navLeave }>
          <a href="#" data-scroll="persona">Indicados p/ mim</a>
          <span class="badge {is-show: is_hover}">{ opts.persona }</span>
        </li>
        <li if={ opts.neighborhood > 0 } onmouseenter={ navEnter } onmouseleave={ navLeave }>
          <a href="#" data-scroll="neighborhood">No meu bairro</a>
          <span class="badge {is-show: is_hover}">{ opts.neighborhood }</span>
        </li>
        <li if={ opts.fun > 0 } onmouseenter={ navEnter } onmouseleave={ navLeave }>
          <a href="#" data-scroll="fun">Para se divertir</a>
          <span class="badge {is-show: is_hover}">{ opts.fun }</span>
        </li>
        <li if={ opts.education > 0 } onmouseenter={ navEnter } onmouseleave={ navLeave }>
          <a href="#" data-scroll="learn">Aprender algo novo</a>
          <span class="badge {is-show: is_hover}">{ opts.education }</span>
        </li>
        <li if={ opts.health > 0 } onmouseenter={ navEnter } onmouseleave={ navLeave }>
          <a href="#" data-scroll="health">Cuidar da saude</a>
          <span class="badge {is-show: is_hover}">{ opts.health }</span>
        </li>
        <li if={ opts.trends > 0 } onmouseenter={ navEnter } onmouseleave={ navLeave }>
          <a href="#" data-scroll="trends">Em alta</a>
          <span class="badge {is-show: is_hover}">{ opts.trends }</span>
        </li>
      </ul>
    </section>
  </div>

  <style scoped>
    @media (max-width:1200px) {
      :scope{
        display: none;
      }
    }

  </style>


  <script>

    window.Villeme = Villeme || {};
    Villeme.Observer = Villeme.Observer || riot.observable();

    var self = this;

    initialize(){
      this.count = opts.current_user.items_agenda;
      this.setAgendaLink();
    }

    setAgendaLink(){
      if (!opts.current_user.is_guest) {
        this.link = 'user/' + opts.current_user.username + '/agenda/';
        this.data_push = true;
        console.log('ok');
      } else {
        this.link = '#';
        this.data_push = false;
      }
    }

    login(){
      if(!opts.current_user.is_guest){
        false
      }else{
        Villeme.Ux.loginModal("Você precisa estar logado para ver sua agenda.");
      }
    }

    navEnter(event){
      $(event.target).find('.badge').addClass('is-show');
    }

    navLeave(event){
      $(event.target).find('.badge').removeClass('is-show');
    }

    updateCount(number){
      this.count = number;
    }

    this.on('mount', function() {
      this.initialize();

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

      self.update();
    });


    Villeme.Observer.on('itemSchedule', function(data){
      self.updateCount(data);
      self.update();
    });

  </script>


</sidebar-left>