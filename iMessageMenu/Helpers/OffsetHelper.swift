//
//  OffsetHelper.swift
//  iMessageMenu
//
//  Created by Godwin IE on 15/04/2025.
//

import SwiftUI

struct offsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetExtractor(coordinateSpace: String, completion: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .named(coordinateSpace))
                    Color.clear
                        .preference(key: offsetKey.self, value: rect)
                        .onPreferenceChange(offsetKey.self, perform: completion)
                }
            }
    }
}
