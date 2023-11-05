code = "XKCH"
res = Specimen.find_by_sql("SELECT * FROM specimen WHERE substring(tracking_number,1,4) ='#{code}'")
res.each do |order|    
    update = Specimen.find_by(:tracking_number => order.tracking_number)
    tracking_number_ = order.tracking_number.gsub(code,"XQCH")
    update.tracking_number = tracking_number_
    update.save
end
puts done