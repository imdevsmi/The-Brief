//
//  WeatherModel.swift
//  The Brief
//
//  Created by Sami Gündoğan on 22.09.2025.
//

import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
    let alerts: Alerts
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let region: String
    let country: String
}

// MARK: - Current
struct Current: Codable {
    let temp_c: Double
    let condition: Condition
    let air_quality: AirQuality
}

// MARK: - AirQuality
struct AirQuality: Codable {
    let co: Double
    let no2: Double
    let o3: Double
    let pm2_5: Double
    let pm10: Double
    let us_epa_index: Int
    let gb_defra_index: Int
}

// MARK: - Forecast
struct Forecast: Codable { let forecastday: [ForecastDay] }

// MARK: - ForecastDay
struct ForecastDay: Codable {
    let date: String
    let day: Day
}

// MARK: - Day
struct Day: Codable {
    let maxtemp_c: Double
    let mintemp_c: Double
}

// MARK: - Condition
struct Condition: Codable {
    let text: String
    let icon: String
}

// MARK: - Alerts
struct Alerts: Codable { let alert: [Alert] }

struct Alert: Codable {
    let headline: String
    let severity: String
    let event: String
    let effective: String
    let expires: String
}
