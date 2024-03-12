//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Izaan Saleem on 05/03/2024.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}
struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    @State private var results: [Result] = []
    @State private var username = ""
    @State private var email = ""
    
    var disabledForm: Bool {
        username.count < 5 || email.count < 5
    }
    
    var body: some View {
        NavigationStack {
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Text("There was an error loading the image.")
                } else {
                    ProgressView()
                }
            }
            .frame(width: 100, height: 100)
            
            Form {
                Section {
                    TextField("Username", text: $username)
                    TextField("Email", text: $email)
                }
                
                Section {
                    Button("Create account") {
                        print("Creating")
                    }
                }
                .disabled(disabledForm)
            }
            /*AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"), scale: 12)
            
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)*/
                
            List(results, id: \.trackId) { item in
             VStack(alignment: .leading) {
             Text(item.trackName)
             .font(.headline)
             
             Text(item.collectionName)
             }
             }
             .task {
             await self.loadData()
             }
             .navigationTitle("Day 49/100")
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=zayn+malik&entity=song") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
