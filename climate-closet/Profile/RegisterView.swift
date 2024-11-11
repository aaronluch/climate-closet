//
//  RegisterView.swift
//  climate-closet
//
//  Created by Aaron Luciano on 11/11/24.
//

import Foundation
import SwiftUI

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
        .navigationBarTitleDisplayMode(.inline)
    }
}
