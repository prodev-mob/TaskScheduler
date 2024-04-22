//
//  Date+Extension.swift
//  SwiftUI-MVVM
//
//  Created by DREAMWORLD on 10/01/24.
//

import Foundation

extension Date {
    
    func toString()-> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
