//
//  WeatherData.swift
//  climate-closet
//
//  Created by Amy Tully on 16/10/2024.
//

import Foundation

// Weather data model: used to decode the API response
struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
}

// Temperature data
struct Main: Codable {
    let temp: Double
}

// Weather description (e.g., clear sky, rain, etc.)
struct Weather: Codable {
    let description: String
}

// Function to fetch weather data from the OpenWeatherMap API
func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherData?) -> Void) {
    // Replace this with your actual API key
    let apiKey = "24c7b1e85740bb84b2009f78730136a3"
    
    // Build the API URL string using latitude and longitude
    let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
    
    // Ensure the URL is valid
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }
    
    // Create a URLSession data task to fetch the weather data
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                // Decode the received JSON data into the WeatherData struct
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    // Call the completion handler with the decoded weather data
                    completion(weatherData)
                }
            } catch {
                // Handle any decoding errors
                print("Error decoding weather data: \(error)")
                completion(nil)
            }
        } else {
            // Handle any errors or missing data
            print("No data or error: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
        }
    }.resume()  // Start the data task
}
