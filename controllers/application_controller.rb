# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

# Base class for ActionController controllers
class ApplicationController
  extend T::Sig
  extend T::Helpers
  
  abstract!
end
