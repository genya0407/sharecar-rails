module RangeHelper
  def end_in_range(has_range)
    start_at = (has_range.start_at - rand(5..10).hour).change(minute: 0)
    end_at = Faker::Time.between(from: has_range.start_at, to: has_range.end_at).change(minute: 0)
    [start_at, end_at]
  end

  def start_in_range(has_range)
    start_at = Faker::Time.between(from: has_range.start_at, to: has_range.end_at).change(minute: 0)
    end_at = (has_range.end_at + rand(5..10).hour).change(minute: 0)
    [start_at, end_at]
  end

  def cover_range(has_range)
    start_at = (has_range.start_at - rand(5..10).hour).change(minute: 0)
    end_at = (has_range.end_at + rand(5..10).hour).change(minute: 0)
    [start_at, end_at]
  end

  def in_range(has_range)
    middle = Faker::Time.between(from: has_range.start_at, to: has_range.end_at)
    start_at = Faker::Time.between(from: has_range.start_at, to: middle).change(minute: 0)
    end_at = Faker::Time.between(from: middle, to: has_range.end_at).change(minute: 0)
    [start_at, end_at]
  end
end
