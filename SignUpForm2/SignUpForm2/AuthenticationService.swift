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
        // 아래 stream에서 error가 날 경우, retry할 코드를 추가하기 위해 변수에 넣어줌
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
            // Retry(재시도)
            .retry(10, withDelay: 3) { error in
                if case APIError.serverError = error {
                    return true
                }
                return false
            }
            .map(\.data) /// publisher
            // Decode error 처리
            .tryMap { data -> UserNameAvailableMessage in
                let decoder = JSONDecoder()
                do {
                    return try decoder.decode(UserNameAvailableMessage.self, from: data)
                } catch {
                    throw APIError.decodingError(error)
                }
            }
            .map(\.isAvailable)
            .eraseToAnyPublisher()
    }
}
