$(document).ready(function() {
  $('submit-button').click(function){
    var searched_words = $(".searched-words").val();
    $.ajax({
      type: "GET",
      url: "https://api.github.com/users/" + searched_words +"/repos",
      success: function(data) {
        console.log(data);
      },
      error: function(jqXHR) {
        console.error(jqXHR.responseText);
      }
    });
  })
});
