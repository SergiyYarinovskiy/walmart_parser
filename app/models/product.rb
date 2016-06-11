class Product < ActiveRecord::Base
  has_many :reviews

  validates :name, uniqueness: true
  validates :name, :price, presence: true

  def self.save(url)
    return if !url || url.empty?
    html_doc = Nokogiri::HTML(open(url))
    # Price can be range ($90.00 - $95.00). Saving as string
    product = Product.new(name: html_doc.css('h1.product-name').text.strip,
                          price: html_doc.css('div.Price--large').text.strip)
    return unless product.valid? # returns if duplicate
    product.save
    Review.save(Product.build_reviews_url(
      url, html_doc.css('a.js-reviews-see-all')[0].attributes['href'].value
    ), product.id)
  end

  private
  # TODO: Move to lib
  def self.build_reviews_url(base_url, reviews_url)
    uri = URI(base_url)
    uri.scheme = 'https'
    uri.path = reviews_url
    uri
  end
end
