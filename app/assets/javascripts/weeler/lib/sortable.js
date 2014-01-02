var sortable = {
  init: function() {
    $( ".sortable" ).sortable({
        update: function(event, ui){
          $.post($(this).data("url"), { orders: $(this).sortable('serialize')});
        }
    });
  }
}