//
//  BoundsPreference.swift
//  iMessageMenu
//
//  Created by Godwin IE on 18/04/2025.
//

// for context menu

import SwiftUI

struct BoundsPreference: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()){$1}
    }
}
