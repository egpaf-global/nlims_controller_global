class SpecimenType < ApplicationRecord


    def self.get_specimen_type_id(type)
      puts "################## #{type}"
      SpecimenType.find_by(name: type).id
    end

end
