// passer la carte en rouge -> NOK
var match = <%= @matching_allergens %>;
$(function(){
  if (match == nok) {
  // couleur fond de carte
    $(".js-background-color").removeClass("ok");
    $(".js-background-color").removeClass("alert");
    $(".product-card-mobile").addClass("nok");
    }
  else {

  }
  // couleur du footer
    }
}
// passer la carte en orange -> ALERT
$(function(){
  if (match == alert) {
  // couleur fond de carte
  // couleur du footer
  }
}
// passer la carte en rouge -> OK
$(function(){
  if (match == ok) {
  // couleur fond de carte
  // couleur du footer
  }
}
