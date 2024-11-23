import SwiftUI

struct ProfileView: View {
    @ObservedObject var userSession = UserSession.shared // user session
    
    private var navigationTitle: String {
        if let userEmail = userSession.userEmail {
            let username = userEmail.components(separatedBy: "@").first ?? userEmail
            return "Welcome back, \(username)!"
        } else {
            return "Profile"
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // main content
                    VStack(spacing: 20) {
                        VStack {
                            Text("Profile")
                                .font(.system(size: 32.00))
                                .fontWeight(.thin)
                                .padding(.bottom)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: geometry.size.height * 0.1)
                            .zIndex(1)
                        
                        Image("CCLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.4)
                        
                        Text("\(navigationTitle)")
                            .fontWeight(.regular)
                            .font(.system(size: 30))
                            .padding(.bottom, 50)
                        
                        if userSession.userID == nil {
                            NavigationLink(destination: LoginView()) {
                                Text("Login")
                                    .font(.title3)
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: 25)
                                    .padding(.vertical, 15)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(80)
                                    .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 2, y: 2)
                            }
                            
                            NavigationLink(destination: RegisterView()) {
                                Text("Register")
                                    .font(.title3)
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: 25)
                                    .padding(.vertical, 15)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(80)
                                    .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 2, y: 2)
                            }
                        } else if userSession.userID != nil {
                            NavigationLink(destination: SettingsView()) {
                                Text("Settings")
                                    .font(.title3)
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: 35)
                                    .padding(.vertical, 15)
                                    .background(Color.teal.opacity(1.0))
                                    .foregroundColor(.white)
                                    .cornerRadius(80)
                                    .shadow(color: Color.gray.opacity(0.5), radius: 6, x: 2, y: 6)
                            }
                        }
                    }
                    .frame(height: geometry.size.height * 0.8) // 80% height
                    
                    // remaining space for logout
                    VStack {
                        if userSession.userID != nil {
                            Button(action: {
                                userSession.logout()
                            }) {
                                Text("Logout")
                                    .font(.title3)
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: 15)
                                    .padding(.vertical, 10)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 2, y: 2)
                            }
                        }
                    }
                    .frame(height: geometry.size.height * 0.1) // Allocate 10% of height
                }
            }
            .navigationTitle("")
            .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
