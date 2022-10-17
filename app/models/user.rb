# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  api_guard_associations refresh_token: 'refresh_tokens'
  MINIMAL_AGE ||= 18

  enum role: {
    client: 0,
    musician: 1,
    musician_group: 2
  }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, presence: true
  validates :birth_date, presence: true
  validates :number_of_participants, numericality: { greater_than: 0 }, if: proc { _1.musician_group? }
  validate :age_restriction

  has_many :refresh_tokens, dependent: :delete_all

  private

  def age_restriction
    errors.add(:age, "- must be at least #{MINIMAL_AGE} y.o.") unless birth_date&.before?(MINIMAL_AGE.years.ago)
  end
end
