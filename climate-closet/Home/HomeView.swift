import SwiftUI

struct HomeView: View {
    @ObservedObject var userSession = UserSession.shared // user session
    let debug = false
    
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
                
                NavigationLink(destination: ClothingListView().environmentObject(ClothesStore())) {
                    Text("Wardrobe")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                
                NavigationLink(destination: OutfitsView()
                    .environmentObject(OutfitStore()).environmentObject(ClothesStore())) {
                    Text("Your Outfits")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: CreateOutfitView()
                    .environmentObject(ClothesStore())
                    .environmentObject(OutfitStore())) {
                    Text("Create Outfits")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
