import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @State private var weatherData: WeatherData?
    
    var body: some View {
        VStack {
            if let weather = weatherData {
                Text("Temperature: \(weather.main.temp)°C")
                Text("Description: \(weather.weather.first?.description ?? "")")
            } else {
                Text("Fetching weather...")
            }
        }
        .onAppear {
            if let location = locationManager.location {
                fetchWeather(latitude: location.latitude, longitude: location.longitude) { data in
                    self.weatherData = data
                }
            }
        }
    }
        
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}


