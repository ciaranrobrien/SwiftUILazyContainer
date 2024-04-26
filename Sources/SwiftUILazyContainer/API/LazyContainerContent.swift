/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyContainerContent<Content>: View
where Content : View
{
    @Environment(\.lazyContainerFrame) private var container
    
    internal var content: () -> Content
    internal var height: CGFloat
    internal var width: CGFloat
    
    public var body: some View {
        GeometryReader { geometry in
            if isVisible(for: geometry) {
                ZStack(content: content)
            }
        }
        .frame(width: width, height: height)
    }
    
    private func isVisible(for geometry: GeometryProxy) -> Bool {
        if let container {
            container.intersects(geometry.frame(in: .global))
        } else {
            false
        }
    }
}


public extension LazyContainerContent {
    /// A view that only renders its content when visible in a lazy container.
    ///
    /// Use `LazyContainerStack` instead for improved performance.
    ///
    /// Use `LazyContainerHContent` or `LazyContainerVContent`instead
    /// when the container's scrolling is limited to a single axis.
    ///
    /// - Parameters:
    ///   - width: A fixed width for the view.
    ///   - height: A fixed height for the view.
    ///   - content: The lazy content of this view. Avoid persisting state inside
    ///     the content.
    init(width: CGFloat, height: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.height = height
        self.width = width
    }
    
    /// A view that only renders its content when visible in a lazy container.
    ///
    /// Use `LazyContainerStack` instead for improved performance.
    ///
    /// Use `LazyContainerHContent` or `LazyContainerVContent`instead
    /// when the container's scrolling is limited to a single axis.
    ///
    /// - Parameters:
    ///   - size: A fixed size for the view.
    ///   - content: The lazy content of this view. Avoid persisting state inside
    ///     the content.
    init(size: CGSize, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.height = size.height
        self.width = size.width
    }
}
