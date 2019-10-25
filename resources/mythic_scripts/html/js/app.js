var persistentNotifs = {};

window.addEventListener('message', function (event) {
    ShowNotif(event.data);
});

function CreateNotification(data) {
    var $notification = $(document.createElement('div'));
    $notification.addClass('notification').addClass(data.type);
    $notification.html(data.text);
    $notification.fadeIn();
    if (data.style !== undefined) {
        Object.keys(data.style).forEach(function(css) {
            $notification.css(css, data.style[css])
        });
    }

    return $notification;
}

function ShowNotif(data) {
    if (data.persist === undefined) {
        var $notification = CreateNotification(data);
        $('.notif-container').append($notification);
        setTimeout(function() {
            $.when($notification.fadeOut()).done(function() {
                $notification.remove()
            });
        }, data.length != null ? data.length : 2500);
    } else {
        if (data.persist.toUpperCase() == 'START') {
            if (persistentNotifs[data.id] === undefined) {
                var $notification = CreateNotification(data);
                $('.notif-container').append($notification);
                persistentNotifs[data.id] = $notification;
            } else {
                let $notification = $(persistentNotifs[data.id])
                $notification.addClass('notification').addClass(data.type);
                $notification.html(data.text);

                if (data.style !== undefined) {
                    Object.keys(data.style).forEach(function(css) {
                        $notification.css(css, data.style[css])
                    });
                }
            }
        } else if (data.persist.toUpperCase() == 'END') {
            let $notification = $(persistentNotifs[data.id]);
            $.when($notification.fadeOut()).done(function() {
                $notification.remove();
                delete persistentNotifs[data.id];
            });
        }
    }
}

var cancelledTimer = null;

$('document').ready(function() {
    MythicProgBar = {};

    MythicProgBar.Progress = function(data) {
        clearTimeout(cancelledTimer);
        $("#progress-label").text(data.label);

        $(".progress-container").fadeIn('fast', function() {
            $("#progress-bar").stop().css({"width": 0, "background-color": "rgba(0, 0, 0, 0.75)"}).animate({
              width: '100%'
            }, {
              duration: parseInt(data.duration),
              complete: function() {
                $(".progress-container").fadeOut('fast', function() {
                    $('#progress-bar').removeClass('cancellable');
                    $("#progress-bar").css("width", 0);
                    $.post('http://mythic_scripts/actionFinish', JSON.stringify({
                        })
                    );
                })
              }
            });
        });
    };

    MythicProgBar.ProgressCancel = function() {
        $("#progress-label").text("CANCELLED");
        $("#progress-bar").stop().css( {"width": "100%", "background-color": "rgba(71, 0, 0, 0.8)"});
        $('#progress-bar').removeClass('cancellable');

        cancelledTimer = setTimeout(function () {
            $(".progress-container").fadeOut('fast', function() {
                $("#progress-bar").css("width", 0);
                $.post('http://mythic_scripts/actionCancel', JSON.stringify({
                    })
                );
            });
        }, 1000);
    };

    MythicProgBar.CloseUI = function() {
        $('.main-container').fadeOut('fast');
    };

    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case 'mythic_progress':
                MythicProgBar.Progress(event.data);
                break;
            case 'mythic_progress_cancel':
                MythicProgBar.ProgressCancel();
                break;
        }
    });
});
