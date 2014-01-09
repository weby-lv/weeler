#= require jquery
#= require jquery.ui.all
#= require jquery_ujs
#= require turbolinks
#= require_tree ./vendor
#= require_tree ./lib
#= require weeler/app
#= require_self

app = {
  boot: () ->
    $('.weeler-file-inputs').bootstrapFileInput()
    sortable.init()
}

$(document).ready () ->
  app.boot()

$(document).on 'page:load', () ->
  app.boot()