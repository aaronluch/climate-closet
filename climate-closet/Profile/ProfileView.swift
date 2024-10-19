import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .border(Color.black, width: 2)
                        .cornerRadius(8)
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
                        .cornerRadius(8)
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
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Profile")
            .padding()
        }
    }
}

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                
            }) {
                Text("Login")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .border(Color.black, width: 2)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
        .padding()
        .navigationTitle("Login")
    }
}

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Register")
                .font(.largeTitle)

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                
            }) {
                Text("Register")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .border(Color.black, width: 2)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
        .padding()
        .navigationTitle("Register")
    }
}

struct SettingsView: View {
    var body: some View {
        List {
            NavigationLink(destination: Text("Account Name Settings")) {
                Text("Account Name")
            }
            NavigationLink(destination: Text("Security Settings")) {
                Text("Security")
            }
            NavigationLink(destination: Text("Theme Settings")) {
                Text("Theme")
            }
            NavigationLink(destination: Text("Feed Settings")) {
                Text("Feed Settings")
            }
        }
        .navigationTitle("Settings")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
