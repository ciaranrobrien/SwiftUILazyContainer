/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Use the `contentHeight` closure to resolve subview heights for each element.
///
/// Combine `LazySubviewSize` values with `+` or `sum` to build subview heights
/// from multiple anchors.
///
/// Provide multiple template views to `lazyContainer`. Assign each template a unique
/// identifier to resolve different template sizes during layout.
private struct ContentView: View {
    var data: [FooElement]
    
    var body: some View {
        ScrollView {
            LazyVMasonry(data, columns: .adaptive(minSize: 140), spacing: 8) { element in
                /// Lazy content
            } contentHeight: { element in
                let imageAnchor = LazySubviewSize.aspect(element.imageSize.width / element.imageSize.height)
                let titleAnchor = LazySubviewSize.template(id: element.subtitle == nil ? 1 : 2)
                return imageAnchor + titleAnchor
            }
        }
        .lazyContainer {
            Text(verbatim: "Title Placeholder")
                .font(.headline)
                .padding()
                .lineLimit(1)
                .lazySubviewTemplate(id: 1)
            
            VStack {
                Text(verbatim: "Title Placeholder")
                    .font(.headline)
                
                Text(verbatim: "Subtitle Placeholder")
                    .font(.subheadline)
            }
            .padding()
            .lineLimit(1)
            .lazySubviewTemplate(id: 2)
        }
    }
}


private struct FooElement: Identifiable {
    let id: UUID
    let imageSize: CGSize
    let imageURL: URL
    let title: String
    let subtitle: String?
}
