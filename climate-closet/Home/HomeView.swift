import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
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
//
//                NavigationLink(destination: YourOutfitsView()) {
//                    Text("Your Outfits")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.purple)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }

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
