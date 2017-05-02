module RangeHelper
  class Faker::Time
    def self.between(from, to)
      rand(from..to)
    end
  end

  def end_in_range(has_range)
    start_at = (has_range.start_at - rand(5..10).hour).change(minute: 0)
    end_at = Faker::Time.between(has_range.start_at, has_range.end_at).change(minute: 0)
    return start_at, end_at
  end

  def start_in_range(has_range)
    start_at = Faker::Time.between(has_range.start_at, has_range.end_at).change(minute: 0)
    end_at = (has_range.end_at + rand(5..10).hour).change(minute: 0)
    return start_at, end_at
  end

  def cover_range(has_range)
    start_at = (has_range.start_at - rand(5..10).hour).change(minute: 0)
    end_at = (has_range.end_at + rand(5..10).hour).change(minute: 0)
    return start_at, end_at
  end

  def in_range(has_range)
    middle = Faker::Time.between(has_range.start_at, has_range.end_at)
    start_at = Faker::Time.between(has_range.start_at, middle).change(minute: 0)
    end_at = Faker::Time.between(middle, has_range.end_at).change(minute: 0)
    return start_at, end_at
  end
end