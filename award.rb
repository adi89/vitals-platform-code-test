# Award = Struct.new(:name, :expires_in, :quality)
require 'pry-debugger'
require_relative 'award_type'

class Award
  include AwardType

  attr_reader :name
  attr_accessor :expires_in, :quality

  def initialize(name, expires_in, quality)
    @name = (name.is_a? String) ? name : stringify(name)
    @expires_in = integer_validation(expires_in)
    @quality = integer_validation(quality)
    @analysis_proc = Award.get_award_analysis(name)
  end

  def update_quality_data
    # if its_been_a_day_since_last_update
      @quality, @expires_in = @analysis_proc.call(@quality, @expires_in)
    # end
  end

  private

  def its_been_a_day_since_last_update
    now = today
    if (now - @last_update.to_i >= one_day ) || @last_update.nil?
      @last_update = now
      return true
    else
      return false
    end
  end

  def one_day
    86400
  end

  def today
    Time.now.to_i #in seconds
  end

  def integer_validation(parameter)
    raise "You must supply an integer" unless parameter.is_a? Integer
    return parameter
  end

  def stringify(name)
    name.to_s
  end

end
