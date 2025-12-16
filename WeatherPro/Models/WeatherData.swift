//
//  WeatherData.swift
//  WeatherPro
//
//  Created by Can Arda on 16.12.25.
//

import Foundation

// MARK: - Weather Response Model

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}


struct Main: Codable {
    let temp: Double
    let humidity: Int
    let feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
        case feelsLike = "feels_like"
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
}

// MARK: - Forecast Response Model

struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather] 
    
    var date: Date{
        Date(timeIntervalSince1970: TimeInterval(dt))
    }
}
