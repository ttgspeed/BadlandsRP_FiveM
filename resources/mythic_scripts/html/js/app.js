var openAudio = document.createElement('audio');
openAudio.controls = false;
openAudio.volume = 0.1;
openAudio.src = './door_open.wav';

var closeAudio = document.createElement('audio');
closeAudio.controls = false;
closeAudio.volume = 0.1;
closeAudio.src = './door_close.wav';

window.addEventListener('message', function (event) {
    switch(event.data.action) {
        case 'shortnotif':
            break;
        case 'notif':
            break;
        case 'longnotif':
            ShowNotif(event.data);
            break;
        case 'enter':
            console.log(event.data.action);
            openAudio.play();
            break;
        case 'exit':
            console.log(event.data.action);
            closeAudio.play();
            break;
        default:
            ShowNotif(event.data);
            break;
    }
});

function ShowNotif(data) {
    var $notification = $('.notification.template').clone();
    $notification.removeClass('template');
    $notification.addClass(data.type);
    $notification.html(data.text);
    $notification.fadeIn();
    $('.notif-container').append($notification);
    setTimeout(function() {
        $.when($notification.fadeOut()).done(function() {
            $notification.remove()
        });
    }, data.length != null ? data.length : 2500);
}

$('document').ready(function() {
    MythicProgBar = {};

    MythicProgBar.Progress = function(data) {
        $(".progress-container").css({"display":"block"});
        $("#progress-label").text(data.label);
        $("#progress-bar").stop().css({"width": 0, "background-color": "#ff5f00"}).animate({
          width: '100%'
        }, {
          duration: parseInt(data.duration),
          complete: function() {
            $(".progress-container").css({"display":"none"});
            $("#progress-bar").css("width", 0);
            $.post('http://mythic_scripts/actionFinish', JSON.stringify({
                })
            );
          }
        });
    };

    MythicProgBar.ProgressCancel = function() {
        $(".progress-container").css({"display":"block"});
        $("#progress-label").text("CANCELLED");
        $("#progress-bar").stop().css( {"width": "100%", "background-color": "#ff0000"});

        setTimeout(function () {
            $(".progress-container").css({"display":"none"});
            $("#progress-bar").css("width", 0);
            $.post('http://mythic_scripts/actionCancel', JSON.stringify({
                })
            );
        }, 1000);
    };

    MythicProgBar.CloseUI = function() {
        $('.main-container').css({"display":"none"});
        $(".character-box").removeClass('active-char');
        $(".character-box").attr("data-ischar", "false")
        $("#delete").css({"display":"none"});
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
    })
});
