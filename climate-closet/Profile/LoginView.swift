import Foundation
import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginError: String?
    @State private var loginSuccess = false
    @Environment(\.presentationMode) var presentationMode
    private var countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)

            TextField("Email", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle()).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/).autocorrectionDisabled()
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle()).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/).autocorrectionDisabled()
                .padding()

            if let loginError = loginError {
                Text(loginError)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            Button(action: {
                loginUser()
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
            if loginSuccess {
//                Text("Success!")
//                    .foregroundColor(.green)
//                    .padding()
                // this just looks stupid right now, queue makes it feel sluggish to countdown from as well
            }
        }
        .padding()
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func loginUser() {
        AuthService.shared.loginUser(email: username, password: password) { result in
            switch result {
            case .success(let user):
                print("Logged in user ID: \(user.uid)")
                loginSuccess = true
                loginError = nil
            case .failure(let error):
                loginError = "Failed to login: \(error.localizedDescription)"
            }
        }
    }
}
