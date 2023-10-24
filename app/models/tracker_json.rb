class TrackerJson < ApplicationRecord
  serialize :data, JSON
end
