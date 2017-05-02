module RangeHelper
  class Faker::Time
    def self.between(from, to)
      rand(from..to)
    end
  end

  def end_in_range(has_range)
    start_at = has_range.start_at - rand(2..5).hour
    end_at = Faker::Time.between(has_range.start_at, has_range.end_at)
    return start_at, end_at
  end

  def start_in_range(has_range)
    start_at = Faker::Time.between(has_range.start_at, has_range.end_at)
    end_at = has_range.end_at + rand(2..5).hour
    return start_at, end_at
  end

  def cover_range(has_range)
    start_at = has_range.start_at - rand(2..5).hour
    end_at = has_range.end_at + rand(2..5).hour
    return start_at, end_at
  end

  def in_range(has_range)
    middle = Faker::Time.between(has_range.start_at, has_range.end_at)
    start_at = Faker::Time.between(has_range.start_at, middle)
    end_at = Faker::Time.between(middle, has_range.end_at)
    return start_at, end_at
  end
end