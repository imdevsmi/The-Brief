//
//  WeatherUIModel.swift
//  The Brief
//
//  Created by Sami Gündoğan on 23.09.2025.
//

import Foundation

struct WeatherUIModel {
    let city: String
    let temp: String
    let condition: String
    let iconURL: String
}

struct WeatherAlert {
    let headline: String
    let severity: String
}
