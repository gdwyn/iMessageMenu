//
//  Message.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import SwiftUI

public struct Message: Identifiable, Equatable {
    public var id = UUID()
    public var date = Date()
    public let direction: Direction
    public let kind: Kind
    public var emoji: String? = nil

    public init(
        id: UUID = UUID(),
        date: Date = Date(),
        direction: Direction,
        kind: Kind,
        emoji: String? = nil
    ) {
        self.id = id
        self.date = date
        self.direction = direction
        self.kind = kind
        self.emoji = emoji
    }
}

public extension Message {
    enum Kind: Equatable {
        case text(String)
        case image(UIImage)
    }
    
    enum Direction: Equatable {
        case outgoing, incoming
    }
}
