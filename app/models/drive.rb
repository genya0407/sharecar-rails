class BetweenDTO
  attr_reader :start_meter, :end_meter, :start_at, :end_at

  def initialize(start_meter, end_meter, start_at, end_at)
    @start_meter = start_meter
    @end_meter = end_meter
    @start_at = start_at
    @end_at = end_at
  end

  def lacking?
    end_meter != start_meter
  end

  def distance
    if !end_meter.nil? && !start_meter.nil?
      end_meter - start_meter
    else
      raise "Can't calculate distance"
    end
  end

  def attributes
    { start_meter: start_meter, end_meter: end_meter }
  end
end

class Drive < ApplicationRecord
  belongs_to :car
  belongs_to :user

  validates :start_meter, presence: true
  validates :car_id, presence: true
  validates :user_id, presence: true

  include OnlyChecked

  LATEST_COUNT = 10

  def self.last_meter(car_id)
    (where(car_id: car_id).maximum(:end_meter) || 0)
  end

  def self.in(start_at, end_at)
    where('? <= COALESCE(start_at, created_at) AND COALESCE(start_at, created_at) < ?', start_at, end_at)
  end

  def self.between(start_at, end_at)
    where.not('end_at <= ? OR ? <= start_at', start_at, end_at)
  end

  def self.not_end
    where(end_meter: nil)
  end

  def self.lackings
    target_drive = order(:start_meter).order(:end_meter).order(:created_at)
    target_drive.zip(target_drive.drop(1))
                .reverse.drop(1).reverse
                .map { |drive1, drive2| BetweenDTO.new(drive1.end_meter, drive2.start_meter, drive1.end_at, drive2.start_at) }
                .select(&:lacking?)
  end

  def self.lack_exist?
    !lackings.empty?
  end

  def self.latests
    order(start_meter: :desc).limit(LATEST_COUNT)
  end

  def distance
    if start_meter.present? && end_meter.present?
      end_meter - start_meter
    else
      raise "Can't calculate distance of the drive #{self.id}"
    end
  end

  def conflicted_drives
    self.car.drives.where.not(id: id).not_end.between(start_at, end_at)
  end
end