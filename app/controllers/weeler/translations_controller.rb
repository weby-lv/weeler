module Weeler
  class TranslationsController < BaseController
    def index
      @translations = I18n::Backend::Weeler::Translation.all
    end
    def show
    end
  end
end