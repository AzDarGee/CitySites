require 'net/http'
require 'json'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'pp'

# ottawa_municipality = Municipality.find_or_create_by(name: 'Ottawa')
# guelph_municipality = Municipality.find_or_create_by(name: 'Guelph')

# Ward.find_or_create_by(name: 'Orleans', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Innes', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Barrhaven', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Kanata North', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'West Carleton-March', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Stittsville', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Bay', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'College', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Knoxdale-Merivale', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Gloucester-Southgate', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Beacon Hill-Cyrville', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Rideau-Vanier', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Rideau-Rockcliffe', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Somerset', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Kitchissippi', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'River', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Capital', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Alta Vista', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Cumberland', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Osgoode', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Rideau-Goulbourn', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Gloucester-South Nepean', municipality_id: ottawa_municipality.id)
# Ward.find_or_create_by(name: 'Kanata South', municipality_id: ottawa_municipality.id)


# answers = [
#   {
#     "type": "text",
#     "text": "happy times i love water springs are great and so useful!",
#     "field": {
#       "id": "42471743",
#       "type": "long_text"
#     }
#   },
#   {
#     "type": "text",
#     "text": "039475",
#     "field": {
#       "id": "42471734",
#       "type": "short_text"
#     }
#   },
#   {
#     "type": "text",
#     "text": "Sharon",
#     "field": {
#       "id": "42471732",
#       "type": "short_text"
#     }
#   },
#   {
#     "type": "choices",
#     "choices": {
#       "labels": [
#         "for my daily drinking water needs year round"
#       ]
#     },
#     "field": {
#       "id": "42471736",
#       "type": "multiple_choice"
#     }
#   },
#   {
#     "type": "text",
#     "text": "There are so many ways i can't even remember",
#     "field": {
#       "id": "42471738",
#       "type": "long_text"
#     }
#   }
# ]

# survey = CustomSurvey.find_by(typeform_id: 'HHlHgX')

# survey_response = SurveyResponse.create(response_body: answers,
#                                         custom_survey_id: 'HHlHgX')

# survey.survey_responses << survey_response if survey_response.valid?
# survey.save

# module MapData
#   extend self

#   @counter = 1
#   @wards = {
#     "1" => "ORLEANS",
#     "2" => "INNES",
#     "3" => "BARRHAVEN",
#     "4" => "KANATA NORTH",
#     "5" => "WEST CARLETON-MARCH",
#     "6" => "STITTSVILLE",
#     "7" => "BAY",
#     "8" => "COLLEGE",
#     "9" => "KNOXDALE-MERIVALE",
#     "10" => "GLOUCESTER-SOUTHGATE",
#     "11" => "BEACON HILL-CYRVILLE",
#     "12" => "RIDEAU-VANIER",
#     "13" => "RIDEAU-ROCKCLIFFE",
#     "14" => "SOMERSET",
#     "15" => "KITCHISSIPPI",
#     "16" => "RIVER",
#     "17" => "CAPITAL",
#     "18" => "ALTA VISTA",
#     "19" => "CUMBERLAND",
#     "20" => "OSGOODE",
#     "21" => "RIDEAU-GOULBOURN",
#     "22" => "GLOUCESTER-SOUTH NEPEAN",
#     "23" => "KANATA SOUTH"
#   }

#   def create_dev_site(dev_app_id)
#     begin
#       dev_site_json =  Net::HTTP.get_response URI('http://ottwatch.ca/api/devapps/'+dev_app_id)
#       dev_site = JSON.parse(dev_site_json.body)
#     rescue Exception => msg
#       puts msg.inspect
#     end


#     new_dev_site = DevSite.new(
#       description: dev_site['description'],
#       appID: dev_site['appid'],
#       devID: dev_site['devid'],
#       received_date: dev_site['receiveddate'],
#       updated: dev_site['updated'],
#       application_type: dev_site['apptype'],
#       ward_num: dev_site['ward'],
#       ward_name: @wards[dev_site['ward']]
#     )

#     dev_site['address'].each do |address|
#       new_dev_site.addresses.build(
#         lat: address['lat'],
#         lon: address['lon'],
#         geocode_lat: address['lat'],
#         geocode_lon: address['lon'],
#         street: address['addr'] + ', Ottawa, Ontario, Canada'
#       )
#     end

#     dev_site['statuses'].each do |status|
#       new_dev_site.statuses.build(
#         status_date: status['statusdate'],
#         status: status['status'],
#         created: status['created']
#       )
#     end

#     dev_site['files'].each do |file|
#       new_dev_site.city_files.build(
#         name: file['title'],
#         link: file['href'],
#         orig_created: file['created'],
#         orig_update: file['updated']
#       )
#     end

#     begin
#       if new_dev_site.save
#         puts @counter
#         puts "Saved application - #{dev_site['devid']}"
#         @counter += 1
#       else
#         puts "Did not save - #{dev_site['devid']}"
#       end
#     rescue Exception => msg
#       puts 'Error retrieving new dev site'
#       puts msg.inspect
#     end

#   end

#   def update_dev_site(current_dev_site)
#     begin
#       dev_site_json =  Net::HTTP.get_response URI('http://ottwatch.ca/api/devapps/'+current_dev_site.devID)
#       dev_site = JSON.parse(dev_site_json.body)
#     rescue Exception => msg
#       puts 'Error retrieving updated dev site'
#       puts msg.inspect
#     end

#     if current_dev_site.updated == dev_site['updated']
#       puts @counter
#       puts "Latest application - #{dev_site['devid']}"
#       @counter += 1
#       return
#     end

#     current_dev_site.update(
#       description: dev_site['description'],
#       appID: dev_site['appid'],
#       devID: dev_site['devid'],
#       received_date: dev_site['receiveddate'],
#       updated: dev_site['updated'],
#       application_type: dev_site['apptype'],
#       ward_num: dev_site['ward'],
#       ward_name: @wards[dev_site['ward']]
#     )

#     current_dev_site.addresses.destroy_all
#     current_dev_site.statuses.destroy_all
#     current_dev_site.city_files.destroy_all

#     dev_site['address'].each do |address|
#       current_dev_site.addresses.build(
#         lat: address['lat'],
#         lon: address['lon'],
#         geocode_lat: address['lat'],
#         geocode_lon: address['lon'],
#         street: address['addr'] + ', Ottawa, Ontario, Canada'
#       )
#     end

#     dev_site['statuses'].each do |status|
#       current_dev_site.statuses.build(
#         status_date: status['statusdate'],
#         status: status['status'],
#         created: status['created']
#       )
#     end

#     dev_site['files'].each do |file|
#       current_dev_site.city_files.build(
#         name: file['title'],
#         link: file['href'],
#         orig_created: file['created'],
#         orig_update: file['updated']
#       )
#     end

#     begin
#       if current_dev_site.save
#         puts @counter
#         puts "Updated application - #{dev_site['devid']}"
#         @counter += 1
#       else
#         puts "Did not save - #{dev_site['devid']}"
#       end
#     rescue Exception => msg
#       puts msg.inspect
#     end
#   end

#   puts 'Retrieving all dev sites from ottwatch'

#   begin
#     dev_sites_json = Net::HTTP.get_response URI('http://ottwatch.ca/api/devapps/all')
#     dev_sites = JSON.parse(dev_sites_json.body)
#   rescue Exception => msg
#     puts 'Error retrieving dev sites from ottwatch'
#     puts msg.inspect
#   end

#   dev_site_ids = dev_sites.map { |dev_site| dev_site['devid'] }

#   dev_site_ids.first(50).each do |dev_site_id|
#     dev_site = DevSite.find_by(devID: dev_site_id)
#     dev_site.present? ? update_dev_site(dev_site) : create_dev_site(dev_site_id)
#   end

# end


# 1. Search all Apps
# 2. Go to each app on page and extract information
# 3. If next page, go to next page and repeat step 2.

SEARCH_RESULTS_URL = 'https://app01.ottawa.ca/postingplans/searchResults.jsf?lang=en&newReq=true&action=qs&keyword=kanata'
search_results_page = Nokogiri::HTML(open(SEARCH_RESULTS_URL))


# ON SEARCH RESULTS PAGE

def getApplicationLinks(doc)
    links = Hash.new {|h,k| h[k] = h.class.new(&h.default_proc) }
    counter = 0
    # AppID, DevID, AppIDLinks
    doc.xpath('//a[@class="app_applicationlink"]').each do |link|
        url =link.attributes['href'].value
        appID = /appId=(.*)/.match(url).captures
        links[counter]['appID'] = appID[0]
        links[counter]['devID'] = link.inner_html.strip
        links[counter]['appIDUrl'] = url
        counter += 1
    end
    pp links
end

def getSingleDevApplication(url)
    doc = Nokogiri::HTML(open(url))
end

def getAddress(doc)
    doc.xpath('//a[@target="_geoottawa"]', '//a[@target="_geoottawa/@href"]').each do |link|
        puts link.content
    end
end

def next_page(doc)

end

getApplicationLinks(search_results_page)