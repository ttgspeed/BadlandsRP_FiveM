$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";
        } else if (event.data.type == "publishResults") {
            showResults(event.data.string)
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
          console.log("I should exit now")
            $.post('http://blrp_mdt/escape', JSON.stringify({}));
        }
    };

    $(":input").attr('autocomplete', 'new-password');
    $("a").css("cursor","pointer");
    $("#homeBtn").css("cursor","pointer");

    $('#homeBtn').click(function(e) {
      $(":input").val("");
      resetToggle();
    });
});

function auto_grow(element) {
  element.style.height = "5px";
  element.style.height = (element.scrollHeight)+"px";
}

function submitAction(element) {
  switch(element) {
  case "warning":
    $.post('http://blrp_mdt/insertData', JSON.stringify({
        eventType: "warningInsert",
        firstname: $("#warn-first-name").val(),
        lastname: $("#warn-last-name").val(),
        registration: $("#warn-reg").val(),
        location: $("#warn-loc").val(),
        details: $("#warn-details").val()
    }));
    console.log("Warning submit attempt")
    break;
  case "citation":
    $.post('http://blrp_mdt/insertData', JSON.stringify({
        eventType: "citationInsert",
        firstname: $("#cit-first-name").val(),
        lastname: $("#cit-last-name").val(),
        registration: $("#cit-reg").val(),
        location: $("#cit-loc").val(),
        citationAmount: $("#cit-total").val(),
        charges: $("#cit-charges").val(),
        details: $("#cit-details").val()
    }));
    console.log("Citation submit attempt")
    break;
  case "arrest":
    $.post('http://blrp_mdt/insertData', JSON.stringify({
        eventType: "arrestInsert",
        firstname: $("#arrest-first-name").val(),
        lastname: $("#arrest-last-name").val(),
        registration: $("#arrest-reg").val(),
        location: $("#arrest-loc").val(),
        citationAmount: $("#arrest-cit-total").val(),
        restitutionAmount: $("#arrest-rest-total").val(),
        prisonTime: $("#arrest-prison-total").val(),
        charges: $("#arrest-charges").val(),
        details: $("#arrest-details").val()
    }));
    console.log("Arrest submit attempt")
    break;
  case "bolo":
    $.post('http://blrp_mdt/insertData', JSON.stringify({
        eventType: "boloInsert",
        firstname: $("#bolo-first-name").val(),
        lastname: $("#bolo-last-name").val(),
        registration: $("#bolo-reg").val(),
        details: $("#bolo-details").val()
    }));
    console.log("BOLO submit attempt")
    break;
  case "warrant":
    $.post('http://blrp_mdt/insertData', JSON.stringify({
        eventType: "warrantInsert",
        firstname: $("#warrant-first-name").val(),
        lastname: $("#warrant-last-name").val(),
        registration: $("#warrant-reg").val(),
        description: $("#warrant-desc").val(),
        details: $("#warrant-details").val()
    }));
    console.log("Warrant submit attempt")
    break;
  case "search":
    $.post('http://blrp_mdt/searchData', JSON.stringify({
        eventType: "searchRecords",
        firstname: $("#search-first-name").val(),
        lastname: $("#search-last-name").val(),
        registration: $("#search-reg").val(),
    }));
    console.log("Attempt to search")
    break;
  default:
    console.log("No valid case received")
  }
}

function insertWarningToggle() {
  $('#insert-warning').show();
  $('#insert-citation').hide();
  $('#insert-arrest').hide();
  $('#publish-bolo').hide();
  $('#submit-warrant').hide();
  $('#search-records').hide();
}

function insertCitationToggle() {
  $('#insert-warning').hide();
  $('#insert-citation').show();
  $('#insert-arrest').hide();
  $('#publish-bolo').hide();
  $('#submit-warrant').hide();
  $('#search-records').hide();
}

function insertArrestToggle() {
  $('#insert-warning').hide();
  $('#insert-citation').hide();
  $('#insert-arrest').show();
  $('#publish-bolo').hide();
  $('#submit-warrant').hide();
  $('#search-records').hide();
}

function publishBoloToggle() {
  $('#insert-warning').hide();
  $('#insert-citation').hide();
  $('#insert-arrest').hide();
  $('#publish-bolo').show();
  $('#submit-warrant').hide();
  $('#search-records').hide();
}

function submitWarrantToggle() {
  $('#insert-warning').hide();
  $('#insert-citation').hide();
  $('#insert-arrest').hide();
  $('#publish-bolo').hide();
  $('#submit-warrant').show();
  $('#search-records').hide();
}

function searchRecordsToggle() {
  $('#insert-warning').hide();
  $('#insert-citation').hide();
  $('#insert-arrest').hide();
  $('#publish-bolo').hide();
  $('#submit-warrant').hide();
  $('#search-records').show();
}

function resetToggle() {
  $('#insert-warning').hide();
  $('#insert-citation').hide();
  $('#insert-arrest').hide();
  $('#publish-bolo').hide();
  $('#submit-warrant').hide();
  $('#search-records').hide();
}

function showResults(string) {
  console.log("I got here in JS")
  $('#searchResults').html(string);
}

function clearInputs(className) {
  $("."+className).val("");
}
