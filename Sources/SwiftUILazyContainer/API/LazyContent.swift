/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyContent<Content>: View
where Content : View
{
    @Environment(\.lazyContainerFrame) private var container
    @Environment(\.lazyContentTemplateSizes) private var templates
    
    internal var content: () -> Content
    internal var size: LazyContentGeometry<CGSize>
    
    public var body: some View {
        if let resolvedSize {
            GeometryReader { geometry in
                if isVisible(for: geometry) {
                    ZStack(content: content)
                }
            }
            .frame(width: resolvedSize.width, height: resolvedSize.height)
        }
    }
    
    private var resolvedSize: CGSize? {
        switch size {
        case .fixed(let size): size
        case .template(let id): templates[id]
        }
    }
    
    private func isVisible(for geometry: GeometryProxy) -> Bool {
        if let container {
            container.intersects(geometry.frame(in: .global))
        } else {
            false
        }
    }
}


public extension LazyContent {
    /// A view that only renders its content when visible in a lazy container.
    ///
    /// Use `VeryLazyStack` instead for improved performance.
    ///
    /// Use `LazyHContent` or `LazyVContent`instead
    /// when the container's scrolling is limited to a single axis.
    ///
    /// - Parameters:
    ///   - width: A fixed width for the view.
    ///   - height: A fixed height for the view.
    ///   - content: The lazy content of this view. Avoid persisting state inside
    ///     the content.
    init(width: CGFloat, height: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.size = .fixed(.init(width: width, height: height))
    }
    
    /// A view that only renders its content when visible in a lazy container.
    ///
    /// Use `VeryLazyStack` instead for improved performance.
    ///
    /// Use `LazyHContent` or `LazyVContent`instead
    /// when the container's scrolling is limited to a single axis.
    ///
    /// - Parameters:
    ///   - size: A fixed size for the view.
    ///   - content: The lazy content of this view. Avoid persisting state inside
    ///     the content.
    init(size: CGSize, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.size = .fixed(size)
    }
    
    /// A view that only renders its content when visible in a lazy container.
    ///
    /// Use `VeryLazyStack` instead for improved performance.
    ///
    /// Use `LazyHContent` or `LazyVContent`instead
    /// when the container's scrolling is limited to a single axis.
    ///
    /// - Parameters:
    ///   - size: A size for the view.
    ///   - content: The lazy content of this view. Avoid persisting state inside
    ///     the content.
    init(size: LazyContentGeometry<CGSize>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.size = size
    }
}
