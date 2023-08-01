//
//  DataError.swift
//  ToDoListSwiftUI
//
//  Created by MacBook Noob on 01/08/23.
//

import Foundation

enum DataError: Error {
    case taskFieldIsEmpry
    case unknownError
}

extension DataError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .taskFieldIsEmpry:
            return "Task title must not be empty!"
        case .unknownError:
            return "Unknown Error"
        }
    }
}
