$(function(){
    window.addEventListener("message", function(event){
        if(event.data.options){
          var options = event.data.options;
          notify(options.type,options.title,options.text)
        }else{
          var maxNotifications = event.data.maxNotifications;
          Noty.setMaxVisible(maxNotifications.max, maxNotifications.queue);
        };
    });
});
