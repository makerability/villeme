<template>

  <div class="SidebarMapBox" class="ps-container">

    <div class="SidebarMap js-FixMapOnScroll panel panel-default">
      <div class="panel-body user-box sidebar u-no-padding">
        <div id="map" style="width:100%"></div>
      </div>


      <div v-show={{ opts.currentUser.isGuest }} class="panel-body u-centralize">
        <%= link_to_function 'Você precisa estar logado para ver sua localização e o tempo de transporte até o local.', 'Villeme.Ux.loginModal("Para ver o tempo ate o local você precisa estar logado.")' %>
      </div>

      <div v-hide="currentUser.isGuest">
        <div v-show="isNeighborhoodCountShow" class="SidebarMap-neighborhoodCount panel-body">
          <ul class="list-group u-margin-0 font-12">
            <li class="list-item-group">{{ currentUser.firstName }}, você possui </li>
          </ul>
        </div>

        <div v-show="isAddressShow" class="SidebarMap-address">
          <span><b>{{ data.place.name }}</b><br/>{{ data.full_address }}</span>
        </div>

        <ul v-show="isInfoGroupShow" class="SidebarMap-infoGroup">
          <li class="SidebarMap-infoList u-lg-size6of12">
            <span class="SidebarMap-icon" v-bind:class="{ 'isBold': isWalkFriendly }" title="Indo caminhando"><span> {{ data.distance.walk }} </span> caminhando</span>
          </li>
          <li class="SidebarMap-infoList u-lg-size6of12">
            <span class="SidebarMap-icon" title="Indo de bicicleta"><span> {{ data.distance.bike }} </span> pedalando</span>
          </li>
          <li class="SidebarMap-infoList u-lg-size6of12">
            <span class="SidebarMap-icon" title="Indo de ônibus"><span> {{ data.distance.bus }} </span> de ônibus</span>
          </li>
          <li class="SidebarMap-infoList u-lg-size6of12">
            <span class="SidebarMap-icon" title="Indo de carro"><span> {{ data.distance.car }} </span> dirigindo</span>
          </li>
        </ul>
      </div>

    </div>
  </div>
</template>

<style>
.isBold{
  font-weight: bold;
}
</style>

<script>

var Vue = require('vue');
Vue.use(require('vue-resource'));
import store from './vuex/store'

export default{
  data(){
    return {

    }
  },

  ready: function(){

  },

  computed: {
    data: function(){
      return store.state.dataItemOver
    },

    currentUser: function(){
      return store.state.currentUser
    },

    isWalkFriendly: function(){
      var time = this.data.distance.walk.replace('min.', '');
      if(parseInt(time) < 30){
        return true
      }else{
        return false
      }
    },

    isNeighborhoodCountShow: function(){
      if(store.state.isItemOver){
        return false
      }else{
        return true
      }
    },

    isInfoGroupShow: function(){
      if(store.state.isItemOver){
        return true
      }else{
        return false
      }
    },

    isAddressShow: function(){
      if(store.state.isItemOver){
        return true
      }else{
        return false
      }
    }
  },

  events: {
    itemMouseOver: function(data){
      this.updateMap(data);
      this.showInfoGroup();
      this.showAddress();
      this.hideNeighborhoodCount();
    },

    itemMouseLeave: function(data){
      this.hideInfoGroup();
      this.hideAddress();
    }
  },

  methods: {

    updateMap: function(data){
      $('#map').gmap3("get");
      google.maps.event.trigger(map, "resize");
      Gmaps.panTo(data.latitude, data.longitude);
    }

  }

}


</script>
