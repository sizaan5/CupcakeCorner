//
//  Order.swift
//  CupcakeCorner
//
//  Created by Izaan Saleem on 13/03/2024.
//

import Foundation

@Observable class Order {
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
}
