var flash = {
  init: function() {
    $(".flash").fadeTo(4000, 6000).slideUp(500, function(){
      $(".flash").alert('close');
    });
  }
}
