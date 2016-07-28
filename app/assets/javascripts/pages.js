var sound = new Audio("/barcode.wav");

$(document).ready(function() {

  $('#scan-icon').click(function () {
    $(this).hide();
    barcode.config.start = 0.1;
    barcode.config.end = 0.9;
    barcode.config.video = '#barcodevideo';
    barcode.config.canvas = '#barcodecanvas';
    barcode.config.canvasg = '#barcodecanvasg';
    barcode.setHandler(function(barcode) {
      var getcode = $('#result').val(barcode);
      $('#send').submit();
    });
    barcode.init();

    $('#result').bind('DOMSubtreeModified', function(e) {
      sound.play();
    });
    $('#barcode').show();
  });

});
