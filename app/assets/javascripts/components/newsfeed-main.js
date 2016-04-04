var Vue = require('vue');
var SidebarLeft = require('./sidebar-left.vue');

new Vue({
    http: {
        root: '/root',
        headers: {
            Authorization: 'Basic YXBpOnBhc3N3b3Jk'
        }
    },
    el: 'body',
    components: {
        sidebarLeft: SidebarLeft
    }
});


