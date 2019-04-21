require 'csv'
require 'open-uri'

# force all downloads to be temp file instead of StringIo
OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
OpenURI::Buffer.const_set 'StringMax', 0

countries = []
brands = []

def addUniqueValue(value, arr) 
  existing_value = arr.include? value
  if !existing_value
    arr.push(value)
  end
end

def safe_open(imageUrl)
  begin
    return URI.open(imageUrl)
  rescue => e
    p e.message + imageUrl
    # use stock image
    return URI.open("#{Rails.root}/app/assets/images/placeholder.jpg")
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'challenge_data.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  # find all countries and brands
  addUniqueValue(row['country'], countries)
  addUniqueValue(row['brand'], brands)
end

# create countries and brands
countries.each do |country|
  Country.create(name: country)
end

brands.each do |brand|
  Brand.create(name: brand)
end

puts "There are now #{Country.count} rows in the country table"
puts "There are now #{Brand.count} rows in the brand table"

# create ads
csv.each do |row|
  # grab active record obj
  country = Country.find_by(name: row['country'])
  brand = Brand.find_by(name: row['brand'])
  ad = Ad.create(title: row['title'], country_id: country.id, brand_id: brand.id)
  
  # attach image to ad
  imageUrl = row['img']
  filename = File.basename(URI.parse(imageUrl).path)

  # use safe open function to handle 404
  file = safe_open(imageUrl)

  # attach image
  p 'attaching ' + filename
  ad.image.attach(io: file, filename: filename)
end

puts "There are now #{Ad.count} rows in the Ad table"
