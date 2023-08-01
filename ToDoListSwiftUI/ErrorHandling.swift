//
//  ErrorHandling.swift
//  ToDoListSwiftUI
//
//  Created by MacBook Noob on 01/08/23.
//

import Foundation

class ErrorHandling: ObservableObject {
    
    static var shared = ErrorHandling()
    
    @Published var currentAlert: Error?
    @Published var hasError: Bool = false
    
    var localizedError: String { currentAlert?.localizedDescription ?? "Unknown Error." }

    func handle(error: Error) {
        print(error)
        hasError = true
        currentAlert = error
    }
    
    func dismissButton() {
        hasError = false
        currentAlert = nil
    }
}
