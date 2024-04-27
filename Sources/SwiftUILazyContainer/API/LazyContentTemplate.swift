/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public extension View {
    /// Sets the hidden template content for sizing subviews in the lazy container.
    ///
    /// - Parameters:
    ///   - axes: The axes of the lazy container.
    ///   - templateContent: The hidden template content.
    func lazyContentTemplate(
        _ axes: Axis.Set,
        @ViewBuilder template templateContent: @escaping () -> some View
    ) -> some View {
        modifier(LazyContentTemplateModifier(axes: axes, id: nil, templateContent: templateContent))
    }
    
    /// Sets the hidden template content for sizing subviews in the lazy container.
    ///
    /// - Parameters:
    ///   - axes: The axes of the lazy container.
    ///   - id: The identifier of the hidden template content.
    ///   - templateContent: The hidden template content.
    func lazyContentTemplate(
        _ axes: Axis.Set,
        id: some Hashable,
        @ViewBuilder template templateContent: @escaping () -> some View
    ) -> some View {
        modifier(LazyContentTemplateModifier(axes: axes, id: AnyHashable(id), templateContent: templateContent))
    }
}
