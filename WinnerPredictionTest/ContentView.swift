//
//  ContentView.swift
//  WinnerPredictionTest
//
//  Created by Vivek Singh on 01/03/24.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var team1 = "Chennai Super Kings"
    @State private var team2 = "Gujarat Titans"
    @State private var tossWinner = "Gujarat Titans"
    @State private var dayNight = "Night"
    @State private var tossDecision = "field"
    @State private var venue = "Narendra Modi Stadium, Ahmedabad"
    @State private var country = "India"
    @State private var city = "Ahmedabad" // Added city parameter
    @State private var winner: String?
    @State private var isLoading = false
    @State private var isAnimation = false
    
    var body: some View {
        ZStack {
            Image("cricket_ground")
                .resizable()
                .frame(width: 400)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.6)
            
            VStack {
                Text("IPL 2023 Final")
                    .font(.title)
                    .foregroundColor(.purple)
                    .padding()
                
                VStack(alignment: .leading, spacing: 20) {
                    InputField(label: "Team A:", text: $team1)
                    InputField(label: "Team B:", text: $team2)
                    InputField(label: "Toss Winner:", text: $tossWinner)
                    InputField(label: "Day/Night:", text: $dayNight)
                    InputField(label: "Toss Decision:", text: $tossDecision)
                    InputField(label: "Venue:", text: $venue)
                    InputField(label: "Country:", text: $country)
                    InputField(label: "City:", text: $city) // Added city input field
                }
                .padding()
                
                Button(action: predictWinner) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .foregroundColor(.white)
                    } else {
                        Text("Predict")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(isAnimation ? Color.green : Color.blue)
                            .cornerRadius(10)
                            .scaleEffect(isAnimation ? 1.1 : 1.0)
                            .onAppear {
                                withAnimation {
                                    self.isAnimation.toggle()
                                }
                            }
                    }
                }
                .disabled(isLoading)
                .padding()
                
                if let winner = winner {
                    Text("Winner")
                        .font(.title)
                        .padding()
                    Text("\(winner)")
                        .font(.title)
                }
            }
        }
    }
    
    func predictWinner() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let prediction = ipl2023WinnerPredict(team1: team1, team2: team2, tossWinner: tossWinner, dayNight: dayNight, tossDecision: tossDecision, venue: venue, country: country, city: city) {
                winner = prediction.winner
            } else {
                winner = "Prediction failed"
            }
            isLoading = false
        }
    }
}

struct InputField: View {
    var label: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.title3)
            TextField("", text: $text)
                .font(.title3)
        }
    }
}

func ipl2023WinnerPredict(team1: String, team2: String, tossWinner: String, dayNight: String, tossDecision: String, venue: String, country: String, city: String) -> Ipl2023MatchesTestOutput? {
    do {
        let config = MLModelConfiguration()
        let winnerModel = try Ipl2023MatchesTest(configuration: config)
        let winnerPrediction = try winnerModel.prediction(city: city, team1: team1, team2: team2, toss_winner: tossWinner, day_night: dayNight, toss_decision: tossDecision, venue: venue, country: country)
        return winnerPrediction
    } catch {
        return nil
    }
}

#Preview {
    ContentView()
}
