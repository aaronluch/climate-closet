import SwiftUI
import CoreLocation
import FirebaseFirestore

struct WeatherView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @State private var weatherData: WeatherData?
    @State private var isShowingDialog = false
    @EnvironmentObject var outfitStore: OutfitStore
    @State private var listener: ListenerRegistration?
    @State private var locationName: String = "Weather"
    
    var body: some View {
        NavigationView {
            VStack() {
                Text(locationName)
                    .font(.system(size: 32))
                    .fontWeight(.regular)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.black)
                
                if let weather = weatherData {
                    let tempFahrenheit = Int((weather.main.temp * 9/5) + 32)
                    let currentTemp = "\(tempFahrenheit)°F"
                    let description = weather.weather.first?.description.capitalized ?? ""
                    
                    VStack {
                        Text("\(currentTemp)")
                            .font(.system(size: 80))
                            .foregroundColor(.black.opacity(0.8))
                            .fontWeight(.light)
                        Text("\(description)")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.8))
                            .fontWeight(.light)
                            .padding(.bottom, 10)
                        
                        weatherIcon(for: description)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 20)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(3)
                    
                    if outfitStore.hasPlannedOutfit() {
                        VStack {
                            HStack() {
                                Text("Tomorrow's Outfit")
                                    .padding(.horizontal)
                                    .offset(y: 20)
                                Spacer()
                            }
                            if let plannedOutfit = outfitStore.allOutfits.first(where: { $0.isPlanned }) {
                                NavigationLink(destination: OutfitDetailView(outfit: plannedOutfit)) {
                                    OutfitListRow(outfit: plannedOutfit)
                                }
                                .padding()
                                
                                Button(action: {
                                    isShowingDialog = true
                                }) {
                                    Text("Remove Tomorrow's Outfit")
                                        .frame(maxWidth: .infinity, minHeight: 10)
                                        .padding()
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.red.opacity(0.8), Color.red]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.white.opacity(1.0), Color.gray.opacity(0.5)]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1.5
                                                )
                                        )
                                        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 2, y: 2)
                                        .padding(.horizontal, 20)
                                }
                                .confirmationDialog("Are you sure you want to delete tomorrow's outfit?", isPresented: $isShowingDialog, titleVisibility: .visible) {
                                    Button("Delete", role: .destructive) {
                                        outfitStore.deletePlannedOutfit { _ in }
                                    }
                                    Button("Cancel", role: .cancel) {
                                        isShowingDialog = false
                                    }
                                }
                            }
                        }
                    } else {
                        NavigationLink(destination: OutfitPlanningView()
                            .environmentObject(ClothesStore())
                            .environmentObject(OutfitStore())) {
                                Text("Plan Tomorrow's Outfit")
                                    .frame(maxWidth: .infinity, maxHeight: 35)
                                    .padding()
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.white.opacity(1.0), Color.gray.opacity(0.5)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1.5
                                            )
                                    )
                                    .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 2, y: 2)
                                    .padding(.horizontal, 20)
                            }
                        
                    }
                } else {
                    Text("Fetching weather...")
                }
            }
            .padding(.top)
            .onAppear {
                startListeningForPlannedOutfit()
                if let coordinate = locationManager.location {
                    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) { data in
                        self.weatherData = data
                    }
                    fetchLocationName(for: location)
                }
            }
            .onDisappear {
                listener?.remove()
                listener = nil
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    
    private func startListeningForPlannedOutfit() {
        guard let userID = UserSession.shared.userID else { return }
        listener = Firestore.firestore().collection("outfits")
            .whereField("userID", isEqualTo: userID)
            .whereField("isPlanned", isEqualTo: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening for planned outfit updates: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No planned outfits found.")
                    return
                }
                
                outfitStore.allOutfits = documents.compactMap { doc in
                    let data = doc.data()
                    return outfitStore.parseOutfitData(data, documentID: doc.documentID)
                }
            }
    }
    
    private func weatherIcon(for description: String) -> Image {
        switch description.lowercased() {
        case let str where str.contains("clear"):
            return Image(systemName: "sun.max.fill")
        case let str where str.contains("cloud"):
            return Image(systemName: "cloud.fill")
        case let str where str.contains("rain"):
            return Image(systemName: "cloud.rain.fill")
        case let str where str.contains("snow"):
            return Image(systemName: "cloud.snow.fill")
        case let str where str.contains("thunderstorm"):
            return Image(systemName: "cloud.bolt.rain.fill")
        case let str where str.contains("mist"), let str where str.contains("fog"):
            return Image(systemName: "cloud.fog.fill")
        default:
            return Image(systemName: "questionmark.circle.fill")
        }
    }
    
    private func fetchLocationName(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error fetching location name: \(error.localizedDescription)")
                self.locationName = "Unknown Location"
            } else if let placemark = placemarks?.first {
                self.locationName = placemark.locality ?? placemark.name ?? "Unknown Location"
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
            .environmentObject(OutfitStore())
    }
}

