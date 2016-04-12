var Vue = require('vue');
var Newsfeed = require('./newsfeed.vue');
var SidebarLeft = require('./sidebar-left.vue');
var ItemsSection = require('./items-section.vue');
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
        newsfeed: Newsfeed,
        itemsSection: ItemsSection,
        item: Item,
        sidebarMap: SidebarMap
    }
});
