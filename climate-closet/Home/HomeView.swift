import SwiftUI

struct HomeView: View {
    @ObservedObject var userSession = UserSession.shared // user session
    let debug = false
    
    private var navigationTitle: String {
        if let userEmail = userSession.userEmail{
            let username = userEmail.components(separatedBy: "@").first ?? userEmail
            return ("Welcome back, \(username)!")
        } else {
            return "Home"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if debug {
                    Text("[DEBUG!]")
                    var uid_debug: String {
                        if let userId = userSession.userID {
                            let uid = userId
                            return uid
                        } else {
                            return "not logged in"
                        }
                    }
                    
                    var uemail_debug: String {
                        if let userEmail = userSession.userEmail {
                            let uemail = userEmail
                            return uemail
                        } else {
                            return "not logged in"
                        }
                    }
                    Text("UID: \(uid_debug), \nUEMAIL: \(uemail_debug)")
                }
                
                NavigationLink(destination: WardrobeView().environmentObject(ClothesStore())) {
                    Text("Wardrobe")
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 50)
                }

                
                NavigationLink(destination: OutfitsView()
                    .environmentObject(OutfitStore()).environmentObject(ClothesStore())) {
                    Text("Your Outfits")
                            .frame(maxWidth: .infinity, maxHeight: 35)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: CreateOutfitView()
                    .environmentObject(ClothesStore())
                    .environmentObject(OutfitStore())) {
                    Text("Create Outfits")
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
            .navigationTitle(navigationTitle)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
