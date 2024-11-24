import SwiftUI

// Defines the main landing page of the app
// Provides navigation to options for wardrobe, and outfits
struct HomeView: View {
    @ObservedObject var userSession = UserSession.shared // user session
    let debug = false
    
    private var navigationTitle: String {
        if let userEmail = userSession.userEmail {
            let username = userEmail.components(separatedBy: "@").first ?? userEmail
            return "Welcome back, \(username)!"
        } else {
            return "ClimateCloset"
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    // centered main buttons (70% of screen)
                    VStack(spacing: 20) {
                        HStack {
                            Text("\(navigationTitle)")
                                .font(.system(size: 30))
                                .fontWeight(.thin)
                            Image("CCLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.07)
                        }
                        .padding(.bottom, 50)
                        NavigationLink(destination: WardrobeView().environmentObject(ClothesStore())) {
                            Text("Wardrobe")
                                .frame(maxWidth: .infinity, maxHeight: 35)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 2, y: 2)
                        }

                        NavigationLink(destination: OutfitsView()
                            .environmentObject(OutfitStore())
                            .environmentObject(ClothesStore())) {
                            Text("Your Outfits")
                                .frame(maxWidth: .infinity, maxHeight: 35)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 2, y: 2)
                        }
                    }
                    .frame(height: geometry.size.height * 0.7) // Take 70% of the screen height
                    .frame(maxWidth: .infinity, alignment: .center) // Center horizontally
                    
                    // "Create A New Outfit" Button (below the 70% section)
                    VStack {
                        NavigationLink(destination: CreateOutfitView()
                            .environmentObject(ClothesStore())
                            .environmentObject(OutfitStore())) {
                            Text("Create A New Outfit")
                                .frame(maxWidth: .infinity, maxHeight: 35)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(30)
                                .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 2, y: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.2) // Take 20% of the screen height
                    .padding(.top)
                }
            }
            .padding()
            .navigationTitle("")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
