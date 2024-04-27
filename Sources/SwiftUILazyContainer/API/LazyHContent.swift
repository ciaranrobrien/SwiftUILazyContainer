/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyHContent<Content>: View
where Content : View
{
    @Environment(\.lazyContainerFrame) private var container
    @Environment(\.lazyContentTemplateSizes) private var templates
    
    internal var content: () -> Content
    internal var width: LazyContentGeometry<CGFloat>
    
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
        switch width {
        case .fixed(let width): width
        case .template(let id): templates[id]?.width
        }
    }
    
    private func isVisible(for geometry: GeometryProxy, and resolvedWidth: CGFloat) -> Bool {
        if let container {
            ((container.minX - resolvedWidth)...container.maxX).contains(geometry.frame(in: .global).minX)
        } else {
            false
        }
    }
}


public extension LazyHContent {
    /// A view that only renders its content when visible in a lazy horizontal container.
    ///
    /// Use `VeryLazyHStack` instead for improved performance.
    ///
    /// - Parameters:
    ///   - width: A fixed width for the view.
    ///   - content: The lazy content of this view. Avoid persisting state inside
    ///     the content.
    init(width: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.width = .fixed(width)
    }
    
    /// A view that only renders its content when visible in a lazy horizontal container.
    ///
    /// Use `VeryLazyHStack` instead for improved performance.
    ///
    /// - Parameters:
    ///   - width: A width for the view.
    ///   - content: The lazy content of this view. Avoid persisting state inside
    ///     the content.
    init(width: LazyContentGeometry<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.width = width
    }
}
