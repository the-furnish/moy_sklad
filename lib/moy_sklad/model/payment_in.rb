module MoySklad::Model
  class PaymentIn < MoySklad::Client::Base
    def initialize(*args)
      super(*args)
      create_nested_collection(:attribute)
      create_nested_resource(:sum)
    end
  end
end
