<sidebar-left>

  <div id="SidebarLeft" class="SidebarLeft">

    <section class="SidebarLeft-section">
      <ul>
        <li>
          <a href="{ link }" onclick="{ login }" data-push="{ data_push }">
            Minha agenda
            <span if={ opts.current_user.agenda_items > 0 } class="js-agendaCounter badge">{ opts.current_user.agenda_items }</span>
          </a>
        </li>
      </ul>
    </section>

    <section class="SidebarLeft-section">
      <ul class="SidebarLeft-nav">
        <li if={ opts.today > 0 }>
          <a href="#" data-scroll="today">Eventos hoje</a>
        </li>
        <li if={ opts.activities_today > 0 }>
          <a href="#" data-scroll="activities-today">Atividades hoje</a>
        </li>
        <li if={ opts.persona > 0 }>
          <a href="#" data-scroll="persona">Indicados p/ mim</a>
        </li>
        <li if={ opts.neighborhood > 0 }>
          <a href="#" data-scroll="neighborhood">No meu bairro</a>
        </li>
        <li if={ opts.fun > 0 }>
          <a href="#" data-scroll="fun">Para se divertir</a>
        </li>
        <li if={ opts.education > 0 }>
          <a href="#" data-scroll="learn">Aprender algo novo</a>
        </li>
        <li if={ opts.health > 0 }>
          <a href="#" data-scroll="health">Cuidar da saude</a>
        </li>
        <li if={ opts.trends > 0 }>
          <a href="#" data-scroll="trends">Em alta</a>
        </li>
      </ul>
    </section>
  </div>


  <script>

    if (!opts.current_user.is_guest) {
      this.link = 'user/' + opts.current_user.username + '/agenda/';
      this.data_push = true;
    } else {
      this.link = '#';
      this.data_push = false;
    }


    login(){
      if(!opts.current_user.is_guest){
        false
      }else{
        Villeme.Ux.loginModal("Você precisa estar logado para ver sua agenda.");
      }
    }
  </script>


</sidebar-left>