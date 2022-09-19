recepient_types = ['test_results_delivered_to_site_manually','test_results_delivered_to_site_electronically']


puts 'loading recepient types--------------'

recepient_types.each do |type|
   # tca = TestCategory.create(name: ca, description: '') 
    chk = TestResultRecepientType.find_by(name: type)  
    if !chk.blank?
        puts "#{type} already seeded"
    else
        tca = TestResultRecepientType.new
        tca.name = type
        tca.description = ""
        tca.save()
        puts "#{type} seeded successfuly"
    end
end
