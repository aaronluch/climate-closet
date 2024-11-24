import SwiftUI
import CoreLocation
import FirebaseFirestore

// Displays weather information dynamically based on user's location
// Also plan out next day's outfit
struct WeatherView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var weatherData: WeatherData?
    @State private var isShowingDialog = false
    @EnvironmentObject var outfitStore: OutfitStore
    @State private var listener: ListenerRegistration?
    @State private var locationName: String = "Weather"
    @State private var backgroundOpacity: Double = 0.0
    @State private var textColor: Color = .black
    @State private var currentHour: Int = Calendar.current.component(.hour, from: Date())
    
    private func backgroundGradient(for hour: Int) -> LinearGradient {
        switch hour {
        case 6..<12: // Morning
            DispatchQueue.main.async {
                self.textColor = .black
            }
            return LinearGradient(
                gradient: Gradient(colors: [Color.orange.opacity(0.7), Color.yellow.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 12..<17: // Afternoon
            DispatchQueue.main.async {
                self.textColor = .black
            }
            return LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.cyan.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 17..<20: // Evening
            DispatchQueue.main.async {
                self.textColor = .white
            }
            return LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.pink.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default: // Night
            DispatchQueue.main.async {
                self.textColor = .white
            }
            return LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.9), Color.indigo.opacity(0.9)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient(for: currentHour)
                    .opacity(backgroundOpacity)
                    .animation(.easeInOut(duration: 1.5), value: backgroundOpacity)
                    .ignoresSafeArea(edges: .all)
                
                VStack() {
                    Text(locationName)
                        .font(.system(size: 32))
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(textColor)
                    
                    if let weather = weatherData {
                        let tempFahrenheit = Int((weather.main.temp * 9/5) + 32)
                        let currentTemp = "\(tempFahrenheit)°F"
                        let description = weather.weather.first?.description.capitalized ?? ""
                        
                        VStack {
                            Text("\(currentTemp)")
                                .font(.system(size: 80))
                                .fontWeight(.light)
                                .foregroundColor(textColor.opacity(0.8))

                            Text("\(description)")
                                .font(.headline)
                                .foregroundColor(textColor.opacity(0.8))
                                .fontWeight(.light)
                                .padding(.bottom, 10)
                            
                            let (icon, gradient) = weatherIcon(for: description)
                            icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.clear) // Clear base color
                                .overlay(
                                    LinearGradient(
                                        gradient: gradient,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    .mask(
                                        icon
                                            .resizable()
                                            .scaledToFit()
                                    )
                                )
                                .shadow(color: Color.gray.opacity(0.6), radius: 8, x: 2, y: 6)
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
                                                gradient: Gradient(colors: [Color.blue.opacity(1.0), Color.teal]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(30)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.white.opacity(1.0), Color.gray.opacity(0.5)]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1.5
                                                )
                                        )
                                        .shadow(color: Color.gray.opacity(0.6), radius: 8, x: 2, y: 6)
                                        .padding(.horizontal, 20)
                                }
                            
                        }
                    } else {
                        Text("Fetching weather...")
                    }
                }
                .padding(.top)
                .onAppear {
                    backgroundOpacity = 1.0
                    startListeningForPlannedOutfit()
                    if let coordinate = locationManager.location {
                        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                        fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) { data in
                            self.weatherData = data
                        }
                        fetchLocationName(for: location)
                        updateCurrentHour(for: location)
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
    }
    
    private func updateCurrentHour(for location: CLLocation) {
        // use geocoder to fetch time zone for the given location
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error fetching timezone: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first, let timeZone = placemark.timeZone else {
                print("Failed to fetch timezone for location.")
                return
            }
            
            // use the fetched time zone to calculate the hour
            var calendar = Calendar.current
            calendar.timeZone = timeZone
            
            let newHour = calendar.component(.hour, from: Date())
            DispatchQueue.main.async {
                self.currentHour = newHour
                print("Current hour set to:", self.currentHour, "for timezone:", timeZone.identifier)
            }
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
    
    private func weatherIcon(for description: String) -> (icon: Image, gradient: Gradient) {
        switch description.lowercased() {
        case let str where str.contains("clear"):
            return (Image(systemName: "sun.max.fill"), Gradient(colors: [Color.yellow, Color.orange]))
        case let str where str.contains("cloud"):
            return (Image(systemName: "cloud.fill"), Gradient(colors: [Color.gray.opacity(0.6), Color.gray]))
        case let str where str.contains("rain"):
            return (Image(systemName: "cloud.rain.fill"), Gradient(colors: [Color.blue, Color.indigo]))
        case let str where str.contains("snow"):
            return (Image(systemName: "cloud.snow.fill"), Gradient(colors: [Color.white, Color.blue.opacity(0.5)]))
        case let str where str.contains("thunderstorm"):
            return (Image(systemName: "cloud.bolt.rain.fill"), Gradient(colors: [Color.yellow, Color.gray]))
        case let str where str.contains("mist"), let str where str.contains("fog"):
            return (Image(systemName: "cloud.fog.fill"), Gradient(colors: [Color.gray.opacity(0.8), Color.gray]))
        default:
            return (Image(systemName: "questionmark.circle.fill"), Gradient(colors: [Color.gray, Color.black]))
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

