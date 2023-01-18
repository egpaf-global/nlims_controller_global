file_sites = JSON.parse(File.read(Rails.root.join('db','seed_files','sites.json')))

file_sites.each do |f_site|
    site = Site.where(site_code_number: f_site['site_code_number'], district: f_site['district']).take
    if !site.nil? 
        site.update(name: f_site['name'])
    else
        #Site.create(f_site)
    end
end
