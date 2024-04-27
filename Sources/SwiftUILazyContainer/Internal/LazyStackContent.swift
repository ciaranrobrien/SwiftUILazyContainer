/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct LazyStackContent<Content, Data, ID>: View
where Content : View,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    @Environment(\.lazyContainerRenderFrame) private var renderFrame
    @Environment(\.lazyStackGeometry) private var geometry
    
    var alignment: Alignment
    var axis: Axis
    var content: (Data.Element) -> Content
    var data: Data
    var id: KeyPath<Data.Element, ID>
    var spacing: CGFloat
    
    var body: some View {
        ZStack(alignment: alignment) {
            ForEach(visibleData) { visibleElement in
                LazyStackElementContent(
                    axis: axis,
                    content: content,
                    visibleElement: visibleElement
                )
            }
        }
    }
    
    private var visibleData: [VisibleElement<Data.Element, ID>] {
        let startIndex = data.startIndex
        let endIndex = data.endIndex
        
        guard let renderFrame, startIndex != endIndex
        else { return [] }
        
        let elementLength = geometry.first + spacing
        let indexRange = startIndex...endIndex
        
        let (minOrigin, maxOrigin) = switch axis {
        case .horizontal: (renderFrame.minX, renderFrame.maxX)
        case .vertical: (renderFrame.minY, renderFrame.maxY)
        }
        
        var minIndex = Int(floor((minOrigin + spacing - geometry.second) / elementLength)) + startIndex
        var maxIndex = Int(ceil((maxOrigin - geometry.second) / elementLength)) + startIndex
        var indicesWithinBounds = false
        
        if indexRange.contains(minIndex) {
            indicesWithinBounds = true
        } else {
            minIndex = startIndex
        }
        
        if indexRange.contains(maxIndex) {
            indicesWithinBounds = true
        } else {
            maxIndex = endIndex
        }
        
        guard indicesWithinBounds
        else { return [] }
        
        return (minIndex..<maxIndex).map { index in
            let element = data[index]
            return VisibleElement(
                element: element,
                id: element[keyPath: id],
                length: geometry.first,
                offset: CGFloat(index) * elementLength
            )
        }
    }
}