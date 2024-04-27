/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyContent<Content>: View
where Content : View
{
    @Environment(\.lazyContainerSize) private var containerSize
    @Environment(\.lazyContainerRenderFrame) private var renderFrame
    @Environment(\.lazyContentTemplateSizes) private var templates
    
    internal var content: () -> Content
    internal var size: LazyContentAnchor<CGSize>
    
    public var body: some View {
        if let renderFrame, let resolvedSize {
            GeometryReader { geometry in
                if renderFrame.intersects(geometry.frame(in: .global)) {
                    ZStack(content: content)
                }
            }
            .frame(width: resolvedSize.width, height: resolvedSize.height)
        }
    }
    
    private var resolvedSize: CGSize? {
        switch size.source {
        case .fixed(let size):
            size
        case .fraction(let fraction):
            if let containerSize {
                CGSize(width: containerSize.width * fraction.width, height: containerSize.height * fraction.height)
            } else {
                nil
            }
        case .template(let id):
            templates[id]
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
    init(size: LazyContentAnchor<CGSize>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.size = size
    }
}
