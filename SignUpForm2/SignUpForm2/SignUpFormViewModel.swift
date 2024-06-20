//
//  SignUpFormViewModel.swift
//  SignUpForm2
//
//  Created by 박지혜 on 6/20/24.
//

import Foundation
import Combine

class SignUpFormViewModel: ObservableObject {
    typealias Available = Result<Bool, Error>
    
    @Published var username: String = ""
    @Published var usernameMessage: String = ""
    @Published var isValid: Bool = false
    @Published var showUpdateDialog: Bool = false
    
    private var authenticationService = AuthenticationService()
    
    // Stream2(publisher)
    private lazy var isUsernameAvailablePublisher: AnyPublisher<Available, Never> = {
        $username
            .debounce(for: 0.5, scheduler: RunLoop.main) /// 속도 조절
            .removeDuplicates() /// 중복 제거
            // Stream 변경을 위해 사용
            .flatMap { username -> AnyPublisher<Available, Never> in
                self.authenticationService.checkUserNameAvailablePublisher(userName: username)
                    // Stream에 들어가서 Result 타입으로 감싸서 값을 보냄
                    /// 오류 흐름이 사라짐
                    .asResult()
            }
            .receive(on: DispatchQueue.main)
            .print("before share")
            .share() /// stream 공유
            .print("share")
            .dump() /// 원래 있던 dump 함수를 실행 흐름 중간에 써서 흐름을 눈으로 보기 위함
            .eraseToAnyPublisher()
    }()
    
    init() {
        // isValid
        isUsernameAvailablePublisher.map { result in
            switch result {
            case .success(let isAvailable):
                return isAvailable
//            case .failure(let error):
            case .failure(let error):
                if case APIError.transportError(_) = error {
                    return true
                }
                return false
            }
        }
        .assign(to: &$isValid)
        
        // usernameMessage
        isUsernameAvailablePublisher.map { result in
            switch result {
            case .success(let isAvailable):
                return isAvailable ? "" : "This username is not available"
            // Error message
            case .failure(let error):
                if case APIError.transportError(_) = error {
                    return ""
                }
                else if case APIError.validationError(let reason) = error {
                    return reason
                }
                else if case APIError.serverError(statusCode: _, reason: let reason, retryAfter: _) = error {
                    return reason ?? "Server error"
                }
                return error.localizedDescription
            }
        }
        .assign(to: &$usernameMessage)
        
        // showUpdateDialog
        isUsernameAvailablePublisher.map { result in
            if case .failure(let error) = result {
                if case APIError.decodingError = error {
                    return true
                }
            }
            return false
        }
        .assign(to: &$showUpdateDialog)
    }
}
