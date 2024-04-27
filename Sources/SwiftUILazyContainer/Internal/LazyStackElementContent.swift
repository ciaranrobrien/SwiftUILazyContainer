/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct LazyStackElementContent<Content, Element, ID>: View
where Content : View,
      ID : Hashable
{
    var axis: Axis
    var content: (Element) -> Content
    var visibleElement: VisibleElement<Element, ID>
    
    var body: some View {
        switch axis {
        case .horizontal:
            ZStack {
                content(visibleElement.element)
            }
            .frame(width: visibleElement.length)
            .offset(x: visibleElement.offset)
            
        case .vertical:
            ZStack {
                content(visibleElement.element)
            }
            .frame(height: visibleElement.length)
            .offset(y: visibleElement.offset)
        }
    }
}
