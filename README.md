

This is a script that collects the names of people RSVPed to our monthly data workshop on Meetup.com, since the doorman needs a list of names. I used Mechanize to log in to Meetup and click to the right page, then Nokogiri to parse the HTML string for just the names, then the Ruby CSV gem to put it into a CSV format.
