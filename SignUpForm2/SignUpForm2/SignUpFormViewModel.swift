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
            .eraseToAnyPublisher()
    }()
    
    init() {
        isUsernameAvailablePublisher.map { result in
            switch result {
            case .success(let isAvailable):
                return isAvailable
//            case .failure(let error):
            case .failure(_):
                return false
            }
        }
        .assign(to: &$isValid)
        
        isUsernameAvailablePublisher.map { result in
            switch result {
            case .success(let isAvailable):
                return isAvailable ? "" : "This username is not available"
            // Error message
            case .failure(let error):
                return error.localizedDescription
            }
        }
        .assign(to: &$usernameMessage)
    }
}
