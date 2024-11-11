import SwiftUI
// current basic implementation of profile page,
// probably want to separate these view into more files soon
struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // login / register button will become
                // a ternary based on login state of user
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .border(Color.black, width: 2)
                        .cornerRadius(3)
                }

                NavigationLink(destination: RegisterView()) {
                    Text("Register")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .border(Color.black, width: 2)
                        .cornerRadius(3)
                }

                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .border(Color.black, width: 2)
                        .cornerRadius(3)
                }
            }
            .navigationTitle("Profile")
            .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
