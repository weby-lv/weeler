class Post < ActiveRecord::Base

  has_many :translations
  accepts_nested_attributes_for :translations, :allow_destroy => true

  Image = Struct.new(:url) do
      def url(type = nil)
        type = "original" if type.blank?
        Rails.root.join("sample/#{type.to_s}.png")
      end
    end

  def image
    Image.new
  end

end
