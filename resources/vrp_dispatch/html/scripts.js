// Credit to Kanersps @ EssentialMode and Eraknelo @FiveM
function addGaps(nStr) {
  nStr += '';
  var x = nStr.split('.');
  var x1 = x[0];
  var x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + '<span style="margin-left: 3px; margin-right: 3px;"/>' + '$2');
  }
  return x1 + x2;
}
function addCommas(nStr) {
  nStr += '';
  var x = nStr.split('.');
  var x1 = x[0];
  var x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + ',<span style="margin-left: 0px; margin-right: 1px;"/>' + '$2');
  }
  return x1 + x2;
}


$(document).ready(function(){

  // Partial Functions
  function closeMain() {

    $(".full-screen").css("display", "none");
    $(".body").css("display", "none");
  }
  function openMain() {
    $(".full-screen").css("display", "flex");
    $(".body").css("display", "block");
  }
  function closeAll() {
    $(".body").css("display", "none");
  }
  function openContainer() {
    $(".dispatch-container").css("display", "block");
  }
  function closeContainer() {
    $(".dispatch-container").css("display", "none");
  }
  window.addEventListener('click', function(event){
    var item = event.target;
    if(item == "nui://vrp_dispatch/html/ui.html#" || item == "A"){
      if($(item).attr('id') != "closewindow")
      {
        $.post('http://vrp_dispatch/respond', JSON.stringify({
        class : $(item).attr('class'),
        resolveid : $(item).attr('id')
        }));
      }
      else
      {
        $.post('http://vrp_dispatch/close', JSON.stringify({}));
      }
    }

  });
  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;


    // Update HUD Balance
    if(item.data) {
        $("#data").html(item.data);
    }
    if(item.faction) {
      if(item.faction == "police")
      {
        $("#heading").html("<span style='color:blue'>LSPD</span> - Computer Aided Dispatch ");
      }
      else if (item.faction == "EMS/Fire")
      {
        $("#heading").html("<span style='color:red'>LSFD</span> - Computer Aided Dispatch ");
      }
      else if (item.faction == "taxi")
      {
        $("#heading").html("<span style='color:yellow'>Los Santos Taxi Co</span> - Dispatch ");
      }
      else if (item.faction == "repair")
      {
        $("#heading").html("<span style='color:gold'>Los Santos Automotive Association </span> -Dispatch ");
      }
  }
    // Open & Close main window
    if(item.openDispatch == true) {
      openMain();
    }
    if(item.openDispatch == false) {
      closeMain();
    }
    // Open sub-windows / partials
  });
  // On 'Esc' call close method
  document.onkeyup = function (data) {
    if (data.which == 27 ) {
      $.post('http://vrp_dispatch/close', JSON.stringify({}));
    }
  };
});
