module AwardType

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods

    def get_award_analysis(name)
      name = generic_string(name)
      logic = Proc.new do |quality, expires_in|
        rate = modification_rate(name, expires_in)
        quality = updated_quality(name, quality, expires_in, rate)
        expires_in = updated_expires_in(name, expires_in)
        [quality , expires_in]
      end
    end

    protected

    def updated_quality(name, quality, expires_in, rate)
      quality =
      case name
      when 'blue first' then quality += rate
      when 'blue compare' then ((expires_in > 0) ? (quality+=rate) : 0)
      when 'blue distinction plus' then 80
      else quality -= rate
      end
      quality = minmax_rules(name, quality) unless name == 'blue distinction plus'
      return quality
    end

    def updated_expires_in(name, expires_in)
      (name == 'blue distinction plus') ? expires_in : (expires_in - 1)
    end

    def modification_rate(name, expires_in)
      case name
      when 'blue star' then blue_star_deprecation(expires_in)
      when 'blue compare' then blue_compare_deprecation(expires_in)
      when 'blue distinction plus' then 0
      else standard_deprecation(expires_in)
      end
    end

    def minmax_rules(name, quality)
      if quality > 50
        return 50
      end
      if quality < 0
        return 0
      end
      quality
    end

    private

    def blue_star_deprecation(expires_in)
      (expires_in > 0) ? 2*standard_rate : 4*standard_rate
    end

    def blue_compare_deprecation(expires_in)
      if expires_in > 10
        standard_rate
      elsif expires_in > 5
        2 * standard_rate
      else expires_in > 0
        3 * standard_rate
      end
    end

    def standard_deprecation(expires_in)
      (expires_in > 0) ? standard_rate : 2 * standard_rate
    end

    def standard_rate
      1
    end

    def generic_string(name)
      name.squeeze.downcase.strip
    end
  end

end