//
//  AuthenticationViewModel.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//

import Foundation

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    
    var formIsValid: Bool {
        return email?.isEmpty == false &&
            password?.isEmpty == false
    }
    
    
}

struct RegistrationViewModel: AuthenticationViewModel {
    var email: String?
    var fullname: String?
    var password: String?
    
    
    var formIsValid: Bool {
        return email?.isEmpty == false &&
            fullname?.isEmpty == false &&
            password?.isEmpty == false
    }
        
    
}
