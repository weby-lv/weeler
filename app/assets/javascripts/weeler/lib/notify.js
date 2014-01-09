var notify = {
  notice: null,
  show: function(name, message) {
    $(function(){
      $.pnotify({
        type: name, // 'notice', 'info', 'success', 'error'
        title: name,
        text: message,
        styling: 'bootstrap',
        shadow: false,
        animation: 'fade',
        closer: true,
        history: false,
        auto_display: true
      })
    });
  }
}