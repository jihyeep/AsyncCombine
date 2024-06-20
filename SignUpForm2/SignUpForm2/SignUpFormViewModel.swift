//
//  SignUpFormViewModel.swift
//  SignUpForm2
//
//  Created by 박지혜 on 6/20/24.
//

import Foundation

class SignUpFormViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var usernameMessage: String = ""
    @Published var isValid: Bool = false
    @Published var showUpdateDialog: Bool = false
}
