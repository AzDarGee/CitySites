require 'net/http'
require 'json'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'pp'

# # ottawa_municipality = Municipality.find_or_create_by(name: 'Ottawa')
# # guelph_municipality = Municipality.find_or_create_by(name: 'Guelph')

# # Ward.find_or_create_by(name: 'Orleans', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Innes', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Barrhaven', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Kanata North', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'West Carleton-March', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Stittsville', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Bay', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'College', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Knoxdale-Merivale', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Gloucester-Southgate', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Beacon Hill-Cyrville', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Rideau-Vanier', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Rideau-Rockcliffe', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Somerset', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Kitchissippi', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'River', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Capital', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Alta Vista', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Cumberland', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Osgoode', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Rideau-Goulbourn', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Gloucester-South Nepean', municipality_id: ottawa_municipality.id)
# # Ward.find_or_create_by(name: 'Kanata South', municipality_id: ottawa_municipality.id)


# # answers = [
# #   {
# #     "type": "text",
# #     "text": "happy times i love water springs are great and so useful!",
# #     "field": {
# #       "id": "42471743",
# #       "type": "long_text"
# #     }
# #   },
# #   {
# #     "type": "text",
# #     "text": "039475",
# #     "field": {
# #       "id": "42471734",
# #       "type": "short_text"
# #     }
# #   },
# #   {
# #     "type": "text",
# #     "text": "Sharon",
# #     "field": {
# #       "id": "42471732",
# #       "type": "short_text"
# #     }
# #   },
# #   {
# #     "type": "choices",
# #     "choices": {
# #       "labels": [
# #         "for my daily drinking water needs year round"
# #       ]
# #     },
# #     "field": {
# #       "id": "42471736",
# #       "type": "multiple_choice"
# #     }
# #   },
# #   {
# #     "type": "text",
# #     "text": "There are so many ways i can't even remember",
# #     "field": {
# #       "id": "42471738",
# #       "type": "long_text"
# #     }
# #   }
# # ]

# # survey = CustomSurvey.find_by(typeform_id: 'HHlHgX')

# # survey_response = SurveyResponse.create(response_body: answers,
# #                                         custom_survey_id: 'HHlHgX')

# # survey.survey_responses << survey_response if survey_response.valid?
# # survey.save

# @wards = {
# "1" => "ORLEANS",
# "2" => "INNES",
# "3" => "BARRHAVEN",
# "4" => "KANATA NORTH",
# "5" => "WEST CARLETON-MARCH",
# "6" => "STITTSVILLE",
# "7" => "BAY",
# "8" => "COLLEGE",
# "9" => "KNOXDALE-MERIVALE",
# "10" => "GLOUCESTER-SOUTHGATE",
# "11" => "BEACON HILL-CYRVILLE",
# "12" => "RIDEAU-VANIER",
# "13" => "RIDEAU-ROCKCLIFFE",
# "14" => "SOMERSET",
# "15" => "KITCHISSIPPI",
# "16" => "RIVER",
# "17" => "CAPITAL",
# "18" => "ALTA VISTA",
# "19" => "CUMBERLAND",
# "20" => "OSGOODE",
# "21" => "RIDEAU-GOULBOURN",
# "22" => "GLOUCESTER-SOUTH NEPEAN",
# "23" => "KANATA SOUTH"
# }


# # 1. Search all Apps
# # 2. Go to each app on page and extract information
# # 3. If next page, go to next page and repeat step 2.

SEARCH_RESULTS_URL = 'https://app01.ottawa.ca/postingplans/searchResults.jsf?lang=en&newReq=true&action=qs&keyword=kanata'
APPLICATION_PAGE_URI = 'https://app01.ottawa.ca/postingplans/appDetails.jsf?lang=en&appId='
search_results_page = Nokogiri::HTML(open(SEARCH_RESULTS_URL))
appLink = search_results_page.xpath('//a[@class="app_applicationlink"]').first.attributes['href'].value
jSESSION_ID = /;jsessionid=(.*)\?/.match(appLink).captures[0]


def getApplicationLinks(doc, jSESSION_ID)
    links = Hash.new {|h,k| h[k] = h.class.new(&h.default_proc) }
    page = 1
    nextPageURI = doc.xpath('//div[@class="searchpaging"]/a[last()]/@href').pop.value
    nextPageURL = 'https://app01.ottawa.ca' + nextPageURI
    nextPageNum = /=(\d*)$/.match(nextPageURI).captures[0].to_i
    links['jSessionID'] = jSESSION_ID

    # Check if on the last page
    if nextPageNum < page
        return links 
    end
    
    # AppID, DevID, AppIDLinks
    doc.xpath('//a[@class="app_applicationlink"]').each do |data|
        url = 'https://app01.ottawa.ca/postingplans/' + data.attributes['href'].value
        appID = /appId=(.*)/.match(url).captures[0]
        links[page]['data']['appID'] = appID
        links[page]['data']['devID'] = data.inner_html.strip
        links[page]['data']['pureUrl'] = APPLICATION_PAGE_URI + appID
        links[page]['data']['appURL'] = url
        page += 1

    end

    links[page]['nextPage'] = nextPageNum

    nextPageDoc = Nokogiri::HTML(open(nextPageURL))
    
    
    links
end

def getDevApplication(url)
    doc = Nokogiri::HTML(open(url))
    getAddress(doc)
    getDateAppRecieved(doc)
    getWard(doc)
    getCityCouncillor(doc)
    getApplicationType(doc)
    getStatus(doc)
    getDescription(doc)
    getFileLead(doc)
    getFiles(doc)
end

def getAddress(doc)
    return doc.xpath('//a[@target="_geoottawa"]').each { |link| link.content }
end

def getDateAppRecieved(doc)

end

def next_page(doc)

end

def crawlData
end


counter = 0
data = getApplicationLinks(search_results_page, jSESSION_ID)


binding.pry


