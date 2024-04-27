/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Use `lazyContentTemplate` to provide a hidden template view to size lazy content.
///
/// Use `renderingPadding` and `rendersInSafeAreaEdges` to control how far
/// away from the container's edges content is rendered.
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
                
                VeryLazyVStack(data, contentHeight: .template) { element in
                    FooContent(element: element)
                }
            }
        }
        .lazyContainer(renderingPadding: 16, rendersInSafeAreaEdges: .all)
        .lazyContentTemplate(.vertical) {
            VStack {
                Text(verbatim: "Placeholder")
                    .font(.headline)
                
                Text(verbatim: "Placeholder")
                    .font(.subheadline)
            }
        }
    }
}


/// Use `task`, `onAppear` and `onDisappear` to start and cancel async loading when
/// the lazy view is rendered. Persist any state outside of the lazy view.
private struct FooContent: View {
    var element: FooElement
    
    var body: some View {
        VStack {
            /// Content
        }
        .onAppear {
            /// Start async loading
        }
        .onDisappear {
            /// Cancel async loading
        }
    }
}


private struct FooElement: Identifiable {
    let id: UUID
}
