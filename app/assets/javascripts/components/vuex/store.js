var Vue = require('vue');
var Vuex = require('vuex');

Vue.use(Vuex)

var store = new Vuex.Store({
  state: {
    currentUser: {},
    agendaCounter: 0,
    isItemOver: false,
    dataItemOver: {}
  },
  mutations: {
    updateCurrentUser: function(state, mutation){
      state.currentUser = mutation
    },

    updateAgendaCounter: function(state, mutation){
      state.agendaCounter = mutation
    },

    updateItemOver: function(state, mutation){
      state.isItemOver = mutation
    },

    updateDataItemOver: function(state, mutation){
      state.dataItemOver = mutation
    }
  }
})

module.exports = store;
