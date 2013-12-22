require 'nokogiri'
require 'date'
class ScrapeBlogspot
  def initialize(html)
      @doc = Nokogiri::HTML(html)
  end
  def title
    first = @doc.css('h3[itemprop~="name"]').first
    return first.text.strip if first
  end
  def content
    first = @doc.css('div[itemprop~="articleBody"]').first
    return first.inner_html.strip if first
  end
  def labels
    first = @doc.css('.post-labels').first
    return first.css("a[rel='tag']").map do |atag| atag.inner_html.strip end
  end
  def date_published
    first = @doc.css("[itemprop='datePublished']").first
    return DateTime.parse( first.attribute('title').value.strip)
  end
end
