$(document).ready(function() {
    $('#container').hide();

    /* Trigger a world save/upload */
    $('#save-button').click(function() {
        var button = $(this);
        button.prop('disabled', true);
        button.attr('class', 'btn btn-warning');
        $.post('world/save').done(function(log) {
            button.prop('disabled', false);
            button.attr('class', 'btn btn-primary');
        }).fail(function(log) {
            button.prop('disabled', false);
            button.attr('class', 'btn btn-danger');
        });
    });

    /* Trigger a world download/reload */
    $('#load-button').click(function() {
        var name = $('#load-button-text').html();
        var button = $(this);
        button.prop('disabled', true);
        button.attr('class', 'btn btn-warning');
        $.post('world/active', name).done(function() {
            button.prop('disabled', false);
            button.attr('class', 'btn btn-default');
        }).fail(function(log) {
            button.prop('disabled', false);
            button.attr('class', 'btn btn-danger');
        });
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
        $('#container').show();
    });

    /* Load the log periodically */
    var loadLog = function() { 
        $.get('log').done(function(log) {
            $('#log').html(log)
            setTimeout(loadLog, 1000);
        });
    };

    setTimeout(loadLog, 1000);
});
