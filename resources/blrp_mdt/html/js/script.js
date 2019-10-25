$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";
        } else if (event.data.type == "publishResults") {
            showResults(event.data.string)
        } else if (event.data.type == "publishBoloData") {
            showBoloResults(event.data.string)
        } else if (event.data.type == "clearResults") {
            $('#searchResults').html("")
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
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
    var firstname = $("#warn-first-name").val().trim()
    var lastname = $("#warn-last-name").val().trim()
    var registration = $("#warn-reg").val().trim().toUpperCase()
    var location = $("#warn-loc").val().trim()
    var details = $("#warn-details").val().trim()

    if (firstname !== "" && lastname !== "" && location !== "" && details !== "") {
      $.post('http://blrp_mdt/insertData', JSON.stringify({
          eventType: "Warning",
          firstname: firstname,
          lastname: lastname,
          registration: registration,
          location: location,
          details: details
      }));
      clearInputs(element)
      showNotice('Warning Submitted')
    } else {
      showNotice('First Name, Name, Location, and Details fields are must be completed')
    }
    break;
  case "citation":
    var firstname = $("#cit-first-name").val().trim()
    var lastname = $("#cit-last-name").val().trim()
    var registration = $("#cit-reg").val().trim().toUpperCase()
    var location = $("#cit-loc").val().trim()
    var citationAmount = $("#cit-total").val().trim()
    var charges = $("#cit-charges").val().trim()
    var details = $("#cit-details").val().trim()

    if (firstname !== "" && lastname !== "" && location !== "" && citationAmount !== "" && charges !== "" && details !== "") {
      $.post('http://blrp_mdt/insertData', JSON.stringify({
          eventType: "Citation",
          firstname: firstname,
          lastname: lastname,
          registration: registration,
          location: location,
          citationAmount: citationAmount,
          charges: charges,
          details: details
      }));
      clearInputs(element)
      showNotice('Citation Submitted')
    } else {
      showNotice('First Name, Name, Location, Citation Amount, Charges, and Details fields are must be completed')
    }
    break;
  case "arrest":
    var firstname = $("#arrest-first-name").val().trim()
    var lastname = $("#arrest-last-name").val().trim()
    var registration = $("#arrest-reg").val().trim().toUpperCase()
    var location = $("#arrest-loc").val().trim()
    var citationAmount = $("#arrest-cit-total").val().trim()
    var restitutionAmount = $("#arrest-rest-total").val().trim()
    var prisonTime = $("#arrest-prison-total").val().trim()
    var charges = $("#arrest-charges").val().trim()
    var details = $("#arrest-details").val().trim()

    if (firstname !== "" && lastname !== "" && location !== "" && citationAmount !== "" && restitutionAmount !== "" && prisonTime !== "" && charges !== "" && details !== "") {
      $.post('http://blrp_mdt/insertData', JSON.stringify({
          eventType: "Arrest",
          firstname: firstname,
          lastname: lastname,
          registration: registration,
          location: location,
          citationAmount: citationAmount,
          restitutionAmount: restitutionAmount,
          prisonTime: prisonTime,
          charges: charges,
          details: details
      }));
      clearInputs(element)
      showNotice('Arrest Record Submitted')
    } else {
      showNotice('First Name, Name, Location, Citation Amount, Restitution Amt, Prison Sentence, Charges, and Details fields are must be completed')
    }
    break;
  case "bolo":
    var firstname = $("#bolo-first-name").val().trim()
    var lastname = $("#bolo-last-name").val().trim()
    var registration = $("#bolo-reg").val().trim().toUpperCase()
    var details = $("#bolo-details").val().trim()

    if (details !== "") {
      $.post('http://blrp_mdt/insertData', JSON.stringify({
          eventType: "BOLO",
          firstname: firstname,
          lastname: lastname,
          registration: registration,
          details: details
      }));
      clearInputs(element)
      showNotice('BOLO Submitted')
    } else {
      showNotice('Details field must be completed')
    }
    break;
  case "warrant":
    var firstname = $("#warrant-first-name").val().trim()
    var lastname = $("#warrant-last-name").val().trim()
    var registration = $("#warrant-reg").val().trim().toUpperCase()
    var description = $("#warrant-desc").val().trim()
    var details = $("#warrant-details").val().trim()

    if (firstname !== "" && lastname  !== "" && description !== "" && details !== "") {
      $.post('http://blrp_mdt/insertData', JSON.stringify({
          eventType: "Warrant",
          firstname: firstname,
          lastname: lastname,
          registration: registration,
          description: description,
          details: details
      }));
      clearInputs(element)
      showNotice('Warrant Submitted')
    } else {
      showNotice('First Name, Name, Description, and Details fields are must be completed')
    }
    break;
  case "search":
    $.post('http://blrp_mdt/searchData', JSON.stringify({
        eventType: "searchRecords",
        firstname: $("#search-first-name").val(),
        lastname: $("#search-last-name").val(),
        registration: $("#search-reg").val(),
        recordType: document.querySelector('input[name="recordSearchRadios"]:checked').value
    }));
    break;
  case "boloRefresh":
    $.post('http://blrp_mdt/refreshBoloData', JSON.stringify({
        eventType: "refreshBolo"
    }));
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
  $('#search-bolo').hide();
}

function insertCitationToggle() {
  $('#insert-warning').hide();
  $('#insert-citation').show();
  $('#insert-arrest').hide();
  $('#publish-bolo').hide();
  $('#submit-warrant').hide();
  $('#search-records').hide();
  $('#search-bolo').hide();
}

function insertArrestToggle() {
  $('#insert-warning').hide();
  $('#insert-citation').hide();
  $('#insert-arrest').show();
  $('#publish-bolo').hide();
  $('#submit-warrant').hide();
  $('#search-records').hide();
  $('#search-bolo').hide();
}

function publishBoloToggle() {
  $('#insert-warning').hide();
  $('#insert-citation').hide();
  $('#insert-arrest').hide();
  $('#publish-bolo').show();
  $('#submit-warrant').hide();
  $('#search-records').hide();
  $('#search-bolo').hide();
}

function submitWarrantToggle() {
  $('#insert-warning').hide();
  $('#insert-citation').hide();
  $('#insert-arrest').hide();
  $('#publish-bolo').hide();
  $('#submit-warrant').show();
  $('#search-records').hide();
  $('#search-bolo').hide();
}

function searchRecordsToggle() {
  $('#insert-warning').hide();
  $('#insert-citation').hide();
  $('#insert-arrest').hide();
  $('#publish-bolo').hide();
  $('#submit-warrant').hide();
  $('#search-records').show();
  $('#search-bolo').hide();
}

function resetToggle() {
  $('#insert-warning').hide();
  $('#insert-citation').hide();
  $('#insert-arrest').hide();
  $('#publish-bolo').hide();
  $('#submit-warrant').hide();
  $('#search-records').hide();
  $('#search-bolo').hide();
}

function viewBOLOToggle() {
  $('#insert-warning').hide();
  $('#insert-citation').hide();
  $('#insert-arrest').hide();
  $('#publish-bolo').hide();
  $('#submit-warrant').hide();
  $('#search-records').hide();
  $('#search-bolo').show();
  $('#boloResults').html("");
}

function showResults(string) {
  $('#searchResults').html("");
  $('#searchResults').html(string);
  var coll = document.getElementsByClassName("collapsible");
  var i;

  for (i = 0; i < coll.length; i++) {
    coll[i].addEventListener("click", function() {
      this.classList.toggle("active");
      var content = this.nextElementSibling;
      if (content.style.display === "block") {
        content.style.display = "none";
      } else {
        content.style.display = "block";
      }
    });
  }
}

function showBoloResults(string) {
  $('#boloResults').html("");
  $('#boloResults').html(string);
  var coll = document.getElementsByClassName("collapsible");
  var i;

  for (i = 0; i < coll.length; i++) {
    coll[i].addEventListener("click", function() {
      this.classList.toggle("active");
      var content = this.nextElementSibling;
      if (content.style.display === "block") {
        content.style.display = "none";
      } else {
        content.style.display = "block";
      }
    });
  }
}

function clearInputs(className) {
  $("."+className).val("");
}

function showNotice(str) {
  $(".actionResult").html(str)
  setTimeout(function(){ $(".actionResult").html("") }, 1000);
}

function deleteWarrant(id) {
  $( ".wanted"+id ).remove();
  $.post('http://blrp_mdt/deleteWantedRecord', JSON.stringify({
      warrantID: id
  }));
}

function deleteBolo(id) {
  $( ".bolo"+id ).remove();
  $.post('http://blrp_mdt/deleteBoloRecord', JSON.stringify({
      boloID: id
  }));
}
