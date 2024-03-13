//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Izaan Saleem on 05/03/2024.
//

import SwiftUI
import CoreHaptics

/*struct Response: Codable {
    var results: [Result]
}
struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}*/

struct ContentView: View {
    /*@State private var results: [Result] = []
    @State private var username = ""
    @State private var email = ""
    
    var disabledForm: Bool {
        username.count < 5 || email.count < 5
    }*/
    @State private var counter = 0
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        NavigationStack {
            Button("Tap Count: \(counter)") {
                counter += 1
            }.sensoryFeedback(.increase, trigger: counter)
            
            Button("Tap Count: \(counter)") {
                counter += 1
            }.sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: counter)
            
            Button("Tap Count: \(counter)") {
                counter += 1
            }.sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: counter)
            
            Button("Tap Me", action: complexSuccess)
                .onAppear(perform: prepareHaptics)
            /*AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { phase in
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
             .navigationTitle("Day 49/100")*/
        }
    }
    
    /*func loadData() async {
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
    }*/
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsAudio else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsAudio else { return }
        
        var events: [CHHapticEvent] = []
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }
        
        /*let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)*/
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

#Preview {
    ContentView()
}
