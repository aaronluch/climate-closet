import SwiftUI
import FirebaseFirestore

struct WeatherView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @State private var weatherData: WeatherData?
    @State private var isShowingDialog = false
    @EnvironmentObject var outfitStore: OutfitStore
    @State private var listener: ListenerRegistration?

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
                    
                    if outfitStore.hasPlannedOutfit() {
                        VStack {
                            Text("Tomorrow's Outfit")
                            if let plannedOutfit = outfitStore.allOutfits.first(where: { $0.isPlanned }) {
                                NavigationLink(destination: OutfitDetailView(outfit: plannedOutfit)) {
                                    OutfitListRow(outfit: plannedOutfit)
                                }
                                .padding()

                                Button(action: {
                                    isShowingDialog = true
                                }) {
                                    Text("Delete")
                                        .frame(maxWidth: .infinity, minHeight: 10)
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
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
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 20)
                        }
                    }
                    
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
                startListeningForPlannedOutfit()
                if let location = locationManager.location {
                    print("Location: \(location.latitude), \(location.longitude)")
                    fetchWeather(latitude: location.latitude, longitude: location.longitude) { data in
                        self.weatherData = data
                    }
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
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
            .environmentObject(OutfitStore())
    }
}

