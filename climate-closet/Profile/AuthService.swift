//
//  AuthService.swift
//  climate-closet
//
//  Created by Aaron Luciano on 11/12/24.
//

import FirebaseAuth
import Foundation

class AuthService {
    static let shared = AuthService()
    
    private init() {}

    func registerUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                UserSession.shared.updateUserSession() // update user session ID on login
                completion(.success(user))
            }
        }
    }
}
