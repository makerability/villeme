var Vue = require('vue');
var Vuex = require('vuex');

Vue.use(Vuex)

var store = new Vuex.Store({
  state: {
    agendaCounter: 0
  },
  mutations: {
    updateAgendaCounter (state, mutation){
      state.agendaCounter = mutation
    }
  }
})

module.exports = store;
