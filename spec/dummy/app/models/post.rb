class Post < ActiveRecord::Base

  has_many :translations
  accepts_nested_attributes_for :translations, :allow_destroy => true

  Image = Struct.new(:url) do
      def url(type = nil)
        type = "original" if type.blank?
        "/images/#{type.to_s}.jpg"
      end
    end

  def image
    Image.new
  end

end
