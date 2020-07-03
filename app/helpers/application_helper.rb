# frozen_string_literal: true

# Helper
module ApplicationHelper
  require 'securerandom'
  def random_reference(value)
    (SecureRandom.random_number * (10**10)).round.to_s.prepend(value)
  end
end
