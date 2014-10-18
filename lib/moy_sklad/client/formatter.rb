# Custom formatter
# Used only on retrive process. Submission encoder live in base.rb

require 'active_resource'
require 'active_support/core_ext/hash/conversions'

module MoySklad::Client
  class Formatter
    include ::ActiveResource::Formats::XmlFormat

    attr_accessor :element_name

    def decode(_data)
      data = Hash.from_xml(_data)

      if data.has_key?('collection')
        collection(data)
      else
        {data.keys.first.underscore => data.values.first}
      end
    end

    def _data(data)
      { data: data, object: element_name[0].downcase + element_name[1..-1] }
    end

    if ActiveResource::VERSION::STRING < '4.0.0'
      def collection(data)
        MoySklad::Client::Collection.new(_data(data))
      end
    else
      def collection(data)
        _data(data)
      end
    end
  end
end
