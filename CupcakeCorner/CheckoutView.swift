//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Izaan Saleem on 20/03/2024.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    @State private var alertTitle = ""
    @State private var confirmationMessage = ""
    @State private var showingConfirmation: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    AsyncImage(url: URL(string: "https://png.pngtree.com/background/20230525/original/pngtree-sweet-pink-cupcake-on-wooden-table-picture-image_2731023.jpg"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 233)
                    
                    VStack(alignment: .leading) {
                        Text("Name: \(order.name)")
                            .font(.headline)
                        Text("Delivery address: \(order.streetAddress) \(order.city) \(order.zip)")
                            .font(.caption)
                    }.padding()
                    
                    Text("Your total is \(order.cost, format: .currency(code: "PKR"))")
                        .font(.title3)
                        .padding()
                    
                    
                    Button("Place Order") {
                        Task {
                            await placeOrder()
                        }
                    }
                    .frame(width: 300)
                    .padding()
                    .background(.black.opacity(0.85).gradient)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 10))
                }
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .scrollBounceBehavior(.basedOnSize)
            .alert(alertTitle, isPresented: $showingConfirmation) {
                Button("OK") {}
            } message: {
                Text(confirmationMessage)
            }
        }
    }
    
    func placeOrder() async {
        guard let encode = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encode)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            self.alertTitle = "Thank you!"
            self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            self.showingConfirmation = true
        } catch {
            print("Check out failed: \(error.localizedDescription)")
            self.alertTitle = "Oops!"
            self.confirmationMessage = "Check out failed: \(error.localizedDescription)"
            self.showingConfirmation = true
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
