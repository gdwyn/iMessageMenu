//
//  View+Extension.swift
//  iMessageMenu
//
//  Created by Godwin IE on 15/04/2025.
//

//MARK: for elastic scroll stretch

import SwiftUI

extension View {
    @ViewBuilder
    func elasticScrol(scrollRect: CGRect, screenSize: CGSize) -> some View {
        self
            .modifier(ElasticScrollHelper(scrollRect: scrollRect, screenSize: screenSize))
    }
}

fileprivate struct ElasticScrollHelper: ViewModifier {
    var scrollRect: CGRect
    var screenSize: CGSize
    @State private var viewRect: CGRect = .zero
    func body(content: Content) -> some View {
        let progress = scrollRect.minY / scrollRect.maxY
        let elasticOffset = (progress * viewRect.minY) * 1.3
        let bottomProgress = max(1-(scrollRect.maxY / screenSize.height), 0)
        let bottomElasticOffset = (viewRect.maxY * bottomProgress) * 1.2
        content
            .offset(y: scrollRect.minY > 0 ? elasticOffset : 0)
            .offset(y: scrollRect.minY > 0 ? -(progress * scrollRect.minY) : 0)
            .offset(y: scrollRect.maxY < screenSize.height ? bottomElasticOffset : 0)
            .offsetExtractor(coordinateSpace: "SCROLLVIEW") {
                viewRect = $0
            }
    }
}
