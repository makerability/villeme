var Vue = require('vue')
var SidebarLeft = require('./sidebar-left.vue')

new Vue({
    el: 'body',
    components: {
        app: SidebarLeft
    }
})