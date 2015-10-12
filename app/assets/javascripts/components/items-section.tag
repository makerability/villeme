<items-section>

  <section if={ opts.data.count > 0 } class="Section" data-anchor="{ opts.data.type }">

    <div class="Section-header">
      <h1 class="Section-title">{ opts.data.title }</h1>
      <span class="Section-description"></span>
    </div>

    <div class="Grid Grid--withGutter">

      <item each={ opts.data.items } class="Event Event--newsFeed grid Grid-cell u-size4of12 u-lg-size4of12 u-md-size6of12"></item>

      <div if={opts.data.count <= 2} class="Grid-cell u-size4of12 u-lg-size4of12 u-md-sizeFull u-centralize">
        <div class="AlertCreateEvent AlertCreateEvent--withBorder">
          <div class="AlertCreateEvent-text u-posAbsoluteCenter">
            <span>
              Não há mais eventos no momento.<br/>
              <a href="{ opts.policies.is_guest_user ? '#' : opts.data.link_to_create }" onclick={ opts.policies.is_guest_user ? login : false }>Cria evento</a>
            </span>
          </div>
        </div>
      </div>




      <div if={ opts.data.count >= 3 } class="EventsSnippet Grid-cell u-size4of12 u-lg-size4of12 u-md-sizeFull">
        <div class="EventsSnippet-content">
          <div class="EventsSnippet-scroll">
            <ul class="EventsSnippet-lineGroup">
              <li each={ opts.data.snippet } onclick={ saveScroll } class="EventsSnippet-line js-EventNewsfeedTransitions">
                <a href="{ base_url + link }" data-push="true">
                  <div class="EventsSnippet-image b-lazy" data-src="{ image.thumb }"></div>
                </a>
                <div class="EventsSnippet-linePrincipal u-sizeFull">
                  <span class="EventsSnippet-eventName">
                    <a href="{ base_url + link }" data-push="true">{ name }</a>
                  </span>
                </div>
                <div class="EventsSnippet-lineSecond">
                  <span class="EventsSnippet-eventDay EventsSnippet-lineSecondItem">
                     { day_of_week }
                  </span>
                  <span class="EventsSnippet-eventHour EventsSnippet-lineSecondItem">
                    { start_hour }
                  </span>
                  <span class="EventsSnippet-eventPrice EventsSnippet-lineSecondItem { price.highlight }">
                      { price.value }
                  </span>
                  <span if={ rating } class="EventsSnippet-eventRating EventsSnippet-lineSecondItem">
                    <span class="Event-infosRatingStar glyphicon glyphicon-star"></span>
                     { rating }
                  </span>
                </div>
              </li>
            </ul>

          </div>
          <div class="EventsSnippet-seeAllEvents">
            <a href="{ opts.data.link }" data-push="true" onclick={ saveScroll }>
              ver todos os { opts.data.count } eventos
            </a>
          </div>
        </div>
      </div>

    </div>



  </section>


  <script>

    this.base_url = window.location.origin;

    this.on('mount', function(){
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
      }
    });

    this.timeouts = [];

    addTimer(){
      this.timeouts.push('timer')
    }

    removeTimer(){
      this.timeouts.pop()
    }

    login(){
      Villeme.Ux.loginModal("Você precisa estar logado para criar um evento.");
    }

    saveScroll(){
      window.Villeme.tempScroll = $(window).scrollTop();
    }

  </script>

</items-section>
