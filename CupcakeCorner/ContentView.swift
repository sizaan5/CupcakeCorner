//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Izaan Saleem on 05/03/2024.
//

import SwiftUI

@Observable class User: Codable {
    enum CodingKeys: String, CodingKey {
        case _name = "name"
    }
    var name = "Izaan"
}

struct ContentView: View {
    
    var body: some View {
        Button("Encode Izaan", action: encodeIzaan)
    }
    
    func encodeIzaan() {
        let data = try! JSONEncoder().encode(User())
        let str = String(decoding: data, as: UTF8.self)
        print(str)
    }
}

#Preview {
    ContentView()
}
