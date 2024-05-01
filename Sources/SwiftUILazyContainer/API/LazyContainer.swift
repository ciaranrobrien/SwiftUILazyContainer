/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public extension View {
    
    /// Configures the outermost container for lazy subview rendering.
    ///
    /// - Parameters:
    ///   - padding: The invisible padding around the container that extends the area in
    ///     which subviews are rendered.
    ///   - safeAreaEdges: The set of safe area edges to render subviews in.
    func lazyContainer(
        renderingPadding padding: Double = .zero,
        rendersInSafeAreaEdges safeAreaEdges: Edge.Set = .all
    ) -> some View {
        modifier(LazyContainerModifier(padding: padding, safeAreaEdges: safeAreaEdges, templates: { EmptyView() }))
    }
    
    /// Configures the outermost container for lazy subview rendering.
    ///
    /// - Parameters:
    ///   - insets: The invisible insets around the container that extend the area in
    ///     which subviews are rendered.
    ///   - safeAreaEdges: The set of safe area edges to render subviews in.
    func lazyContainer(
        renderingInsets insets: EdgeInsets,
        rendersInSafeAreaEdges safeAreaEdges: Edge.Set = .all
    ) -> some View {
        modifier(LazyContainerModifier(insets: insets, safeAreaEdges: safeAreaEdges, templates: { EmptyView() }))
    }
    
    /// Configures the outermost container for lazy subview rendering.
    ///
    /// - Parameters:
    ///   - padding: The invisible padding around the container that extends the area in
    ///     which subviews are rendered.
    ///   - safeAreaEdges: The set of safe area edges to render subviews in.
    ///   - templates: The hidden template content for sizing subviews. Use
    ///     `lazySubviewTemplate` on each template.
    func lazyContainer(
        renderingPadding padding: Double = .zero,
        rendersInSafeAreaEdges safeAreaEdges: Edge.Set = .all,
        @ViewBuilder templates: @escaping () -> some View
    ) -> some View {
        modifier(LazyContainerModifier(padding: padding, safeAreaEdges: safeAreaEdges, templates: templates))
    }
    
    /// Configures the outermost container for lazy subview rendering.
    ///
    /// - Parameters:
    ///   - insets: The invisible insets around the container that extend the area in
    ///     which subviews are rendered.
    ///   - safeAreaEdges: The set of safe area edges to render subviews in.
    ///   - templates: The hidden template content for sizing subviews. Use
    ///     `lazySubviewTemplate` on each template.
    func lazyContainer(
        renderingInsets insets: EdgeInsets,
        rendersInSafeAreaEdges safeAreaEdges: Edge.Set = .all,
        @ViewBuilder templates: @escaping () -> some View
    ) -> some View {
        modifier(LazyContainerModifier(insets: insets, safeAreaEdges: safeAreaEdges, templates: templates))
    }
}
