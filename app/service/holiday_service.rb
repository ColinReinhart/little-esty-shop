class HolidayService

  def self.find_holidays
    get_url("https://date.nager.at/api/v3/NextPublicHolidays/us")
  end

  def self.get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

end
