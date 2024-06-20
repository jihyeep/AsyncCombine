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
        guard let url = URL(string: "http://127.0.0.1:8080/isUserNameAvailable?userName=\(userName)") else {
            return Fail(error: APIError.invalidResponse)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url).map(\.data) /// publisher
            .decode(type: UserNameAvailableMessage.self, decoder: JSONDecoder())
            .map(\.isAvailable)
            .eraseToAnyPublisher()
    }
}
