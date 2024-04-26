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
    @Environment(\.lazyContainerFrame) private var container
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
                    alignment: alignment,
                    axis: axis,
                    content: content,
                    spacing: spacing,
                    visibleElement: visibleElement
                )
            }
        }
    }
    
    private var visibleData: [VisibleElement<Data.Element, ID>] {
        let startIndex = data.startIndex
        let endIndex = data.endIndex
        
        guard let container, startIndex != endIndex
        else { return [] }
        
        let elementLength = (geometry.first + spacing) / CGFloat(data.count)
        let contentLength = elementLength - spacing
        let indexRange = startIndex...endIndex
        
        let (minOrigin, maxOrigin) = switch axis {
        case .horizontal: (container.minX, container.maxX)
        case .vertical: (container.minY, container.maxY)
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
                length: contentLength,
                offset: CGFloat(index) * elementLength
            )
        }
    }
}
