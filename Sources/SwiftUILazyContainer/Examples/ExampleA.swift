/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Use `lazyContainer` to configure the scroll view for lazy rendering.
///
/// Use `VeryLazyVStack` as a replacement for `VStack` or `LazyVStack`
/// to only render its content when visible in the scroll view.
private struct ContentView: View {
    var data: [FooElement]
    
    var body: some View {
        ScrollView {
            VeryLazyVStack(data, contentHeight: 200) { element in
                /// Lazy content
            }
        }
        .lazyContainer()
    }
}


private struct FooElement: Identifiable {
    let id: UUID
}
