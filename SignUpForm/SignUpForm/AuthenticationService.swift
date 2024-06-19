//
//  AuthenticationService.swift
//  SignUpForm
//
//  Created by 박지혜 on 6/19/24.
//

import Foundation

struct UserNameAvailableMessage: Codable {
  var isAvailable: Bool
  var userName: String
}

enum NetworkError: Error {
  case transportError(Error)
  case serverError(statusCode: Int)
  case noData
  case decodingError(Error)
  case encodingError(Error)
}

class AuthenticationService {
    func checkUserNameAvailableWithClosure(userName: String,
                                           completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let url = URL(string: "http://127.0.0.1:8080/isUserNameAvailable?userName=\(userName)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            // 응답 실패
            if let response = response as? HTTPURLResponse,
               !(200..<300).contains(response.statusCode) {
                completion(.failure(.serverError(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // 파싱
            do {
                // decoding
                let decoder = JSONDecoder()
                let userAvailableMessage = try decoder.decode(UserNameAvailableMessage.self, from: data)
                completion(.success(userAvailableMessage.isAvailable))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}
