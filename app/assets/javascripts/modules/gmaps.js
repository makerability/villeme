
var Gmaps = function Gmaps(latitude, longitude, markers) {
    if(latitude == undefined || longitude == undefined || markers == undefined){
        return console.log("Error: Gmaps module without params")
    }

    this.latitude = latitude;
    this.longitude = longitude;
    this.newMap(markers);
    this.init();
};
Gmaps.prototype.init = function() {
    Gmaps.buttonToGetLocation();
    Gmaps.inputToGetLocationOnKeyup();
};
Gmaps.prototype.newMap = function(markers) {
    var style;
    style = [
        {
            "featureType": "road",
            "elementType": "geometry",
            "stylers": [
                {
                    "lightness": 100
                }, {
                    "visibility": "simplified"
                }
            ]
        }, {
            "featureType": "water",
            "elementType": "geometry",
            "stylers": [
                {
                    "visibility": "on"
                }, {
                    "color": "#d6defa"
                }
            ]
        }, {
            "featureType": "poi.business",
            "stylers": [
                {
                    "visibility": "off"
                }
            ]
        }, {
            "featureType": "poi",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "color": "#dff5e6"
                }
            ]
        }, {
            "featureType": "road",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "color": "#D1D1B8"
                }
            ]
        }, {
            "featureType": "landscape",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "color": "#ffffff"
                }
            ]
        }
    ];
    Gmaps.showMapCanvasIfHidden();
    $("#map").gmap3({
        map: {
            options: {
                center: [this.latitude, this.longitude],
                zoom: 13,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                mapTypeControl: false,
                mapTypeControlOptions: {
                    style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
                },
                navigationControl: false,
                scrollwheel: true,
                streetViewControl: false,
                zoomControl: true,
                zoomControlOptions: {
                    style: google.maps.ZoomControlStyle.SMALL,
                    position: google.maps.ControlPosition.RIGHT_TOP
                },
                styles: style
            }
        },
        marker: {
            values: markers,
            options: {
                draggable: false
            },
            events: {
                dragend: function(marker) {
                    $(this).gmap3({
                        getaddress: {
                            latLng: marker.getPosition(),
                            callback: function(results) {
                                var content, infowindow, latLng, map;
                                map = $(this).gmap3("get");
                                infowindow = $(this).gmap3({
                                    get: "infowindow"
                                });
                                $.each(results[0].address_components, function(x, y) {
                                    $.each(this, function(name, value) {
                                        var address;
                                        if (value[0] === "route") {
                                            address = y.long_name;
                                            $("#event_address, #event_place_attributes_address, #address").val(address);
                                        } else if (value[0] === "street_number") {
                                            this.number = y.long_name;
                                            $("#number, #place-number").val(this.number);
                                        } else if (value[0] === "neighborhood") {
                                            this.neighborhood = y.long_name;
                                            $("#neighborhood, #neighborhood-place, #neighborhood-name").val(this.neighborhood);
                                        }
                                    });
                                });
                                content = (results && results[0] ? "Endereço encontrado!" : "Endereço não encontrado");
                                if (infowindow) {
                                    infowindow.open(map, marker);
                                    infowindow.setContent(content);
                                } else {
                                    $(this).gmap3({
                                        infowindow: {
                                            anchor: marker,
                                            options: {
                                                content: content
                                            }
                                        }
                                    });
                                }
                                map = $(this).gmap3("get");
                                google.maps.event.trigger(map, 'resize');
                                latLng = results[0].geometry.location;
                                map.panTo(latLng);
                            }
                        }
                    });
                }
            }
        }
    });
};
Gmaps.panTo = function(latitude, longitude) {
    var latLng, map;
    latLng = new google.maps.LatLng(latitude, longitude);
    map = $("#map").gmap3("get");
    map.panTo(latLng);
};
Gmaps.prototype.zoomTo = function(zoom) {
    var map;
    map = $("#map").gmap3("get");
    map.setZoom(zoom);
};
Gmaps.centerTo = function(latitude, longitude) {
    var latLng, map;
    latLng = new google.maps.LatLng(latitude, longitude);
    map = $("#map").gmap3("get");
    map.setCenter(latLng);
};
Gmaps.clearMarker = function() {
    $('#map').gmap3({
        clear: {
            name: "marker"
        }
    });
};
Gmaps.getLocationFromAddress = function(address) {
    $("#map").gmap3({
        clear: {
            name: "marker"
        },
        getlatlng: {
            address: address,
            callback: function(results) {
                var latLng, map;
                if (!results) {
                    $(".address-place-inputs").css("border-color", "#A94442");
                    alert("Endereço não encontrado. Tente buscar outro.");
                } else {
                    $(".address-place-inputs").css("border-color", "#5fcf80");
                    $(this).gmap3({
                        marker: {
                            latLng: results[0].geometry.location,
                            options: {
                                draggable: true,
                                icon: "/images/marker-default.png"
                            },
                            events: {
                                dragend: function(marker) {
                                    $(this).gmap3({
                                        getaddress: {
                                            latLng: marker.getPosition(),
                                            callback: function(results) {
                                                var content, infowindow, latLng, map;
                                                map = $(this).gmap3("get");
                                                infowindow = $(this).gmap3({
                                                    get: "infowindow"
                                                });
                                                content = (results && results[0] ? results && results[0].formatted_address : "no address");
                                                if (infowindow) {
                                                    $('#address').val(content);
                                                    infowindow.open(map, marker);
                                                    infowindow.setContent(content);
                                                } else {
                                                    $('#address').val(content);
                                                    $(this).gmap3({
                                                        infowindow: {
                                                            anchor: marker,
                                                            options: {
                                                                content: content
                                                            }
                                                        }
                                                    });
                                                }
                                                map = $(this).gmap3("get");
                                                latLng = results[0].geometry.location;
                                                map.panTo(latLng);
                                            }
                                        }
                                    });
                                }
                            }
                        }
                    });
                    map = $(this).gmap3("get");
                    latLng = results[0].geometry.location;
                    map.panTo(latLng);
                }
            }
        }
    });
};
Gmaps.buttonToGetLocation = function() {
    $('.btn-geocoder-address-for-map').click(function() {
        var address;
        address = $('.input-address-search').val();
        this.getLocationFromAddress(address);
    });
};
Gmaps.inputToGetLocationOnKeyup = function() {
    var delay;
    $('#address').keyup(function() {
        var address;
        address = this.value;
        if (address.length > 5) {
            delay(function() {
                this.getLocationFromAddress(address);
            }, 900);
        }
    });
    delay = (function() {
        var timer;
        timer = 0;
        return function(callback, ms) {
            clearTimeout(timer);
            timer = setTimeout(callback, ms);
        };
    })();
};
Gmaps.showMapCanvasIfHidden = function() {
    if ($('#map').css('display') === 'none') {
        $('#map').show();
    }
};

module.exports = Gmaps;
