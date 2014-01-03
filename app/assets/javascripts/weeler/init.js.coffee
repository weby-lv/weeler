#= require jquery
#= require jquery.ui.all
#= require jquery_ujs
#= require turbolinks
#= require_tree ./vendor
#= require_tree ./lib
#= require weeler/app
#= require_self

$(document).ready () ->
  $('.weeler-file-inputs').bootstrapFileInput()
  sortable.init()