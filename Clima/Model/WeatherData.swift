//
//  WeatherData.swift
//  Clima
//
//
//  Created by Elif Tum on 1.03.2023.


import Foundation

struct WeatherData: Codable{
    
    let name: String
    let main: Main
    let weather : [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
