<sidebar-map>

<div class="SidebarMapBox" class="ps-container">

  <div class="SidebarMap js-FixMapOnScroll panel panel-default">
    <div class="panel-body user-box sidebar u-no-padding">
      <div id="map" style="width:100%"></div>
    </div>


    <div show={ opts.current_user.is_guest } class="panel-body u-centralize">
      <%= link_to_function 'Você precisa estar logado para ver sua localização e o tempo de transporte até o local.', 'Villeme.Ux.loginModal("Para ver o tempo ate o local você precisa estar logado.")' %>
    </div>

    <div hide={ opts.current_user.is_guest }>
      <div show={ neighborhoodCountIsShow } class="SidebarMap-neighborhoodCount panel-body">
        <ul class="list-group u-margin-0 font-12">
          <li class="list-item-group"> Você possui </li>
        </ul>
      </div>

      <div show={ addressIsShow } class="SidebarMap-address">
        <span><b> { place } </b><br/> { address } </span>
      </div>

      <ul show={ infoGroupIsShow } class="SidebarMap-infoGroup">
        <li class="SidebarMap-infoList u-lg-size6of12">
          <span class="SidebarMap-icon { isBold: isWalkFriendly }" title="Indo caminhando"><span> { walk } </span> caminhando</span>
        </li>
        <li class="SidebarMap-infoList u-lg-size6of12">
          <span class="SidebarMap-icon" title="Indo de bicicleta"><span> { bike } </span> pedalando</span>
        </li>
        <li class="SidebarMap-infoList u-lg-size6of12">
          <span class="SidebarMap-icon" title="Indo de ônibus"><span> { bus } </span> de ônibus</span>
        </li>
        <li class="SidebarMap-infoList u-lg-size6of12">
          <span class="SidebarMap-icon" title="Indo de carro"><span> { car } </span> dirigindo</span>
        </li>
      </ul>
    </div>

  </div>
</div>

<style scoped>
  .isBold{
    font-weight: bold;
  }
</style>

<script>

  window.Villeme = Villeme || {};
  Villeme.Observer = Villeme.Observer || riot.observable();

  var self = this;

  initialize(){
    this.neighborhoodCountIsShow = false;
    self.infoGroupIsShow = false;
    self.addressIsShow = false;
    self.update();
  }

  updateDistance(data){
    self.walk = data.distance.walk;
    self.bike = data.distance.bike;
    self.bus = data.distance.bus;
    self.car = data.distance.car;
    self.isWalkFriendly(data.distance.walk);
  }

  isWalkFriendly(time){
    var _time = time.replace('min.', '');
    if(parseInt(_time) < 30){
      return true;
    }else{
      return false;
    }
  }

  updateMap(data){
    $('#map').gmap3("get");
    google.maps.event.trigger(map, "resize");
    Gmaps.panTo(data.latitude, data.longitude);
  }

  updateAddress(data){
    self.address = data.full_address
    self.place = data.place.name
  }

  showNeighborhoodCount(){
    self.neighborhoodCountIsShow = true;
  }

  hideNeighborhoodCount(){
    self.neighborhoodCountIsShow = false;
  }

  showInfoGroup(){
    self.infoGroupIsShow = true;
  }

  hideInfoGroup(){
    self.infoGroupIsShow = false;
  }

  showAddress(){
    self.addressIsShow = true;
  }

  hideAddress(){
    self.addressIsShow = false;
  }

  Villeme.Observer.on('itemMouseOver', function(data){
    self.updateDistance(data);
    self.updateMap(data);
    self.updateAddress(data);
    self.showInfoGroup();
    self.showAddress();
    self.hideNeighborhoodCount();
    self.update();
  });

  Villeme.Observer.on('itemMouseLeave', function(data){
    self.hideInfoGroup();
    self.hideAddress();
    // self.showNeighborhoodCount();
    self.update();
  });

  self.on('mount', function(){
    self.initialize();
  })

</script>

</sidebar-map>