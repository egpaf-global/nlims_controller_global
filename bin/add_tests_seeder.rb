
test_types = [[1,'SARS Cov 2','Sars RNA',7,'30 mins'],[2,'SARS COV-2 Rapid Antigen','Sars Rapid',7,'30 mins'],
                [3,'HPV','HPV',7,'1 hr']
            ]

puts 'loading test types--------------'
test_ids = {}
test_types.each do |t|	
   res = TestType.find_by(:name => t[1])
   res = TestType.create(name: t[1], short_name: t[2], test_category_id: t[3], targetTAT: t[4],description: '', prevalence_threshold: '') if res.blank?
   test_ids[res.id] = t[2]
end



specimen_types = [[1,'Nasopharyngeal swab']				]
puts 'loading specimen types--------------'
specimen_types.each do |sp|
    res = SpecimenType.find_by(:name => sp[1])
    SpecimenType.create(name:sp[1], description: '') if res.blank?
end

puts 'assignig test types to specimen types---------------------'
test_ids.each do |key, value|
    if value == "SARS Cov 2"
        res = SpecimenType.find_by(:name => "Swab")
        sample_id = res.id if !res.blank?
        TesttypeSpecimentype.create(test_type_id: key, specimen_type_id: sample_id) if !sample_id.blank?

        res = SpecimenType.find_by(:name => "Swabs")
        sample_id = res.id if !res.blank?
        TesttypeSpecimentype.create(test_type_id: key, specimen_type_id: sample_id) if !sample_id.blank?

        res = SpecimenType.find_by(:name => "Nasopharyngeal swab")
        sample_id = res.id if !res.blank?
        TesttypeSpecimentype.create(test_type_id: key, specimen_type_id: sample_id) if !sample_id.blank?

    elsif value == "SARS COV-2 Rapid Antigen"
        res = SpecimenType.find_by(:name => "Swab")
        sample_id = res.id if !res.blank?
        TesttypeSpecimentype.create(test_type_id: key, specimen_type_id: sample_id) if !sample_id.blank?

        res = SpecimenType.find_by(:name => "Swabs")
        sample_id = res.id if !res.blank?
        TesttypeSpecimentype.create(test_type_id: key, specimen_type_id: sample_id) if !sample_id.blank?

        res = SpecimenType.find_by(:name => "Nasopharyngeal swab")
        sample_id = res.id if !res.blank?
        TesttypeSpecimentype.create(test_type_id: key, specimen_type_id: sample_id) if !sample_id.blank?
    elsif value == "HPV"
        res = SpecimenType.find_by(:name => "Swab")
        sample_id = res.id if !res.blank?
        TesttypeSpecimentype.create(test_type_id: key, specimen_type_id: sample_id) if !sample_id.blank?

        res = SpecimenType.find_by(:name => "Swabs")
        sample_id = res.id if !res.blank?
        TesttypeSpecimentype.create(test_type_id: key, specimen_type_id: sample_id) if !sample_id.blank?

        res = SpecimenType.find_by(:name => "Blood")
        sample_id = res.id if !res.blank?
        TesttypeSpecimentype.create(test_type_id: key, specimen_type_id: sample_id) if !sample_id.blank?
    end
end


measures = [[1,'SARS'],[2,'COV-2'],[3,'HPV 16'],[4,'HPV 18_45'],[5,'OTHER HR HPV']]
puts 'loading measures--------------'
measure_key = {}
measures.each do |sp|
    res = Measure.find_by(:name => sp[1])
    res = Measure.create(name: sp[1],measure_type_id: 1,unit: "") if res.blank?
    measure_key[res.id] = sp[1] if !res.blank?
end

puts 'assignig measures to test types--------------------'
measure_key.each do |measure_id , measure_name|    
    test_ids.each do |key, value|
        if value == "SARS Cov 2" && measure_name == "SARS"
            TesttypeMeasure.create(test_type_id: key, measure_id: measure_id)
        elsif value == "SARS COV-2 Rapid Antigen" && measure_name == "COV-2"
            TesttypeMeasure.create(test_type_id: key, measure_id: measure_id)
        elsif value == "HPV" && measure_name == "HPV 16"
            TesttypeMeasure.create(test_type_id: key, measure_id: measure_id)
        elsif value == "HPV" && measure_name == "HPV 18_45"
            TesttypeMeasure.create(test_type_id: key, measure_id: measure_id)
        elsif value == "HPV" && measure_name == "OTHER HR HPV"
            TesttypeMeasure.create(test_type_id: key, measure_id: measure_id)
        end
    end
end