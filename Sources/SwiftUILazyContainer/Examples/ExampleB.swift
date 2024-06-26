/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Use `LazyVMasonry` to arrange subviews in a vertical masonry with lazy rendering.
///
/// Use `contentHeights` for a repeating pattern of subview heights.
///
/// Use `renderingPadding` and `rendersInSafeAreaEdges` to control how far
/// away from the container's edges subviews are rendered.
private struct ContentView: View {
    var data: [FooElement]
    
    var body: some View {
        ScrollView {
            LazyVMasonry(data, columns: 2, contentHeights: [.fraction(1/4), .fraction(1/5)]) { element in
                FooContent(element: element)
            }
        }
        .lazyContainer(renderingPadding: 16, rendersInSafeAreaEdges: .all)
    }
}


/// Use `task`, `onAppear` and `onDisappear` to start and cancel async loading when
/// the lazy subview is rendered. Persist any state outside of the lazy subview.
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
