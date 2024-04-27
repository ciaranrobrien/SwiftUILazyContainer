/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Use `LazyVContent` for lazy rendering in any layout. Note that, when used
/// frequently,`LazyVContent` can impact scroll performance.
///
/// Use `fraction` to fix lazy content height at a fraction of the lazy container's height.
private struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<100) { number in
                    LazyVContent(height: .fraction(1/3)) {
                        /// Lazy content
                    }
                }
            }
        }
        .lazyContainer()
    }
}
