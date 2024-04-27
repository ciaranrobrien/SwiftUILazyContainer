/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyVContent<Content>: View
where Content : View
{
    @Environment(\.lazyContainerFrame) private var container
    @Environment(\.lazyContentTemplateSizes) private var templates
    
    internal var content: () -> Content
    internal var height: LazyContentGeometry<CGFloat>
    
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
        switch height {
        case .fixed(let height): height
        case .template(let id): templates[id]?.height
        }
    }
    
    private func isVisible(for geometry: GeometryProxy, and resolvedHeight: CGFloat) -> Bool {
        if let container {
            ((container.minY - resolvedHeight)...container.maxY).contains(geometry.frame(in: .global).minY)
        } else {
            false
        }
    }
}


public extension LazyVContent {
    /// A view that only renders its content when visible in a lazy vertical container.
    ///
    /// Use `VeryLazyVStack` instead for improved performance.
    ///
    /// - Parameters:
    ///   - height: A fixed height for the view.
    ///   - content: The lazy content of this view. Avoid persisting state inside
    ///     the content.
    init(height: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.height = .fixed(height)
    }
    
    /// A view that only renders its content when visible in a lazy vertical container.
    ///
    /// Use `VeryLazyVStack` instead for improved performance.
    ///
    /// - Parameters:
    ///   - height: A height for the view.
    ///   - content: The lazy content of this view. Avoid persisting state inside
    ///     the content.
    init(height: LazyContentGeometry<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.height = height
    }
}
