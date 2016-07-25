$(function(){
  console.log("taaaaabbbbbsss");
// click sur le btn ingredient du footer mobile
  $(".js-ingredient-tab").on("click", function(){
    console.log("click")
    $(this).addClass("active");
    if  ($(".ingredient-card-mobile").hasClass("hide")) {
      $(".ingredient-card-mobile").removeClass("hide");
      $(".product-card-mobile").addClass("hide");
      $(".reviews-card-mobile").addClass("hide");
      // couleur de footer
      $(".js-ingredient-tab").addClass("active");
      $(".js-product-tab").removeClass("active");
      $(".js-reviews-tab").removeClass("active");
    }
    // Change active tab

    // Hide all tab-content (use class="hidden")

    // Show target tab-content (use class="hidden")
  });
// click sur le btn reviews du footer mobile
  $(".js-reviews-tab").on("click", function(){
    console.log("click")
    $(this).addClass("active");
    if  ($(".reviews-card-mobile").hasClass("hide")) {
      $(".reviews-card-mobile").removeClass("hide");
      $(".reviews-card-mobile").removeClass("active");
      $(".product-card-mobile").addClass("hide");
      $(".ingredient-card-mobile").addClass("hide");
      // couleur de footer
      $(".js-reviews-tab").addClass("active");
      $(".js-product-tab").removeClass("active");
      $(".js-ingredient-tab").removeClass("active");
    }
  })
// click sur le btn product du footer mobile
  $(".js-product-tab").on("click", function(){
    console.log("click")
    $(this).addClass("active");
    if  ($(".product-card-mobile").hasClass("hide")) {
      $(".product-card-mobile").removeClass("hide");
      $(".reviews-card-mobile").addClass("hide");
      $(".ingredient-card-mobile").addClass("hide");
      // couleur de footer
      $(".js-product-tab").addClass("active");
      $(".js-ingredient-tab").removeClass("active");
      $(".js-reviews-tab").removeClass("active");
    }
  })
});
