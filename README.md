# Weeler

[![Gem Version](https://badge.fury.io/rb/weeler.png)](http://badge.fury.io/rb/weeler)
[![Build Status](https://travis-ci.org/weby-lv/weeler.png?branch=master)](https://travis-ci.org/weby-lv/weeler)
[![Coverage Status](https://coveralls.io/repos/weby-lv/weeler/badge.png)](https://coveralls.io/r/weby-lv/weeler)
[![Code Climate](https://codeclimate.com/github/weby-lv/weeler.png)](https://codeclimate.com/github/weby-lv/weeler)

CMS for weby.lv projects.

## Installation

Add this line to your application's Gemfile:

    gem 'weeler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install weeler


## Setup

Run weeler generator:

    $ rails g weeler:install

It will generate:
* weeler.rb setting file in config/initializers folder;
* migrations for translation, settings and object seos;
* application_controller.rb in weeler controller scope. It is the parent controller of all weeler controllers;
* assets in lib/assets for modify, append new javascript or style for weeler backend.

And then migrate database:

    $ rake db:migrate

## Usage

### Adding controllers and views

Create controllers and views in <tt>app/controller/weeler</tt> and <tt>app/view/weeler</tt> and then add routes in <tt>mount_weeler_at</tt> block in <tt>config/routes.rb</tt> file. There is no limitation or DCL for that. Also you need to extend at least <tt>Weeler::BaseController</tt> if you expect that weeler work as expected.

### Menu

If you want your controller work under menu section, you should extend one of:
* <tt>Weeler::AdministrationController</tt> - for administration section;
* <tt>Weeler::ContentController</tt> - for content section;

Then you should append <tt>config.content_menu_items</tt> or <tt>config.administration_menu_items</tt> array with hash that contains: <tt>name</tt> for submenu name and <tt>weeler_path</tt> as string for relative weeler path. E.g.:

    config.content_menu_items = [
      {name: "Posts",         weeler_path: "posts"},
      {name: "Post comments", weeler_path: "comments"}
    ]

### acts_as_restful

Weeler action controller method.
It creates all restful actions for action controller. Create a controller for your
model (e.g. Post) what you want to administrate in weeler. Add method <tt>acts_as_restful Post</tt>
and permit params for your resource - option <tt>permit_params</tt>. Also you can paginate - add
option <tt>paginate</tt>
e.g.

    class Weeler::PostController < Weeler::ContentController
      acts_as_restful Post, permit_params: [:title, :body], paginate: 50
    end

It will handle <tt>:index</tt>, <tt>:new</tt>, <tt>:edit</tt>, <tt>:update</tt>,
<tt>:destroy</tt>, <tt>:order</tt>, <tt>:activation</tt> and <tt>:remove_image</tt> actions

For permiting custom by role or permiting all params (permit!),
you must add block <tt>permit_params: -> (params) { params.require(:post).permit! }</tt>

You should implement form file with your own active record attributes.
To do that, create <tt>_form.html.haml</tt> in <tt>views/weeler/_YOUR_RESOURCE_/_form.html.haml</tt>
where <tt>_YOUR_RESOURCE_</tt> is name of your resource.

Also you can override all standart restful action view and implement, if you need,
<tt>_filter.html.haml</tt>

### View partials for restful controllers:

Weeler have default views for index, new, edit actions. You should override <tt>_form.html.haml</tt> partial.

### View helper image_upload_field :

Weeler action view helper method.
It creates file upload field with info and preview for image.

e.g.

    <%= f.image_upload_field :image, size_info: "270x294" %>

It creates:

    <div class="col-lg-10 col-md-10">
      <label class="col-lg-2 col-md-2 control-label" for="object_image">Image</label><div class="col-lg-5 col-md-5"><div class="row"><div class="col-lg-12 col-md-12"><input class="form-control" id="object_image" name="object[image]" type="file"></div></div><div class="row"><div class="col-lg-12 col-md-12">Size should be 270x294</div></div></div><div class="col-lg-5 col-md-5"><div class="row"><div class="col-lg-12 col-md-12"><img alt="Name" src="/images/name.jpg" style="height: 80px;"></div></div></div>
    </div>

If you use another image handler than Paperclip, you can also pass <tt>image_url_method</tt> for image preview.

Also with remove_image action in controller and route for that,
it removes only image from object.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
