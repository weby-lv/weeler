#= require jquery
#= require jquery_ujs
#= require_tree "./vendor"
#= require weeler/app
#= require_self

$(document).ready () ->
  $('.weeler-file-inputs').bootstrapFileInput()