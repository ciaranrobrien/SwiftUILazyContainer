/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public extension View {
    /// Sets the hidden template content for sizing subviews in the lazy container.
    func lazyContentTemplate() -> some View {
        transformPreference(LazyContentTemplateAnchorsKey.self) { $0[.none] = .empty }
    }
    
    /// Sets the hidden template content for sizing subviews in the lazy container.
    ///
    /// - Parameters:
    ///   - id: The identifier of the hidden template content.
    func lazyContentTemplate(id: some Hashable) -> some View {
        transformPreference(LazyContentTemplateAnchorsKey.self) { $0[id] = .empty }
    }
}
