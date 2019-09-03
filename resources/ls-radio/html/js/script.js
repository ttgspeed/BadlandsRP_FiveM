$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://ls-radio/escape', JSON.stringify({}));
        }
    };

    $("#login-form").submit(function(e) {
        e.preventDefault(); // Prevent form from submitting

        $.post('http://ls-radio/joinRadio', JSON.stringify({
            channel: $("#channel").val()
        }));
    });

    $("#onoff").submit(function(e) {
        e.preventDefault(); // Prevent form from submitting

        $.post('http://ls-radio/leaveRadio', JSON.stringify({

        }));
    });
});
