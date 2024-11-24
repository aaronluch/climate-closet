//
//  UserSession.swift
//  climate-closet
//
//  Created by Aaron Luciano on 11/12/24.
//

import FirebaseAuth
import Combine

// Tracks user session based on logged in user
class UserSession: ObservableObject {
    static let shared = UserSession()
    
    @Published var userID: String? // stores user's ID
    @Published var userEmail: String?
    
    private init() {
        let currentUser = Auth.auth().currentUser
        self.userID = currentUser?.uid
        self.userEmail = currentUser?.email
    }
    
    func updateUserSession() {
        let currentUser = Auth.auth().currentUser
        self.userID = currentUser?.uid
        self.userEmail = currentUser?.email
    }
    
    func logout() {
        do {
            print("\(self.userID) going to sign out")
            try Auth.auth().signOut()
            self.userID = nil
            self.userEmail = nil
            print("Successfully signed out.")
        } catch {
            print("Error signing out.")
        }
    }
}
