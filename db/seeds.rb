# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


url = "https://github.com/public-apis/public-apis"
parsed_page = Nokogiri::HTML(HTTParty.get(url))

# Get categories from the ul at the top
categories = parsed_page.xpath('/html/body/div[4]/div/main/div[2]/div/div/div/article/ul/li/a')

# categories.each do |cat|
#    Category.create(name: cat.text)
# end

# Get all tables from the page
tables = parsed_page.xpath('/html/body/div[4]/div/main/div[2]/div/div/div/article/table')
rows = []

categories.each_with_index do |cat, index|
    tables[index].search('tbody tr').each do |tr|
        cells = tr.search('td')
        link = ''
        values = []
        row = {
            'name' => '',
            'description' => '',
            'auth' => '',
            'https' => '',
            'cors' => '',
            'category_id' => '',
            'url' => ''
        }

        cells.css('a').each do |a|
            link += a['href']
        end

        cells.each do |cell|
            values << cell.text
        end
        
        values << index+1
        values << link
        rows << row.keys.zip(values).to_h
    end
end
binding.pry