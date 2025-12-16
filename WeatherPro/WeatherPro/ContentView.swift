//
//  ContentView.swift
//  WeatherPro
//
//  Created by Can Arda on 16.12.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var cityName = "Dusseldorf"
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Search Bar
                        HStack {
                            TextField("Enter city name", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.words)
                            
                            Button("Search") {
                                if !searchText.isEmpty {
                                    cityName = searchText
                                    Task {
                                        await viewModel.fetchWeather(for: cityName)
                                        await viewModel.fetchForecast(for: cityName)
                                    }
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        
                        // Loading / Error / Weather Data
                        if viewModel.isLoading {
                            ProgressView("Loading...")
                                .tint(.white)
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding()
                        } else if let weather = viewModel.weatherData {
                            // Current Weather Card
                            VStack(spacing: 15) {
                                Text(weather.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                
                                Image(systemName: viewModel.weatherIcon(for: weather.weather.first?.id ?? 800))
                                    .font(.system(size: 80))
                                    .foregroundColor(.white)
                                
                                Text("\(Int(weather.main.temp))°C")
                                    .font(.system(size: 60))
                                    .fontWeight(.thin)
                                
                                Text(weather.weather.first?.description.capitalized ?? "")
                                    .font(.title2)
                                
                                HStack(spacing: 40) {
                                    VStack {
                                        Image(systemName: "drop.fill")
                                        Text("\(weather.main.humidity)%")
                                        Text("Humidity")
                                            .font(.caption)
                                    }
                                    
                                    VStack {
                                        Image(systemName: "wind")
                                        Text("\(Int(weather.wind.speed)) km/h")
                                        Text("Wind")
                                            .font(.caption)
                                    }
                                }
                                .padding()
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.2))
                            )
                            .padding()
                            
                            // Forecast Section
                            if !viewModel.forecastData.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("5-Day Forecast")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                    
                                    ForEach(viewModel.forecastData, id: \.dt) { item in
                                        HStack {
                                            Text(item.date, style: .date)
                                                .frame(width: 100, alignment: .leading)
                                            
                                            Image(systemName: viewModel.weatherIcon(for: item.weather.first?.id ?? 800))
                                                .frame(width: 40)
                                            
                                            Spacer()
                                            
                                            Text("\(Int(item.main.temp))°C")
                                                .fontWeight(.semibold)
                                        }
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white.opacity(0.15))
                                        )
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Weather Pro")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await viewModel.fetchWeather(for: cityName)
            await viewModel.fetchForecast(for: cityName)
        }
    }
}

#Preview {
    ContentView()
}
