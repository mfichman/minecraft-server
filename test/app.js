$(document).ready(function() {
    $('#save').click(function() {
        $('#save').attr('class', 'btn btn-warning');
        $.post('world/save').done(function(log) {
            $('#save').attr('class', 'btn btn-primary');
        }).fail(function(log) {
            $('#save').attr('class', 'btn btn-danger');
        });
    });

    $.get('world/saves').done(function(saves) {
        var html = ""
        $.each(saves, function(k, v) {
            html += "<button class='btn btn-default' data='"+v+"'><strong>LOAD</strong> "+v+"</button>"
        });
        $('#load').html(html)

        $('#load button').click(function() {
            var button = $(this);
            var name = button.attr('data')
            button.attr('class', 'btn btn-warning');
            $.post('world/active', name).done(function() {
                button.attr('class', 'btn btn-default');
            }).fail(function(log) {
                button.attr('class', 'btn btn-danger');
            });
        });
    });

    $.get('log').done(function(log) {
        $('#log').html(log)
    });
});
