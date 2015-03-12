require 'csv'
require 'json'
require 'yaml'
class ImportExport
  class << self

    def export(file_name,format="json")
      data = import(file_name)
      case format
      when "json"
        data.to_json
      #extend the export format here
      #when "yml"
        #data.to_yaml
      else
        raise "unknown export format"
      end
    end

    def import(file_name)
      begin
        body = open(file_name).read 
        case File.extname(file_name)
        when ".csv" 
          from_csv(body)
          format_ruby_object(from_csv(body))
        #extend the import format here
        #when ".xml"
          #parse_xml(file_name)
        else 
          raise "unknown file extention"
        end
      rescue Exception => e  
        puts e.message  
        puts e.backtrace.inspect  
      end  
    end
    
    def format_ruby_object(data)
      data.each{|hash|
        #reformat the item_id and delete it
        hash["id"] = hash[:item_id].to_i 
        hash.delete(:item_id)
        
        hash[:price] = remove_currency_symbol(hash[:price]) if hash[:price]     
        hash[:cost] = remove_currency_symbol(hash[:cost]) if hash[:cost]     
        
        hash[:quantity_on_hand] = hash[:quantity_on_hand].to_i if hash[:quantity_on_hand] 

        #adding modifiers hash and delete the existing isolated modifiers
        hash[:modifiers] = format_modifiers(hash)    
        hash.keys.grep(/^modifier_/).each{|key| hash.delete(key)}
        #hash[:price] = nil unless hash[:price]  

      }
      data
    end

    def format_modifiers(hash)
      modifiers_keys = hash.keys.grep /^modifier/
      #return [] if all the modifiers are nil
      return [] if return_hash_array_values_from_keys_array(modifiers_keys,hash).all?{|v| v.nil?}
      # let's assume that modifiers always come by pair
      # so if we know the total number we can iterate over them and create a new modifiers array  
      modifiers = []
      1.upto(modifiers_keys.size/2) do |index|
        name  = "modifier_#{index}_name".to_sym
        price = "modifier_#{index}_price".to_sym
        modifiers << {"name" => hash[name],"price" => remove_currency_symbol(hash[price])}
      end
      modifiers
    end

    #could extend this method to handle more than one currency
    def remove_currency_symbol(s, currency="usd")
      case currency
      when "usd"
        s.gsub('$','').to_f
      end
    end
   
    def return_hash_array_values_from_keys_array(keys,hash)
      values =[]
      keys.each{|k| values << hash[k]  }
      values
    end
  

    def from_csv(body)
      csv = CSV.new(body,headers: true, :header_converters => :symbol)
      csv.to_a.map {|row| row.to_hash }
    end

    # implment from_xml here ...
  end
end
