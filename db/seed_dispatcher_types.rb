dispatcher_types = ['delivering_samples_to_molecular_lab','delivering_samples_to_district_hub','delivering_results_to_facility']


puts 'loading dispatcher types--------------'

dispatcher_types.each do |type|
   # tca = TestCategory.create(name: ca, description: '') 
    tca = SpecimenDispatchType.new
    tca.name = type
    tca.description = ""
    tca.save()
end
