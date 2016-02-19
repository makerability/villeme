riot.tag('sidebar-map', '<div class="SidebarMapBox" class="ps-container"> <div class="SidebarMap js-FixMapOnScroll panel panel-default"> <div class="panel-body user-box sidebar u-no-padding"> <div id="map" style="width:100%"></div> </div> <div show="{ opts.current_user.is_guest }" class="panel-body u-centralize"> <%= link_to_function \'Você precisa estar logado para ver sua localização e o tempo de transporte até o local.\', \'Villeme.Ux.loginModal("Para ver o tempo ate o local você precisa estar logado.")\' %> </div> <div hide="{ opts.current_user.is_guest }"> <div show="{ neighborhoodCountIsShow }" class="SidebarMap-neighborhoodCount panel-body"> <ul class="list-group u-margin-0 font-12"> <li class="list-item-group"> Você possui </li> </ul> </div> <div show="{ addressIsShow }" class="SidebarMap-address"> <span><b> { place } </b><br> { address } </span> </div> <ul show="{ infoGroupIsShow }" class="SidebarMap-infoGroup"> <li class="SidebarMap-infoList u-lg-size6of12"> <span class="SidebarMap-icon { isBold: isWalkFriendly }" title="Indo caminhando"><span> { walk } </span> caminhando</span> </li> <li class="SidebarMap-infoList u-lg-size6of12"> <span class="SidebarMap-icon" title="Indo de bicicleta"><span> { bike } </span> pedalando</span> </li> <li class="SidebarMap-infoList u-lg-size6of12"> <span class="SidebarMap-icon" title="Indo de ônibus"><span> { bus } </span> de ônibus</span> </li> <li class="SidebarMap-infoList u-lg-size6of12"> <span class="SidebarMap-icon" title="Indo de carro"><span> { car } </span> dirigindo</span> </li> </ul> </div> </div> </div>', 'sidebar-map .isBold, [riot-tag="sidebar-map"] .isBold{ font-weight: bold; }', function(opts) {

  window.Villeme = Villeme || {};
  Villeme.Observer = Villeme.Observer || riot.observable();

  var self = this;

  this.initialize = function() {
    this.neighborhoodCountIsShow = false;
    self.infoGroupIsShow = false;
    self.addressIsShow = false;
    self.update();
  }.bind(this);

  this.updateDistance = function(data) {
    self.walk = data.distance.walk;
    self.bike = data.distance.bike;
    self.bus = data.distance.bus;
    self.car = data.distance.car;
    self.isWalkFriendly(data.distance.walk);
  }.bind(this);

  this.isWalkFriendly = function(time) {
    var _time = time.replace('min.', '');
    if(parseInt(_time) < 30){
      return true;
    }else{
      return false;
    }
  }.bind(this);

  this.updateMap = function(data) {
    $('#map').gmap3("get");
    google.maps.event.trigger(map, "resize");
    Gmaps.panTo(data.latitude, data.longitude);
  }.bind(this);

  this.updateAddress = function(data) {
    self.address = data.full_address
    self.place = data.place.name
  }.bind(this);

  this.showNeighborhoodCount = function() {
    self.neighborhoodCountIsShow = true;
  }.bind(this);

  this.hideNeighborhoodCount = function() {
    self.neighborhoodCountIsShow = false;
  }.bind(this);

  this.showInfoGroup = function() {
    self.infoGroupIsShow = true;
  }.bind(this);

  this.hideInfoGroup = function() {
    self.infoGroupIsShow = false;
  }.bind(this);

  this.showAddress = function() {
    self.addressIsShow = true;
  }.bind(this);

  this.hideAddress = function() {
    self.addressIsShow = false;
  }.bind(this);

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

    self.update();
  });

  self.on('mount', function(){
    self.initialize();
  })


});