//= require jquery
//= require jquery.turbolinks
//= require jquery-ui
//= require jquery_ujs
//= require turbolinks
//= require ./vendor/moment
//= require_tree ./vendor
//= require_tree ./lib
//= require weeler/app
//= require_self

(function() {
  var app;

  app = {
    boot: function() {
      $('.weeler-file-inputs').bootstrapFileInput();
      sortable.init();
      flash.init();
      $('[data-provide="rowlink"],[data-provides="rowlink"]').each(function() {
        return $(this).rowlink($(this).data());
      });
      $('.datepicker').datetimepicker({
        format: 'DD/MM/YYYY'
      });
      return $('.datetimepicker').datetimepicker();
    }
  };

  $(document).ready(function() {
    return app.boot();
  });

}).call(this);
