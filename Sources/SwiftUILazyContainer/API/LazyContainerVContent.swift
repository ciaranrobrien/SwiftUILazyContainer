/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyContainerVContent<Content>: View
where Content : View
{
    @Environment(\.lazyContainerFrame) private var container
    
    internal var content: () -> Content
    internal var height: CGFloat
    
    public var body: some View {
        GeometryReader { geometry in
            if isVisible(for: geometry) {
                VStack(content: content)
            }
        }
        .frame(height: height)
    }
    
    private func isVisible(for geometry: GeometryProxy) -> Bool {
        if let container {
            ((container.minY - height)...container.maxY).contains(geometry.frame(in: .global).minY)
        } else {
            false
        }
    }
}


public extension LazyContainerVContent {
    /// A view that only renders its content when visible in a lazy vertical container.
    ///
    /// Use `LazyContainerVStack` instead for improved performance.
    ///
    /// - Parameters:
    ///   - height: A fixed height for the view.
    ///   - content: The lazy content of this view. Avoid persisting state inside
    ///     the content.
    init(height: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.height = height
    }
}
