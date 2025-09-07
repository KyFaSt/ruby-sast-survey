# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

# Base class for ActiveRecord models
class ApplicationRecord
  extend T::Sig
  extend T::Helpers
  
  abstract!
end
