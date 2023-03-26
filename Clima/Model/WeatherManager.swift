//
//  WeatherControl.swift
//  Clima
//
//
//  Created by Elif Tum on 1.03.2023.


import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManeger, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManeger{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=d705a64bedc66e0e038408cfdaf0cb7c&units=metric"
    
    var delegate: WeatherManagerDelegate?
    

    func fetchWeather(cityName : String){
        let urlString = ("\(weatherURL)&q=\(cityName)")
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    func performRequest (with urlString: String){
        //1.Create URL
        if let url = URL(string: urlString){
            
            //2.Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3.Give the session a task
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            
            //4.Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
                print(weather.conditionName)
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

    
}
