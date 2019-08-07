$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var cursor = $('#cursorPointer');
  var cursorX = documentWidth / 2;
  var cursorY = documentHeight / 2;
  var idEnt = 0;

  function UpdateCursorPos() {
    $('#cursorPointer').css('left', cursorX);
    $('#cursorPointer').css('top', cursorY);
  }

  function triggerClick(x, y) {
    var element = $(document.elementFromPoint(x, y));
    element.focus().click();
    return true;
  }

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    // Crosshair
    if(event.data.crosshair == true){
      $(".crosshair").addClass('fadeIn');
      // $("#cursorPointer").css("display","block");
    }
    if(event.data.crosshair == false){
      $(".crosshair").removeClass('fadeIn');
      // $("#cursorPointer").css("display","none");
    }

    // Menu
    if(event.data.menu == 'vehicle'){
      $(".crosshair").addClass('active');
      $(".menu-car-lspd-target").addClass('fadeIn');
      idEnt = event.data.idEntity;
      // $("#cursorPointer").css("display","none");
    }
    if(event.data.menu == 'user'){
      $(".crosshair").addClass('active');
      $(".menu-user-lsfd-target").addClass('fadeIn');
      idEnt = event.data.idEntity;
      // $("#cursorPointer").css("display","none");
    }
    if(event.data.menu == 'self'){
      $(".crosshair").addClass('active');
      $(".menu-self-civ").addClass('fadeIn');
      idEnt = event.data.idEntity;
      // $("#cursorPointer").css("display","none");
    }
    if(event.data.menu == 'vehSelf'){
      $(".crosshair").addClass('active');
      $(".menu-self-civ-veh").addClass('fadeIn');
      idEnt = event.data.idEntity;
      // $("#cursorPointer").css("display","none");
    }
    if((event.data.menu == false)){
      $(".crosshair").removeClass('active');
      $(".menu").removeClass('fadeIn');
      idEnt = 0;
    }

    // Click
    if (event.data.type == "click") {
      triggerClick(cursorX - 1, cursorY - 1);
    }
  });

  // Mousemove
  $(document).mousemove(function(event) {
    cursorX = event.pageX;
    cursorY = event.pageY;
    UpdateCursorPos();
  });

  // Click Menu

  // Functions
  // Vehicle
  $('.openTrunk').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/toggletrunk', JSON.stringify({
      id: idEnt
    }));
    $(this).find('.text').text($(this).find('.text').text() == 'Open Trunk' ? 'Close Trunk' : 'Open Trunk');
  });

  $('.openHood').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/togglehood', JSON.stringify({
      id: idEnt
    }));
    $(this).find('.text').text($(this).find('.text').text() == 'Open Hood' ? 'Close Hood' : 'Open Hood');
  });

  $('.lock').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/togglelock', JSON.stringify({
      id: idEnt
    }));
    //$(this).find('.text').text($(this).find('.text').text() == 'Lock' ? 'Unlock' : 'Lock');
  });

  // Functions
  // User
  $('.cheer').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/cheer', JSON.stringify({
      id: idEnt
    }));
  });

  // Civ target player
  $('.giveId').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/giveId', JSON.stringify({
      id: idEnt
    }));
  });

  $('.giveMoney').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/giveMoney', JSON.stringify({
      id: idEnt
    }));
  });

  //LSFD target player
  $('.dragDeadPlayers').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/dragDeadPlayers', JSON.stringify({
      id: idEnt
    }));
  });
  $('.performCpr').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/performCpr', JSON.stringify({
      id: idEnt
    }));
  });
  $('.reviveTarget').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/reviveTarget', JSON.stringify({
      id: idEnt
    }));
  });
  $('.fieldTreatment').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/fieldTreatment', JSON.stringify({
      id: idEnt
    }));
  });
  $('.checkTargetPulse').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/checkTargetPulse', JSON.stringify({
      id: idEnt
    }));
  });
  $('.checkTargetInjuries').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/checkTargetInjuries', JSON.stringify({
      id: idEnt
    }));
  });
  $('.toggleBedState').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/toggleBedState', JSON.stringify({
      id: idEnt
    }));
  });
  $('.putTargetInNearestVehMed').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/putTargetInNearestVehMed', JSON.stringify({
      id: idEnt
    }));
  });

  //LSPD target player
  $('.restrainTarget').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/restrainTarget', JSON.stringify({
      id: idEnt
    }));
  });
  $('.escortTarget').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/escortTarget', JSON.stringify({
      id: idEnt
    }));
  });
  $('.putTargetInNearestVehPd').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/putTargetInNearestVehPd', JSON.stringify({
      id: idEnt
    }));
  });
  $('.checkTargetIdPd').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/checkTargetIdPd', JSON.stringify({
      id: idEnt
    }));
  });

  //Self Functions
  $('.aptitudes').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/aptitudes', JSON.stringify({
      id: idEnt
    }));
  });
  $('.viewOwnID').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/viewOwnID', JSON.stringify({
      id: idEnt
    }));
  });
  $('.openOwnInventory').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/openOwnInventory', JSON.stringify({
      id: idEnt
    }));
  });
  //Vehicle options (outside vehicle)
  $('.repairVehicle').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/repairVehicle', JSON.stringify({
      id: idEnt
    }));
  });
  $('.accessTrunk').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/accessTrunk', JSON.stringify({
      id: idEnt
    }));
  });
  $('.storeGetShotgun').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/storeGetShotgun', JSON.stringify({
      id: idEnt
    }));
  });
  $('.storeGetSmg').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/storeGetSmg', JSON.stringify({
      id: idEnt
    }));
  });
  $('.repairCopItems').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/repairCopItems', JSON.stringify({
      id: idEnt
    }));
  });
  $('.searchTargetVehicle').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/searchTargetVehicle', JSON.stringify({
      id: idEnt
    }));
  });
  $('.searchTargetVin').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/searchTargetVin', JSON.stringify({
      id: idEnt
    }));
  });
  $('.seizeVehicle').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/seizeVehicle', JSON.stringify({
      id: idEnt
    }));
  });
  $('.impoundVehicle').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/impoundVehicle', JSON.stringify({
      id: idEnt
    }));
  });
  $('.pullPlayerFromVeh').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/pullPlayerFromVeh', JSON.stringify({
      id: idEnt
    }));
  });
  //Self Functions while in vehicle
  $('.rollWindows').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/rollWindows', JSON.stringify({
      id: idEnt
    }));
  });
  $('.toggleEngine').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/toggleEngine', JSON.stringify({
      id: idEnt
    }));
  });
  $('.domeLight').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/domeLight', JSON.stringify({
      id: idEnt
    }));
  });
  $('.toggleSeatbelt').on('click', function(e){
    e.preventDefault();
    $.post('http://menu/toggleSeatbelt', JSON.stringify({
      id: idEnt
    }));
  });

  // Click Crosshair
  $('.crosshair').on('click', function(e){
    e.preventDefault();
    $(".crosshair").removeClass('fadeIn').removeClass('active');
    $(".menu").removeClass('fadeIn');
    $.post('http://menu/disablenuifocus', JSON.stringify({
      nuifocus: false
    }));
  });
  $(document).keypress(function(e){
    if(e.which == 101){ // if "E" is pressed
      $(".crosshair").removeClass('fadeIn').removeClass('active');
      $(".menu").removeClass('fadeIn');
      $.post('http://menu/disablenuifocus', JSON.stringify({
        nuifocus: false
      }));
    }
  });

});
