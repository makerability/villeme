<style>

</style>

<template>
  <items-section :data="data.today"></items-section>
  <items-section :data="data.persona"></items-section>
  <items-section :data="data.neighborhood"></items-section>
  <items-section :data="data.fun"></items-section>
  <items-section :data="data.education"></items-section>
  <items-section :data="data.health"></items-section>
</template>

<script>
var Vue = require('vue');
import store from './vuex/store'
var ItemsSection = require('./items-section.vue');
Vue.use(require('vue-resource'));


export default{
  components: {
    'items-section': ItemsSection
  },

  data(){
    return {
      data: {},
      timeouts: []
    }
  },

  events: {

  },

  ready: function(){
    var _self = this;

    Vue.http({url: '/pt-BR/api/v1/sections/rio-de-janeiro/items.json', method: 'GET'}).then(function (response) {
      var data = response.data;
      _self.setData(data);
      _self.setCurrentUser(data.currentUser);
    }, function (data) {
      alert("Error")
    });
  },

  methods: {
    setCurrentUser: function(user){
      store.dispatch('updateCurrentUser', user)
    },

    setData: function(data){
      this.$set('data', data)
    }
  }

}
</script>
