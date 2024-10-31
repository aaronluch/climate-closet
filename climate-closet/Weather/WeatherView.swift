import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @State private var weatherData: WeatherData?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Weather")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center) 
                    .foregroundColor(.black)

                if let weather = weatherData {
                    let tempFahrenheit = Int((weather.main.temp * 9/5) + 32)
                    let currentTemp = "\(tempFahrenheit)°F"
                    let description = weather.weather.first?.description.capitalized ?? ""
                    
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
                    .frame(maxWidth: .infinity)
                    .border(Color.black, width: 2)
                    .background(Color.white)
                    .cornerRadius(3)

                    
                    NavigationLink(destination: ClothingListView()) {
                        Text("Plan Tomorrow's Outfit")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .border(Color.black, width: 2)
                            .cornerRadius(3)
                    }
                    .padding()

                    
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
            .navigationBarHidden(true)
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
