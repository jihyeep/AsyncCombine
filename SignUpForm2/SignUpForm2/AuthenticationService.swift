//
//  AuthenticationService.swift
//  SignUpForm2
//
//  Created by 박지혜 on 6/20/24.
//

import Foundation
import Combine

struct AuthenticationService {
    func checkUserNameAvailablePublisher(userName: String) -> AnyPublisher<Bool, Error> {
        return Fail(error: APIError.invalidResponse)
            .eraseToAnyPublisher()
    }
}
