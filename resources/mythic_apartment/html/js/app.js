var openAudio = document.createElement('audio');
openAudio.controls = false;
openAudio.volume = 0.1;
openAudio.src = './door_open.wav';

var closeAudio = document.createElement('audio');
closeAudio.controls = false;
closeAudio.volume = 0.1;
closeAudio.src = './door_close.wav';

window.addEventListener("message", function (event) {
    if (event.data.action == "enter") {
        console.log(event.data.action);
        openAudio.play();
    } else if (event.data.action == "exit") {
        console.log(event.data.action);
        closeAudio.play();
    }
});