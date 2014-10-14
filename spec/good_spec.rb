# coding: utf-8

require 'spec_helper'

PRICE_OLD = "131c74fb-1ee5-11e4-a138-002590a28eca"
PRICE_CUR = "bb7ec375-4ace-11e4-90a2-8eca001baadc"
PRICE_GRP = "9b0523cc-4ad0-11e4-90a2-8eca001c15b8"

describe 'Good type' do

  describe :index do
    it "should return list of items" do
      items = Moysklad::Models::Good.find(:all)
      expect(items.metadata[:total]).to eq(items.length)
      len = items.metadata[:total]

      # Newly update items, should be less then total
      items = Moysklad::Models::Good.find(:all, params: { filter:  "updated>20141014010000"})
      expect(items.metadata[:total]).to be < len
    end
  end

  describe :find do
    it "should return item with uuid 05eca138-3da6-11e4-0135-002590a28eca" do
      item = Moysklad::Models::Good.find("05eca138-3da6-11e4-0135-002590a28eca")
      expect(item.name).to eq("СТОЛИК КОКТЕЙЛЬНЫЙ ST.JAMES")
      expect(item.barcode.barcode).to eq("2000000004846")
      expect(item.uomUuid).to eq("19f1edc0-fc42-4001-94cb-c9ec9c62ec10")
    end
  end

  describe :update do
    it "should update item with uuid 05eca138-3da6-11e4-0135-002590a28eca" do
      item = Moysklad::Models::Good.find("05eca138-3da6-11e4-0135-002590a28eca")
      expect(item.buyPrice).to eq("0.0")
      item.buyPrice = "100.99"
      item.save

      item = Moysklad::Models::Good.find("05eca138-3da6-11e4-0135-002590a28eca")
      expect(item.buyPrice).to eq("100.99")
      item.buyPrice = "0.0"
      item.save

      item = Moysklad::Models::Good.find("05eca138-3da6-11e4-0135-002590a28eca")
      expect(item.buyPrice).to eq("0.0")
      expect(item.name).to eq("СТОЛИК КОКТЕЙЛЬНЫЙ ST.JAMES")
      item.buyPrice = "0.0"
      item.save
    end
  end

  describe :create do
    it "should create a new Good" do
      item = Moysklad::Models::Good.new
      item.name = "Just a test item, с русскими букавами in da name"
      item.description = "Отличный итем, шерстянной такой"
      item.externalcode = 'foo-bar-ext'
      item.code = 'foo-code'
      item.bullshit = 'xxx'
      item.save

      expect(item.uuid.length).to eq(36) # Should looks like real uuid

      uuid = item.uuid

      # Check item on server
      item = Moysklad::Models::Good.find(uuid)
      expect(item.uuid).to eq(uuid)

      # Remove item
      item.destroy

      expect{Moysklad::Models::Good.find(uuid)}.to raise_error(ActiveResource::ResourceNotFound)
    end

    it "should create item with salePrice" do
      item = Moysklad::Models::Good.new
      item.name = "Test item with custom prices"

      item.setSalePrice(PRICE_OLD, 155)
      item.setSalePrice(PRICE_CUR, 255)
      item.setSalePrice(PRICE_GRP, 355)

      item.save

      uuid = item.uuid

      item = Moysklad::Models::Good.find(uuid)

      item.name = "Foo Bar - test"
      item.setSalePrice(PRICE_OLD, 1000)
      item.setSalePrice(PRICE_CUR, 2000)
      item.setSalePrice(PRICE_GRP, 3000)
      item.save

      expect(item.getSalePrice(PRICE_OLD).value.to_f / 100).to eq(1000)

      item.destroy
    end
  end

end
