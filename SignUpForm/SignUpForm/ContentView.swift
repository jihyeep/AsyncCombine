//
//  ContentView.swift
//  SignUpForm
//
//  Created by 박지혜 on 6/18/24.
//

import SwiftUI
import Combine

extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map(Result.success)
            .catch { error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}
class SignUpFormViewModel: ObservableObject {
    typealias Available = Result<Bool, Error>
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    
    @Published var usernameMessage: String = ""
    @Published var passwordMessage: String = ""
    @Published var isValid: Bool = false
    
    private let authenticationService = AuthenticationService()
    
    // 구독을 취소할 수 있는 객체들을 저장하기 위해 사용
    /// 비동기 작업이 완료되기 전에 취소하고자 할 때 사용
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var isUsernameLengthValidPublisher: AnyPublisher<Bool, Never> = { // Bool 타입, 에러는 Never
        $username.map { $0.count >= 3 }.eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> = {
        $password.map(\.isEmpty).eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordMatchingPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest($password, $passwordConfirmation)
            .map(==)
//            .map { $0 == $1 } /// 위 코드와 동일
            .eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordValidPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordMatchingPublisher)
            .map { !$0 && $1 }
            .eraseToAnyPublisher()
    }()
    
    private lazy var isFormValidPublisher: AnyPublisher<Bool, Never> = {
        // 스트림 3개 합성
        Publishers.CombineLatest3(isUsernameLengthValidPublisher, isUsernameAvailablePublisher, isPasswordValidPublisher)
            .map { isUsernameLengthValid, isUsernameAvailable, isPasswordValid in
                switch isUsernameAvailable {
                case .success(let isAvailable):
                    return isUsernameLengthValid && isAvailable && isPasswordValid
                case .failure:
                    return false
                }
            }
            .eraseToAnyPublisher()
    }()
    
    private lazy var isUsernameAvailablePublisher: AnyPublisher<Available, Never> = {
            $username
                // 0.5초 후에 검증
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                // 중첩 배열(이중 배열)을 flat하게 만들 때사용
                /// Combine에서는 게시자를 publisher 객체로 만들어줄 수 있음
                .flatMap { username -> AnyPublisher<Available, Never> in
                    self.authenticationService.checkUserNameAvailable(userName: username)
                        .asResult()
                }
                .receive(on: DispatchQueue.main)
                .share() // 다른 subscriber에서 이 publisher를 공유
                .print("share")
                .eraseToAnyPublisher()
    }()
    
    init() {
        // Combine을 사용하여 구독 형태로 변환
        isFormValidPublisher.assign(to: &$isValid)
        
        Publishers.CombineLatest(isUsernameLengthValidPublisher, isUsernameAvailablePublisher)
            .map { isUsernameLengthValid, isUserNameAvailable in
                switch (isUsernameLengthValid, isUserNameAvailable) {
                case (false, _):
                    return "Username must be at least three characters!"
                case (_, .failure(let error)):
                    if case APIError.transportError(_) = error {
                        return "인터넷 연결을 확인하세요."
                    }
                    return "Error checking username availability: \(error.localizedDescription)"
                case (_, .success(false)):
                    return "This username is already taken."
                default:
                    return ""
                }
            }
            .assign(to: &$usernameMessage)
        
        Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordMatchingPublisher)
            .map { isPasswordEmpty, isPasswordMatching in
                if isPasswordEmpty {
                    return "Password must not be empty"
                } else if !isPasswordMatching {
                    return "Passwords do not match"
                }
                return ""
            }
            .assign(to: &$passwordMessage)
    }
}

struct ContentView: View {
    @StateObject var viewModel = SignUpFormViewModel()
    
    var body: some View {
        Form {
            // username
            Section {
                TextField("Username", text: $viewModel.username)
                    // 첫 글자 대문자 변환 비활성화
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } footer: {
                Text(viewModel.usernameMessage)
                    .foregroundStyle(.red)
            }
            // password
            Section {
                SecureField("Password",
                            text: $viewModel.password)
                SecureField("Repeat password",
                            text: $viewModel.passwordConfirmation)
            } footer: {
                Text(viewModel.passwordMessage)
                    .foregroundColor(.red)
            }
            // submit button
            Section {
                Button("Sign up") {
                    print("Signing up as \(viewModel.username)")
                }
                .disabled(!viewModel.isValid)
            }
        }
    }
}

#Preview {
    ContentView()
}
