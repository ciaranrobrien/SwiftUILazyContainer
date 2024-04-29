/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct LazyStackLayout<Content, Data, ID>: View
where Content : View,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    @Environment(\.lazyContentLengths) private var contentLengths
    @Environment(\.lazyContainerRenderFrame) private var renderFrame
    @Environment(\.lazyLayoutOrigin) private var origin
    
    var alignment: Alignment
    var axis: Axis
    var content: (Data.Element) -> Content
    var data: Data
    var id: KeyPath<Data.Element, ID>
    var spacing: CGFloat
    
    var body: some View {
        ZStack(alignment: alignment) {
            ForEach(visibleData) { element in
                LazyStackElementContent(
                    axis: axis,
                    content: content,
                    element: element
                )
            }
        }
    }
    
    private var visibleData: [LazyElement<Data.Element, CGFloat, ID>] {
        let startIndex = data.startIndex
        let endIndex = data.endIndex
        
        guard let renderFrame, startIndex != endIndex
        else { return [] }
        
        let contentLengthCount = contentLengths.count
        let cgContentLengthCount = CGFloat(contentLengthCount)
        let avgLength = contentLengths.reduce(.zero) { $0 + $1 + spacing } / cgContentLengthCount
        let indexRange = startIndex...endIndex
        
        let (minOrigin, maxOrigin) = switch axis {
        case .horizontal: (renderFrame.minX, renderFrame.maxX)
        case .vertical: (renderFrame.minY, renderFrame.maxY)
        }
        
        let minIndexEst = (minOrigin + spacing - origin) / avgLength
        let minIndexRemainder = minIndexEst.truncatingRemainder(dividingBy: cgContentLengthCount)
        let minIndexThreshold = minIndexRemainder * avgLength
        var minIndex = Int(minIndexEst - minIndexRemainder)
        
        let maxIndexEst = (maxOrigin - origin) / avgLength
        let maxIndexRemainder = maxIndexEst.truncatingRemainder(dividingBy: cgContentLengthCount)
        let maxIndexThreshold = maxIndexRemainder * avgLength
        var maxIndex = Int(maxIndexEst - maxIndexRemainder) + 1
        
        _ = contentLengths.reduce(into: CGFloat.zero) { length, contentLength in
            length += contentLength + spacing
            if length < minIndexThreshold {
                minIndex += 1
            }
            if length < maxIndexThreshold {
                maxIndex += 1
            }
        }
        
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
            let (qIndex, rIndex) = index.quotientAndRemainder(dividingBy: contentLengthCount)
            let remainderLength = (0..<rIndex).reduce(.zero) { $0 + contentLengths[$1] + spacing }
            
            return LazyElement(
                element: element,
                id: element[keyPath: id],
                length: contentLengths[rIndex],
                offset: (CGFloat(qIndex * contentLengthCount) * avgLength) + remainderLength
            )
        }
    }
}


private struct LazyStackElementContent<Content, Element, ID>: View
where Content : View,
      ID : Hashable
{
    var axis: Axis
    var content: (Element) -> Content
    var element: LazyElement<Element, CGFloat, ID>
    
    var body: some View {
        switch axis {
        case .horizontal:
            ZStack {
                content(element.element)
            }
            .frame(width: element.length)
            .offset(x: element.offset)
            
        case .vertical:
            ZStack {
                content(element.element)
            }
            .frame(height: element.length)
            .offset(y: element.offset)
        }
    }
}
