//
//  Order.swift
//  CupcakeCorner
//
//  Created by Izaan Saleem on 13/03/2024.
//

import Foundation

@Observable class Order: Codable {
    
    init() {}
    
    // Custom encoding implementation to exclude specific properties
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: ._type)
        try container.encode(quantity, forKey: ._quantity)
        try container.encode(specialRequestEnabled, forKey: ._specialRequestEnabled)
        try container.encode(extraFrosting, forKey: ._extraFrosting)
        try container.encode(addSprinkles, forKey: ._addSprinkles)
        // Exclude 'name', 'city', 'streetAddress', and 'zip' from encoding
    }
    
    // Custom decoding implementation to exclude specific properties
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(Int.self, forKey: ._type)
        quantity = try container.decode(Int.self, forKey: ._quantity)
        specialRequestEnabled = try container.decode(Bool.self, forKey: ._specialRequestEnabled)
        extraFrosting = try container.decode(Bool.self, forKey: ._extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: ._addSprinkles)
        // Exclude decoding for 'name', 'city', 'streetAddress', and 'zip'
        name = ""
        city = ""
        streetAddress = ""
        zip = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Mango"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
//    var name = ""
//    var streetAddress = ""
//    var city = ""
//    var zip = ""
    var name: String {
        get {
            return UserDefaults.standard.string(forKey: "name") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "name")
            self.updateHasValidAddress()
        }
    }
    var streetAddress: String {
        get {
            return UserDefaults.standard.string(forKey: "streetAddress") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "streetAddress")
            self.updateHasValidAddress()
        }
    }
    var city: String {
        get {
            return UserDefaults.standard.string(forKey: "city") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "city")
            self.updateHasValidAddress()
        }
    }
    var zip: String {
        get {
            return UserDefaults.standard.string(forKey: "zip") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "zip")
            self.updateHasValidAddress()
        }
    }
    
    var hasValidAddressOld: Bool {
        /*if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }*/
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || 
            streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        return true
    }
    
    private func updateHasValidAddress() {
        hasValidAddress = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var hasValidAddress = false
    
    var cost: Decimal {
        //$2 per cake
        var cost = Decimal(quantity * 200)
        
        //complicated cake
        cost += Decimal(type/200)
        
        //$1/cake for extra froasting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        //$.5/cake for extra sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 200
        }
        return cost
    }
}
