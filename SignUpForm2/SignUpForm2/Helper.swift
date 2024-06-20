//
//  Helper.swift
//  SignUpForm2
//
//  Created by 박지혜 on 6/20/24.
//

import Foundation
import Combine

struct UserNameAvailableMessage: Codable {
    var isAvailable: Bool
    var userName: String
}

struct APIErrorMessage: Decodable {
    var error: Bool
    var reason: String
}

enum APIError: LocalizedError {
    case invalidResponse
    case invalidRequestError(String)
    case transportError(Error)
    case validationError(String)
    case decodingError(Error)
    case serverError(statusCode: Int, reason: String? = nil, retryAfter: String? = nil)
    
    var errorDescription: String? {
        switch self {
        case .invalidRequestError(let message):
            return "Invalid request: \(message)"
        case .transportError(let error):
            return "Transport error: \(error)"
        case .invalidResponse:
            return "Invalid response"
        case .validationError(let reason):
            return "Validation error: \(reason)"
        case .decodingError:
            return "The server returned data in an unexpected format. Try updaing the app."
        case .serverError(let statusCode, let reason, let retryAfter):
            return "Server error with code \(statusCode), reason:\(reason ?? "no reason given"), retry after: \(retryAfter ?? "no retry after provided")"
        }
    }
}

extension Publisher {
    // Publisher의 출력을 Result 타입으로 감싸고, 오류가 발생하면 그 오류를 Result.failure로 감싸며,  절대 오류를 방출하지 않는(never) AnyPublisher를 반환
    /// 이 메서드는 주로 Publisher의 결과를 Result 타입으로 쉽게 처리하고, 오류를 단일 흐름으로 관리할 때 유용
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map(Result.success) /// true/false(Result의 결과)를 success로 감쌈
            .catch { error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher() /// 다시 흘려보냄
    }
}
