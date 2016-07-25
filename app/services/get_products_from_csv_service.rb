class GetProductsFromCsvService

  require 'csv'


  def self.get_codes(filename_read)

    csv_options_read = {
         col_sep: "\t",
         row_sep: :auto,
         quote_char: '"',
         headers: :first_row
    }
    filepath_read = "../db/#{filename_read}"
    # filepath_read    = 'db/fr.openfoodfacts.org.products.csv'  # Relative to current file

    csv_options_write = {
         col_sep: ',',
         force_quotes: true,
         quote_char: '"'
    }

    filepath_write    = "../db/codes_from_#{filename_read}"


    all_barcodes =[]
    codes_array = []
    start_position = 0



    # TODO #
    # importer dernier code du csv codes
    last_code = CSV.read(filepath_write, csv_options_write).last
    csv_text = File.read(filepath_read, csv_options_read)
    start_position = csv_text.index(last_code.first) + 13 unless last_code.nil? || last_code.empty?
    if start_position == 0
      CSV.open(filepath_write, 'wb', csv_options_write) do |row|
        row << ['code']
      end
    end
    # rechercher ce code dans le big csv et donner l'index à start_position
    # reprendre l'extraction
    #
    # ouvrir le fichier de codes
    # pour chaque code chercher le produit dans l'API
    # créer les objets



    until csv_text.match(/\d{13}/, start_position).nil? do
      barcode = csv_text.match(/\d{13}/, start_position) unless csv_text.match(/\d{13}/, start_position).nil?
      codes_array << barcode.to_s unless codes_array.last == barcode.to_s
      start_position = csv_text.index(/\d{13}/, start_position) + 13
      puts start_position
    end


    CSV.open(filepath_write, 'ab', csv_options_write) do |csv|
      codes_array.each do |csv_item|
        csv << [csv_item]
      end
    end
  end

  def self.create_products_from_codes(filename_codes)
    csv_options = {
     col_sep: ',',
     force_quotes: true,
     quote_char: '"',
     headers: :first_row
    }

    filepath_codes = Rails.root.join("db").join(filename_codes).to_s

    CSV.foreach(filepath_codes, csv_options) do |row|

      product = Openfoodfacts::Product.get(row['code'])
      if product
        product.fetch
        Product.create_from_api(product) # creates a product and creates ingredients if new
      end
    end
  end

end
