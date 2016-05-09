<style>

</style>

<template>
  <items-section :data="data.today" api="false"></items-section>
  <items-section :data="data.persona" api="false"></items-section>
  <items-section :data="data.activitiesToday" api="false"></items-section>
  <items-section :data="data.neighborhood" api="false"></items-section>
  <items-section :data="data.fun" api="false"></items-section>
  <items-section :data="data.education" api="false"></items-section>
  <items-section :data="data.health" api="false"></items-section>
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
      data: {}
    }
  },

  props: {
    city: {
      type: String
    }
  },

  ready: function(){
    var _self = this;

    Vue.http({url: '/pt-BR/api/v1/sections/items/' + _self.city + '.json', method: 'GET'}).then(function (response) {
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
