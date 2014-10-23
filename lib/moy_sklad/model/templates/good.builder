xml.good(name: name, archived: archived, parentUuid: parentUuid, productCode: productCode,
         vat: vat, minPrice: minPrice, uomUuid: uomUuid, countryUuid: countryUuid,
         supplierUuid: supplierUuid, salePrice: salePrice, saleCurrencyUuid: saleCurrencyUuid,
         buyCurrencyUuid: buyCurrencyUuid, isSerialTrackable: isSerialTrackable, buyPrice: buyPrice,
         minimumBalance: minimumBalance, weight: weight, volume: volume) {

  xml.accountUuid_  accountUuid
  xml.accountId_    accountId
  xml.uuid_         uuid
  xml.groupUuid_    groupUuid
  xml.deleted_      deleted
  xml.code_         code
  xml.externalcode_ externalcode
  xml.description_  description

  to_a(:attribute).each do |a|
    xml.attribute(metadataUuid: a.metadataUuid, valueText: a.valueText, valueString: a.valueString,
                  doubleValue: a.doubleValue, longValue: a.longValue, booleanValue: a.booleanValue,
                  timeValue: a.timeValue, entityValueUuid: a.entityValueUuid, agentValueUuid: a.agentValueUuid,
                  goodValueUuid: a.goodValueUuid, placeValueUuid: a.placeValueUuid, consignmentValueUuid: a.consignmentValueUuid,
                  contractValueUuid: a.contractValueUuid, projectValueUuid: a.projectValueUuid, employeeValueUuid: a.employeeValueUuid,
                  goodUuid: a.goodUuid) {

      xml.accountUuid_  a.accountUuid
      xml.accountId_    a.accountId
      xml.uuid_         a.uuid
      xml.groupUuid_    a.groupUuid
      xml.deleted_      a.deleted
      a.to_a(:file).each do |f|
        xml.file(name: f.name, created: f.created, filename: f.filename, miniatureUuid: f.miniatureUuid) {

          xml.accountUuid_  f.accountUuid
          xml.accountId_    f.accountId
          xml.uuid_         f.uuid
          xml.groupUuid_    f.groupUuid
          xml.deleted_      f.deleted
          xml.code_         f.code
          xml.externalcode_ f.externalcode
          xml.description_  f.description
          xml.contents_     f.contents
        }
      end
    }
  end

  xml.barcode(barcode: barcode.barcode, barcodeType: barcode.barcodeType) {
    xml.accountUuid_  barcode.accountUuid
    xml.accountId_    barcode.accountId
    xml.uuid_         barcode.uuid
    xml.groupUuid_    barcode.groupUuid
  } unless xml.barcode.empty?

  xml.salePrices {
    salePrices.to_a(:price).each do |p|
      xml.price(currencyUuid: p.currencyUuid, priceTypeUuid: p.priceTypeUuid, value: p.value) {
        xml.accountUuid_  p.accountUuid
        xml.accountId_    p.accountId
        xml.uuid_         p.uuid
        xml.groupUuid_    p.groupUuid
      }
    end
  }

  to_a(:pack).each do |p|
    xml.pack(quantity: p.quantity, uomUuid: p.uomUuid) {
      xml.accountUuid_  p.accountUuid
      xml.accountId_    p.accountId
      xml.uuid_         p.uuid
      xml.groupUuid_    p.groupUuid
    }
  end

  xml.preferences {
    to_a(:preference).each do |p|
      xml.preference(slotUuid: p.slotUuid) {
        xml.accountUuid_  p.accountUuid
        xml.accountId_    p.accountId
        xml.uuid_         p.uuid
        xml.groupUuid_    p.groupUuid
      }
    end
  }
}