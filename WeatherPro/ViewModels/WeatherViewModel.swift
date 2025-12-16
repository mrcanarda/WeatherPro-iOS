import Combine
import Foundation
import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherResponse?
    @Published var forecastData: [ForecastItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let weatherService = WeatherService()
    
    // MARK: - Fetch Weather
    func fetchWeather(for city: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let weather = try await weatherService.fetchWeather(for: city)
            self.weatherData = weather
        } catch {
            self.errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Fetch Forecast
    func fetchForecast(for city: String) async {
        do {
            let forecast = try await weatherService.fetchForecast(for: city)
            // Get one forecast per day (every 8th item = 24 hours)
            self.forecastData = stride(from: 0, to: min(40, forecast.list.count), by: 8).map {
                forecast.list[$0]
            }
        } catch {
            self.errorMessage = "Failed to fetch forecast: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Helper: Weather Icon
    func weatherIcon(for id: Int) -> String {
        switch id {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "cloud.fog.fill"
        case 800: return "sun.max.fill"
        case 801...804: return "cloud.sun.fill"
        default: return "cloud.fill"
        }
    }
}
