import Foundation
import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var registrationError: String?
    @State private var isRegistered = false
    @State private var countdown = 3
    @Environment(\.presentationMode) var presentationMode
    private var countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 20) {
            Text("Register")
                .font(.largeTitle)

            TextField("Email", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle()).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/).autocorrectionDisabled()
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle()).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/).autocorrectionDisabled()
                .padding()

            if let registrationError = registrationError {
                Text(registrationError)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            if isRegistered {
                Text("Registration successful! Returning in \(countdown)s...")
                    .foregroundColor(.green)
                    .padding()
                    .onReceive(countdownTimer) { _ in
                        if countdown > 0 {
                            countdown -= 1
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            }

            Button(action: {
                registerUser()
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
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func registerUser() {
        AuthService.shared.registerUser(email: username, password: password) { result in
            switch result {
            case .success(let user):
                print("Registered user ID: \(user.uid)")
                isRegistered = true
                registrationError = nil

            case .failure(let error):
                registrationError = "Failed to register: \(error.localizedDescription)"
            }
        }
    }
}
