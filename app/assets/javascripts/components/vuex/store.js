var Vue = require('vue');
var Vuex = require('vuex');

Vue.use(Vuex)

var store = new Vuex.Store({
  state: {
    currentUser: {},
    agendaCounter: 0,
    isItemOver: false,
    dataItemOver: {},
    timeoutsItemOver: [],
    zoomMap: 13
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
    },

    updateTimeoutsItemOver: function(state, mutation){
      state.timeoutsItemOver = mutation
    },

    addTimeoutsItemOver: function(state, timer){
      state.timeoutsItemOver.push(timer)
    },

    stopCountingTimeoutsItemOver: function(state){
      i = 0;
      while (i < state.timeoutsItemOver.length) {
        clearTimeout(state.timeoutsItemOver[i]);
        i++;
      }
    },

    updateZoomMap: function(state, mutation){
        state.zoomMap = mutation
    }
  }
})

module.exports = store;
