# ActiveResource base class
# All models shoud extend this class

module MoySklad::Client
  class Base < ActiveResource::Base
    self.site = "https://online.moysklad.ru/exchange/rest/ms/xml"
    self.format = Formatter.new
    self.user = MoySklad.username
    self.password = MoySklad.password
    self.auth_type = :basic
    self.include_format_in_path = false
    self.collection_parser = Collection

    @@template_path = File.join(File.dirname(__FILE__), '..', 'models', 'templates')

    class << self

      def find(*args)
        # Little trick for correct baseclass name
        self.format.element_name = element_name.classify
        super(*args)
      end

      # Custom path builder
      def element_path(id, prefix_options = {}, query_options = nil)
        check_prefix_options(prefix_options)

        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{element_name.classify}/#{URI.parser.escape id.to_s}#{query_string(query_options)}"
      end

      def new_element_path(prefix_options = {})
        "#{prefix(prefix_options)}#{element_name.classify}"
      end

      def collection_name
        @collection_name ||= "#{element_name.classify}/list"
      end

    end

    # Override create method, this required because moysklad uses PUT instead of POST
    def create
      run_callbacks :create do
        connection.put(new_element_path, encode, self.class.headers).tap do |response|
          self.id = id_from_response(response)
          load_attributes_from_response(response)
        end
      end
    end

    def destroy
      run_callbacks :destroy do
        connection.delete(self.class.element_path(uuid), self.class.headers)
      end
    end

    def save
      super
      self.error.is_a?(MoySklad::Client::Attribute::MissingAttr)
    end

    private

    # Custom data encoder
    # Template compiled only ONCE !!!
    def encode
      if !respond_to?(:create_xml)
        File.open(File.join("#{@@template_path}", "#{self.class.element_name}.builder")) do |f|
          template = f.read

          code = <<-END_CODE
            def create_xml
              builder = ::Nokogiri::XML::Builder.new(encoding: 'utf-8') do |xml|
                #{template}
              end.to_xml()
            end
          END_CODE

          self.class.module_eval(code)
        end
      end
      create_xml
    end

  end
end
