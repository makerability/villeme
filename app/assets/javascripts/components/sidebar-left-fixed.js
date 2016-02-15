riot.tag('sidebar-left-fixed', '<div class="SidebarLeft SidebarLeft--fixed js-showSidebarFixed"> <section class="SidebarLeft-section"> <ul class="SidebarLeft-nav js-SidebarLeft-nav"> <li> <a href="{ link }" onclick="{ login }" data-push="{ data_push }"> Minha agenda </a> <span if="{ opts.current_user.agenda_items > 0 }" class="js-agendaCounter badge is-show"> { opts.current_user.agenda_items } </span> </li> <li if="{ opts.today > 0 }" onmouseenter="{ navEnter }" onmouseleave="{ navLeave }"> <a href="#" data-scroll="today">Eventos hoje</a> <span class="badge {is-show: is_hover}">{ opts.today }</span> </li> <li if="{ opts.activities_today > 0 }" onmouseenter="{ navEnter }" onmouseleave="{ navLeave }"> <a href="#" data-scroll="activities-today">Atividades hoje</a> <span class="badge {is-show: is_hover}">{ opts.activities_today }</span> </li> <li if="{ opts.persona > 0 }" onmouseenter="{ navEnter }" onmouseleave="{ navLeave }"> <a href="#" data-scroll="persona">Indicados p/ mim</a> <span class="badge {is-show: is_hover}">{ opts.persona }</span> </li> <li if="{ opts.neighborhood > 0 }" onmouseenter="{ navEnter }" onmouseleave="{ navLeave }"> <a href="#" data-scroll="neighborhood">No meu bairro</a> <span class="badge {is-show: is_hover}">{ opts.neighborhood }</span> </li> <li if="{ opts.fun > 0 }" onmouseenter="{ navEnter }" onmouseleave="{ navLeave }"> <a href="#" data-scroll="fun">Para se divertir</a> <span class="badge {is-show: is_hover}">{ opts.fun }</span> </li> <li if="{ opts.education > 0 }" onmouseenter="{ navEnter }" onmouseleave="{ navLeave }"> <a href="#" data-scroll="learn">Aprender algo novo</a> <span class="badge {is-show: is_hover}">{ opts.education }</span> </li> <li if="{ opts.health > 0 }" onmouseenter="{ navEnter }" onmouseleave="{ navLeave }"> <a href="#" data-scroll="health">Cuidar da saude</a> <span class="badge {is-show: is_hover}">{ opts.health }</span> </li> <li if="{ opts.trends > 0 }" onmouseenter="{ navEnter }" onmouseleave="{ navLeave }"> <a href="#" data-scroll="trends">Em alta</a> <span class="badge {is-show: is_hover}">{ opts.trends }</span> </li> </ul> </section> </div>', 'sidebar-left-fixed, [riot-tag="sidebar-left-fixed"]{ display: none; }', function(opts) {

    var sidebar = this;

    if (!opts.current_user.is_guest) {
      this.link = 'user/' + opts.current_user.username + '/agenda/';
      this.data_push = true;
    } else {
      this.link = '#';
      this.data_push = false;
    }

    this.login = function() {
      if(!opts.current_user.is_guest){
        false
      }else{
        Villeme.Ux.loginModal("Você precisa estar logado para ver sua agenda.");
      }
    }.bind(this);

    this.navEnter = function(event) {
      $(event.target).find('.badge').addClass('is-show');
    }.bind(this);

    this.navLeave = function(event) {
      $(event.target).find('.badge').removeClass('is-show');
    }.bind(this);

    this.show = function() {
      sidebar.root.style.display = 'block';
    }.bind(this);

    this.hide = function() {
      sidebar.root.style.display = 'none';
    }.bind(this);

    this.showOnClickSandwichButton = function() {
      var sandwichButton = document.querySelectorAll('.js-showSidebarLeftFixed')[0];
      sandwichButton.addEventListener('click', sidebar.show)
    }.bind(this);

    this.hideOnClickOutside = function() {
      var sandwichButton, sidebarLeftFixed;
      sandwichButton = document.querySelectorAll('.Navbar-sandwichButton')[0];
      sidebarLeftFixed = document.querySelectorAll('.SidebarLeft--fixed')[0];

      document.addEventListener('click', function(event){
      	if(event.target != sandwichButton && event.target != sidebarLeftFixed && !sidebarLeftFixed.contains(event.target)){
          sidebar.hide();
      	}
      });
    }.bind(this);

    this.scrollAnimate = function() {
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
    }.bind(this);

    this.on('mount', function() {
      sidebar.scrollAnimate();
      sidebar.hideOnClickOutside();
      sidebar.showOnClickSandwichButton();
      sidebar.update();
    });


  
});