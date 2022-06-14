class HolidaySearch
  def self.create_holidays
    json = HolidayService.find_holidays
      wip = json.first(3).map do |data|
        Holiday.new(data)
      end
  end
end
