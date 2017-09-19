require "./lib/report_scraper"
require "./lib/weather_report"

require "./_env" if File.exist?("./_env.rb")

lat = ENV["WEATHER_LAT"]
lon = ENV["WEATHER_LON"]

if lat.nil? || lon.nil?
  puts "Location is not set."
  exit 1
end

token = ENV["SLACK_TOKEN"]
channel = ENV["SLACK_CHANNEL"]

if token.nil? || channel.nil?
  puts "Slack data is not set."
  exit 1
end

reports = ReportScraper.new(lat, lon).scrape_weather_report
if ARGV.first == "report"
  WeatherReport.new(token, channel).post_report(reports)
else
  p reports
end
