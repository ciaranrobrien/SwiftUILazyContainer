/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public extension EnvironmentValues {
    
    /// The size of the parent lazy subview.
    ///
    /// Returns `.zero` if read from outside of a lazy subview.
    var resolvedLazySubviewSize: CGSize {
        _resolvedLazySubviewSize
    }
}
