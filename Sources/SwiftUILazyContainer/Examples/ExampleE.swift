/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Use the `contentHeight` closure to resolve subview heights for each element.
///
/// Combine `LazyContentAnchor` values with `+` or `sum` to build subview heights
/// from multiple anchors.
///
/// Provide multiple template views to `lazyContainer`. Assign each template a unique
/// identifier to resolve different template sizes during layout.
private struct ContentView: View {
    var data: [FooElement]
    
    var body: some View {
        ScrollView {
            LazyVMasonry(data, columns: 2, spacing: 0) { element in
                /// Lazy content
            } contentHeight: { element in
                if element.hasSubtitle {
                    120 + .template(id: 2)
                } else {
                    80 + .template(id: 1)
                }
            }
        }
        .lazyContainer {
            Text(verbatim: "Title Placeholder")
                .font(.headline)
                .lineLimit(1)
                .lazyContentTemplate(id: 1)
            
            VStack {
                Text(verbatim: "Title Placeholder")
                    .font(.headline)
                
                Text(verbatim: "Subtitle Placeholder")
                    .font(.subheadline)
            }
            .lineLimit(1)
            .lazyContentTemplate(id: 2)
        }
    }
}


private struct FooElement: Identifiable {
    let id: UUID
    let hasSubtitle: Bool
}
