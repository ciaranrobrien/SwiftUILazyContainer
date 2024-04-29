/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyVContent<Content>: View
where Content : View
{
    @Environment(\.lazyContainerSize) private var containerSize
    @Environment(\.lazyContainerRenderFrame) private var renderFrame
    @Environment(\.lazyContentTemplateSizes) private var templates
    
    internal var content: () -> Content
    internal var height: LazyContentAnchor<CGFloat>
    
    public var body: some View {
        if let resolvedHeight {
            GeometryReader { geometry in
                if isVisible(for: geometry, and: resolvedHeight) {
                    ZStack(content: content)
                }
            }
            .frame(height: resolvedHeight)
        }
    }
    
    private var resolvedHeight: CGFloat? {
        if let containerSize {
            height.resolve(axis: .vertical, containerSize: containerSize, templates: templates)
        } else {
            nil
        }
    }
    
    private func isVisible(for geometry: GeometryProxy, and resolvedHeight: CGFloat) -> Bool {
        if let renderFrame {
            ((renderFrame.minY - resolvedHeight)...renderFrame.maxY).contains(geometry.frame(in: .global).minY)
        } else {
            false
        }
    }
}


public extension LazyVContent {
    /// A view that only renders its content when visible in a lazy vertical container.
    ///
    /// Use `AltLazyVStack` instead for improved performance.
    ///
    /// - Parameters:
    ///   - height: A height for the view.
    ///   - content: The lazy content of this view. Avoid persisting state inside
    ///     the content.
    init(height: LazyContentAnchor<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.height = height
    }
}
