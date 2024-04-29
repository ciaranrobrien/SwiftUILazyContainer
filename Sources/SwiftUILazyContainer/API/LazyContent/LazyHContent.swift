/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyHContent<Content>: View
where Content : View
{
    @Environment(\.lazyContainerSize) private var containerSize
    @Environment(\.lazyContainerRenderFrame) private var renderFrame
    @Environment(\.lazyContentTemplateSizes) private var templates
    
    internal var content: () -> Content
    internal var width: LazyContentAnchor<CGFloat>
    
    public var body: some View {
        if let resolvedWidth {
            GeometryReader { geometry in
                if isVisible(for: geometry, and: resolvedWidth) {
                    ZStack(content: content)
                }
            }
            .frame(width: resolvedWidth)
        }
    }
    
    private var resolvedWidth: CGFloat? {
        if let containerSize {
            width.resolve(axis: .horizontal, containerSize: containerSize, templates: templates)
        } else {
            nil
        }
    }
    
    private func isVisible(for geometry: GeometryProxy, and resolvedWidth: CGFloat) -> Bool {
        if let renderFrame {
            ((renderFrame.minX - resolvedWidth)...renderFrame.maxX).contains(geometry.frame(in: .global).minX)
        } else {
            false
        }
    }
}


public extension LazyHContent {
    /// A view that only renders its content when visible in a lazy horizontal container.
    ///
    /// Use `AltLazyHStack` instead for improved performance.
    ///
    /// - Parameters:
    ///   - width: A width for the view.
    ///   - content: The lazy content of this view. Avoid persisting state inside
    ///     the content.
    init(width: LazyContentAnchor<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.width = width
    }
}
