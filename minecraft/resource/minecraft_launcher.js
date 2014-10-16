

/* Post data to a route, and disable the button that fired the post until the
 * request returns. */
function postLongTask(route, data, button) {
    button.prop('disabled', true);
    button.attr('class', 'btn btn-warning');

    var settings = {
        'url': route,
        'type': 'POST',
        'data': JSON.stringify(data),
        'dataType': 'json',
        'contentType': 'application/json',
    }
    return $.ajax(settings).done(function(log) {
        button.prop('disabled', false);
        button.attr('class', 'btn btn-default');
    }).fail(function(log) {
        button.prop('disabled', false);
        button.attr('class', 'btn btn-danger');
    });
}

/* Set up the UI/button listeners */
function initApp() {
    /* Trigger a world save/upload */
    $('#save-button').click(function() {
        var button = $(this);
        postLongTask('world/save', null, button);
    });

    /* Trigger a world download/reload */
    $('#load-button').click(function() {
        var name = $('#load-button-text').html();
        var button = $(this);
        postLongTask('world/active', name, button);
    });

    $('#reboot-button').click(function() {
        var button = $(this);
        postLongTask('reboot');
    });

    /* Load the list of worlds */
    $.get('world/saves').done(function(saves) {
        var html = "";
        $.each(saves, function(k, v) {
            html += "<li><a class='load-menu-link' href='#'>"+v+"</a></li>";
        });
        $('#load-menu').html(html);
        $('#load-button-text').html(saves[0]);
        $('.load-menu-link').click(function() {
            var link = $(this);
            $('#load-button-text').html(link.html());
        });
        $('.dropdown-toggle').dropdown();
        $('#app').show();
    });

    /* Load the log periodically */
    var loadLog = function() { 
        $.get('log').done(function(log) {
            $('#log').html(log)
            setTimeout(loadLog, 1000);
        });
    };

    setTimeout(loadLog, 1000);
}

/* Set up the login screen */
function initLogin() {
    $('#login-button').click(function() {
        var button = $(this);
        var password = $('#login-password').val();
        var json = {'password': password};
        var promise = postLongTask('session/new', json, button);
        promise.done(function() {
            $('#login').hide();
            initApp();
        });
    });
}

$(document).ready(function() {
    $('#app').hide();
    initLogin();
});
