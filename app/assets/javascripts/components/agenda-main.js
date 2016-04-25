var Vue = require('vue');
var SidebarLeft = require('./sidebar-left.vue');
var Agenda = require('./agenda.vue');
var Item = require('./item.vue');
var SidebarMap = require('./sidebar-map.vue');

new Vue({
    http: {
        root: '/root',
        headers: {
            Authorization: 'Basic YXBpOnBhc3N3b3Jk'
        }
    },
    el: 'body',
    components: {
        sidebarLeft: SidebarLeft,
        agenda: Agenda,
        item: Item,
        sidebarMap: SidebarMap
    }
});
