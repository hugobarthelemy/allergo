//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require cocoon
//= require algolia/v3/algoliasearch.min
//= require hogan
//= require_tree .

$(".alert").alert();
window.setTimeout(function() { $(".alert").not("#no-allergy-alert").alert('close'); }, 2000);
