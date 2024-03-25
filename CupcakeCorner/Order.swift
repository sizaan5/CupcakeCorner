//
//  Order.swift
//  CupcakeCorner
//
//  Created by Izaan Saleem on 13/03/2024.
//

import Foundation

@Observable class Order: Codable {
    
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
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }
    
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
