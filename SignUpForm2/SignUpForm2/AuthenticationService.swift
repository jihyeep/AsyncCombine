//
//  AuthenticationService.swift
//  SignUpForm2
//
//  Created by 박지혜 on 6/20/24.
//

import Foundation
import Combine

struct AuthenticationService {
    // Stream1
    func checkUserNameAvailablePublisher(userName: String) -> AnyPublisher<Bool, Error> {
        // 서버로 username을 보내 같은 데이터가 있는지 확인
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
