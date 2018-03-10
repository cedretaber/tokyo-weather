class ReportScraper

  BASE_URL = "https://weathernews.jp/onebox/".freeze

  def initialize(lat, lon, base_url = nil)
    @lat = lat
    @lon = lon
    @url = "#{base_url || BASE_URL}#{lat}/#{lon}/temp=c"
  end

  def scrape_weather_report
    table = scribe_report_site @url
    parse_doc(table)
      .map { |arg| doc_to_hash(*arg) }
  end

  private

  require "open-uri"
  require "nokogiri"

  def scribe_report_site(url)

    res = open(url).read
    Nokogiri::HTML(res)
      .xpath('//table[@class="fcst-table-hourly"]')
      .first
  end

  def parse_doc(table)
    find_text = -> path { table.xpath(path).map { |e| e.children.first.text } }

    times = find_text.('//span[@class="fcst_hour"]')
    picts = table.xpath('//img[@class="fcst_wxicon"]').map { |e| e.attribute("src").text }.take(24)
    temps = find_text.('//span[@class="fcst_temp"]').map(&:to_i)
    rains = find_text.('//span[@class="fcst_rain"]').map(&:to_i)

    [times, picts, temps, rains].transpose
  end

  def doc_to_hash(time, pict, temp, rain)
    num = pict.match(/(\d+)\.png/)[1].to_i
    colour =
      case num
      when 100, 600
        '#cc6666'
      when 200
        '#666666'
      when 300
        '#6666cc'
      else
        '#000000'
      end
    {
      color: colour,
      title: time,
      text: "気温: #{temp}℃\n降水量: #{rain}mm/h",
      thumb_url: pict
    }
  end
end
