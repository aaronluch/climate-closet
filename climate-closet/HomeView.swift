import SwiftUI

struct HomeView: View {
    var body: some View {
        ClothingListView().environmentObject(ClothesStore())
        Text("this is the home / wardrobe")
            .navigationTitle("Home")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
