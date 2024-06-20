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
            return Fail(error: APIError.invalidRequestError("URL invalid"))
                .eraseToAnyPublisher()
        }
        let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error -> Error in
                return APIError.transportError(error)
            }
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                print("Received reponse from server, now checking status code")

                guard let urlResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }

                if (200..<300) ~= urlResponse.statusCode { }
                else {
                    let decoder = JSONDecoder()
                    let apiError = try decoder.decode(APIErrorMessage.self, from: data)

                    if urlResponse.statusCode == 400 {
                        throw APIError.validationError(apiError.reason)
                    }

                    if (500..<600) ~= urlResponse.statusCode {
                        let retryAfter = urlResponse.value(forHTTPHeaderField: "Retry-After")
                        throw APIError.serverError(statusCode: urlResponse.statusCode, reason: apiError.reason, retryAfter: retryAfter)
                    }
                }
                return (data, response)
            }
            return dataTaskPublisher
                .map(\.data) /// publisher
                .decode(type: UserNameAvailableMessage.self, decoder: JSONDecoder())
                .map(\.isAvailable)
                .eraseToAnyPublisher()
    }
}
