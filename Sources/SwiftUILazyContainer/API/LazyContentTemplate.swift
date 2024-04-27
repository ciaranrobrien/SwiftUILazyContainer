/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public extension View {
    func lazyContentTemplate(
        _ axes: Axis.Set,
        @ViewBuilder template templateContent: @escaping () -> some View
    ) -> some View {
        modifier(LazyContentTemplateModifier(axes: axes, id: nil, templateContent: templateContent))
    }
    
    func lazyContentTemplate(
        _ axes: Axis.Set,
        id: some Hashable,
        @ViewBuilder template templateContent: @escaping () -> some View
    ) -> some View {
        modifier(LazyContentTemplateModifier(axes: axes, id: AnyHashable(id), templateContent: templateContent))
    }
}
