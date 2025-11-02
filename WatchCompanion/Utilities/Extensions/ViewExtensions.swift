//
//  ViewExtensions.swift
//  WatchCompanion
//
//  Created by Md. Aminul Islam on 1/11/25.
//
import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.2), radius: 4)
    }
}
