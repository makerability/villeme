(function($) {
    var BootstrapJS = BootstrapJS || {};

    BootstrapJS = {
        init: function() {
            BootstrapJS.Tooltip();
            BootstrapJS.Dropdown();
            BootstrapJS.Modal();
            BootstrapJS.ModalFeedback();
            BootstrapJS.Affix();
            BootstrapJS.Popover();
        },
        Tooltip: function() {
            $(document).on("mouseenter", ".has-tooltip", function() {
                $(this).tooltip({
                    container: "body",
                    delay: {
                        show: 600,
                        hide: 150
                    }
                }).tooltip("show");
            });
        },
        Dropdown: function() {
            $("a[rel~=dropdown], .has-dropdown").dropdown();
        },
        Modal: function() {
            $(".has-modal").click(function() {
                $("#modal").modal("toggle");
            });
        },
        ModalFeedback: function() {
            $(".has-modal-feedback").click(function() {
                $("#modal-feedback").modal("toggle");
            });
        },
        Affix: function() {
            $(".col-fixed").affix();
        },
        Popover: function() {

            $(document).on("mouseenter", ".has-popover", function() {
                var _this;
                _this = this;

                $(this).popover({
                    trigger: "manual",
                    html: true
                });

                $(this).popover("show");

                $(".popover").on("mouseleave", function() {
                    $(_this).popover("hide");
                });
                $(".popover").on("click", function() {
                    $(_this).popover("hide");
                });
            }).on("mouseleave", ".has-popover", function() {
                var _this;
                _this = this;
                setTimeout((function() {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide");
                    }
                }), 100);
            });

            $(".has-popover-click").popover({
                html: true,
                trigger: "manual"
            }).click(function(e) {
                $(".has-popover-click").not(this).popover("hide");
                $(this).popover("toggle");
            });

            $(".content").click(function(e) {
                $(".has-popover-click").popover("hide");
            });
        }
    };
    $(function() {
        BootstrapJS.init();
    });

})(jQuery);
