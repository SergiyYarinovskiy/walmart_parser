class Review < ActiveRecord::Base
  belongs_to :reviews

  validates :data_content_id, uniqueness: true
  validates :name, :description, :data_content_id, presence: true

  def self.save(url, product_id)
    records = []
    @product_id = product_id
    html_doc = Nokogiri::HTML(open(url))
    html_doc.css('div.customer-review').each do |element|
      records << build_review(element)
    end
    # TODO: DRY
    (2..html_doc.css('div.paginator-list').first.css('li').size).to_a.each do |number|
      html_doc = Nokogiri::HTML(open(Review.build_review_url(url, number)))
      html_doc.css('div.customer-review').each do |element|
        records << build_review(element)
      end
    end
    Review.import(records) # duplicates and empty records will be rejected
  end

  private

  def self.build_review_url(url, number)
    url.query = "limit=20&page=#{number}&sort=relevancy"
    url
  end

  def self.build_review(element)
    Review.new(
      name: element.css('span.js-nick-name.customer-name-heavy').text.strip,
      description: element.css('div.customer-review-text').text.strip,
      data_content_id: element.attributes['data-content-id'].value.strip,
      product_id: @product_id
    )
  end
end
