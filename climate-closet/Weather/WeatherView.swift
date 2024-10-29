import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @State private var weatherData: WeatherData?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Centered Weather Title
                Text("Weather")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center) // Center the title
                    .foregroundColor(.black)

                if let weather = weatherData {
                    // Calculate rounded temperature in Fahrenheit
                    let tempFahrenheit = Int((weather.main.temp * 9/5) + 32)
                    let currentTemp = "\(tempFahrenheit)°F"
                    let description = weather.weather.first?.description.capitalized ?? ""
                    
                    // Display the temperature and description
                    HStack {
                        Image(systemName: "cloud.sun")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                        
                        Text("Now: \(description), \(currentTemp)")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity) // Ensures the HStack occupies the maximum width
                    .border(Color.black, width: 2)
                    .background(Color.white) // Match background color
                    .cornerRadius(3) // Match corner radius

                    // "Plan Tomorrow's Outfit" Navigation Link
                    NavigationLink(destination: OutfitPlanningView()) {
                        Text("Plan Tomorrow's Outfit")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.white) // Match background with the current weather display
                            .foregroundColor(.black)
                            .border(Color.black, width: 2)
                            .cornerRadius(3)
                    }
                    .padding()

                    // Display 24-hour weather breakdown
                    VStack {
                        Text("24-Hour Weather Breakdown")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .border(Color.black, width: 2)
                            .foregroundColor(.black)
                        
                    }
                    .padding()
                } else {
                    Text("Fetching weather...")
                }
            }
            .padding(.top)
            .onAppear {
                if let location = locationManager.location {
                    fetchWeather(latitude: location.latitude, longitude: location.longitude) { data in
                        self.weatherData = data
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true) // Hide default navigation bar title
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
