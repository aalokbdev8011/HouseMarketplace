namespace :scrap_web do
  CONFIG_FILE_PATH = Rails.root + "config/config.yml"
  SCRAPED_WEB_URL = "https://www.urhouse.com.tw/en/rentals"

  desc "TODO"
  task retrive_data: :environment do
    config = YAML.load_file(CONFIG_FILE_PATH)
    data = []

    (1..6).each do |page|
      response = (Faraday.get(SCRAPED_WEB_URL+"/ajax?page=#{page}&ordering=price&direction=ASC&mode=list"))
      data.concat(JSON.parse(response.body)['data']['items'])
    end

    residential_hashes = data.select { |hash| filtered_data(hash, config) }

    residential_hashes.each do |items|
      property = Property.create(
        title: items['title'],
        price: items['rent'],
        address: items['building_full_address'],
        city: items['city'],
        district: items['dist'],
        rooms: items['total_room'],
        mrt_station: items['road_address'],
        property_type: items['type'],
        image_url: items['image_watermarked']

      )
    end

  end

  def filtered_data(hash, config)
    lower_limit = config['rent_range']['lower_bound'] || '30000'
    upper_limit = config['rent_range']['upper_bound'] || '100000'
    city = config['city']
    districts = config['districts'] || []
    beds = config['beds']

    filter_checks = (hash['type'] == 'residential') && (hash['total_room'] <= beds) && (lower_limit..upper_limit).include?(hash['rent']) && (hash['city'] == city)

    districts.present? ? filter_checks && districts.include?{hash['dist']} : filter_checks
  end

end