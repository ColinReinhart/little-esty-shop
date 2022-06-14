class HolidayService

  def get_url
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def holidays
    get_url('https://date.nager.at/api/v3/NextPublicHolidays/united%2520states')
  end
  
end
