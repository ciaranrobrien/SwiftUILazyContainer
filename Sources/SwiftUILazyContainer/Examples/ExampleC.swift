/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Use `template` and `lazySubviewTemplate` to provide hidden template views for
/// sizing lazy subviews.
///
/// Combine lazy and non-lazy content in the same scroll view.
private struct ContentView: View {
    var data: [FooElement]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<3) { number in
                    /// Non-lazy content
                }
                
                AltLazyVStack(data, contentHeight: .template) { element in
                    /// Lazy content
                }
            }
        }
        .lazyContainer {
            VStack {
                Text(verbatim: "Placeholder")
                    .font(.headline)
                
                Text(verbatim: "Placeholder")
                    .font(.subheadline)
            }
            .padding()
            .lineLimit(1)
            .lazySubviewTemplate()
        }
    }
}


private struct FooElement: Identifiable {
    let id: UUID
}
