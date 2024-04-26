/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyContainerHContent<Content>: View
where Content : View
{
    @Environment(\.lazyContainerFrame) private var container
    
    internal var content: () -> Content
    internal var width: CGFloat
    
    public var body: some View {
        GeometryReader { geometry in
            if isVisible(for: geometry) {
                HStack(content: content)
            }
        }
        .frame(width: width)
    }
    
    private func isVisible(for geometry: GeometryProxy) -> Bool {
        if let container {
            ((container.minX - width)...container.maxX).contains(geometry.frame(in: .global).minX)
        } else {
            false
        }
    }
}


public extension LazyContainerHContent {
    /// A view that only renders its content when visible in a lazy horizontal container.
    ///
    /// Use `LazyContainerHStack` instead for improved performance.
    ///
    /// - Parameters:
    ///   - width: A fixed width for the view.
    ///   - content: The lazy content of this view. Avoid persisting state inside
    ///     the content.
    init(width: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.width = width
    }
}
