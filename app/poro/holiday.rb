class Holiday
  attr_reader :name, :date

  def initialize(parsed_holiday)
    @name = parsed_holiday[:name]
    @date = parsed_holiday[:date]
  end
end
