require 'mechanize'
require "rest_client"
require 'pry-nav'
require 'nokogiri'
require 'csv'

class Scraper 
	attr_reader :rows, :rsvps_page
	def initialize
		@rows = []
	end


	def fetch_page
			agent = Mechanize.new 
			page = agent.get("http://www.meetup.com/NYC-Data-Wranglers/events/208041132/surveyresults/")
			newpage = agent.get("https://secure.meetup.com/login/")
			logged_in_page = 	newpage.form_with(:id=>"loginForm") do |form| 
				form.field_with(:name=>"email").value = "my email"
				form.field_with(:name=>"password").value = "my password"
			end.submit
			@rsvps_page = agent.get("http://www.meetup.com/NYC-Data-Wranglers/events/208041132/surveyresults/").parser
	end

	def iterate_through_names
		rsvps_page.css('dd').each do |name|

			if name.text == "“”" || name.text == "“ ”"
				name = name.parent.parent.previous_element.css('strong')
			end

			name_array = name.text.gsub("“","").gsub("”","").strip.split(" ")
			first_name = name_array.first 
			last_name = name_array.last
			@rows << [last_name, first_name]
		end
	end			

	def write_into_CSV_file
		@rows.sort!
		@rows.unshift(["Last Name", "First Name"])
		CSV.open("spreadsheet.csv", "wb") do |csv|
			@rows.map do |line|
				csv << line
			end
		end
	end

end

a = Scraper.new
a.fetch_page
a.iterate_through_names
a.write_into_CSV_file
