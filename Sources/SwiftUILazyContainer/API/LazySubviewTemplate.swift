/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public extension View {
    
    /// Sets the hidden template content for sizing subviews in the lazy container.
    func lazySubviewTemplate() -> some View {
        anchorPreference(key: LazySubviewTemplateAnchorsKey.self, value: .bounds) { [.none : $0] }
    }
    
    /// Sets the hidden template content for sizing subviews in the lazy container.
    ///
    /// - Parameters:
    ///   - id: The identifier of the hidden template content.
    func lazySubviewTemplate(id: some Hashable) -> some View {
        anchorPreference(key: LazySubviewTemplateAnchorsKey.self, value: .bounds) { [id : $0] }
    }
}
