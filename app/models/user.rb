class User < ApplicationRecord
  has_secure_password
  MINIMAL_AGE ||= 18
  enum gender: {
    male: 0,
    female: 1,
  }
  enum role: {
    client: 0,
    musician: 1,
    musician_group: 2,
  }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, presence: true
  validates :birth_date, presence: true
  validates :gender, presence: true, if: Proc.new { _1.musician? }
  validates :number_of_participants, numericality: { greater_than: 0 }, if: Proc.new { _1.musician_group? }
  validate :age_restriction

  private

  def age_restriction
    errors.add(:age, "- must be at least #{MINIMAL_AGE} y.o.") unless birth_date&.before?(MINIMAL_AGE.years.ago)
  end
end
