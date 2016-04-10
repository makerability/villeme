<style>

</style>

<template>
  <items-section :data="data.today"></items-section>
  <items-section :data="data.fun"></items-section>
</template>

<script>
var Vue = require('vue');
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
    'setCounter': function(){
      this.timeouts = this.timeouts === undefined ? [] : this.timeouts;
    },

    'stopCounting': function(){
      i = 0;
      while (i < this.timeouts.length) {
        clearTimeout(this.timeouts[i]);
        i++;
      }
    }
  },

  ready: function(){
    var _self = this;

    Vue.http({url: '/pt-BR/api/v1/sections/rio-de-janeiro/items.json', method: 'GET'}).then(function (response) {
      _self.$set('data', response.data);
      console.log(response.data);
    }, function (response) {
      alert("Ops");
    });
  },

  methods: {

  }

}
</script>
