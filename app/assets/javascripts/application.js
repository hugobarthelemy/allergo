//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require cocoon
//= require algolia/v3/algoliasearch.min
//= require hogan
//= require_tree .

$(".alert-msg").alert();
window.setTimeout(function() { $(".alert-msg").not("#no-allergy-alert").alert('close'); }, 2000);
