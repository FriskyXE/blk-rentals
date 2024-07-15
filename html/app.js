document.addEventListener('DOMContentLoaded', function () {
    const app = new Vue({
        el: '#app',
        data: {
            boats: []
        },
        methods: {
            rentBoat(model) {
                const protocol = window.location.protocol;
                const resourceName = 'blk-rentals';
                $.post(`${protocol}//${resourceName}/rentBoat`, JSON.stringify({ model: model }), function () {
                    // Close the NUI and hide the cursor
                    $.post(`${protocol}//${resourceName}/closeMenu`, JSON.stringify({}));
                    $('body').fadeOut(); // Animate closing
                });
            }
        }
    });

    window.addEventListener('message', function (event) {
        if (event.data.type === 'openMenu') {
            app.boats = event.data.boats;
            $('body').fadeIn(); // Animate opening
        }
    });

    $(document).keydown(function (event) {
        if (event.key === 'Escape') {
            const protocol = window.location.protocol;
            const resourceName = 'blk-rentals';
            $.post(`${protocol}//${resourceName}/closeMenu`, JSON.stringify({}));
            $('body').fadeOut(); // Animate closing
        }
    });

    $('body').hide();
});