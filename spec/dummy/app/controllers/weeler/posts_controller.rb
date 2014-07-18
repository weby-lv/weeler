class Weeler::PostsController < Weeler::ContentController
  acts_as_restful Post, permit_attributes: [:title]
end
