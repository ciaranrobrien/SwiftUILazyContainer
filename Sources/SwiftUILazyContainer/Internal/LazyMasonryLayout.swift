/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct LazyMasonryLayout<Content, Data, ID>: View
where Content : View,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    @Environment(\.displayScale) private var displayScale
    @Environment(\.lazyMasonryElementLengths) private var elementLengths
    @Environment(\.lazyMasonryElementOffsets) private var elementOffsets
    @Environment(\.lazyMasonryElementVectors) private var elementVectors
    @Environment(\.lazyLayoutSize) private var layoutSize
    @Environment(\.lazyContainerRenderFrame) private var renderFrame
    @Environment(\.lazyLayoutOrigin) private var origin
    
    var alignment: Alignment
    var axis: Axis
    var content: (Data.Element) -> Content
    var data: Data
    var id: KeyPath<Data.Element, ID>
    var lines: Int
    var spacing: CGFloat
    
    var body: some View {
        ZStack(alignment: alignment) {
            ForEach(visibleData) { element in
                LazyMasonryElementContent(
                    axis: axis,
                    content: content,
                    element: element
                )
            }
        }
    }
    
    private var visibleData: [LazyElement<Data.Element, CGSize, ID>] {
        let startIndex = data.startIndex
        let endIndex = data.endIndex
        
        guard let renderFrame, startIndex != endIndex
        else { return [] }
        
        let (layoutLength, vectorSpan, minOrigin, midOrigin, maxOrigin) = switch axis {
        case .horizontal: (layoutSize.width, layoutSize.height, renderFrame.minX, renderFrame.midX, renderFrame.maxX)
        case .vertical: (layoutSize.height, layoutSize.width, renderFrame.minY, renderFrame.midY, renderFrame.maxY)
        }
        
        let vectorLength = ((vectorSpan + spacing) / CGFloat(lines)) - spacing
        let estimatedPosition = Double(data.count) * (midOrigin + (spacing / 2) - origin) / layoutLength
        let estimatedMidIndex = min(max(Int(round(estimatedPosition)) + startIndex, startIndex), endIndex - 1)
        let minOriginScaled = Int(round(minOrigin * displayScale))
        let maxOriginScaled = Int(round(maxOrigin * displayScale))
        
        var visibleIndices = Set<Int>()
        var linesRemaining: Int? = nil
        var minIndex = estimatedMidIndex
        var maxIndex = estimatedMidIndex
        
        // TODO: Fix bug where first and last elements are always visible.
        
        while minIndex >= startIndex {
            let threshold = Int(round((elementOffsets[minIndex] + elementLengths[minIndex] + origin) * displayScale))
            
            if threshold >= minOriginScaled {
                visibleIndices.insert(minIndex)
            } else if linesRemaining == nil {
                linesRemaining = lines
            }
            
            minIndex -= 1
            
            if let remaining = linesRemaining {
                linesRemaining = remaining - 1
                
                if remaining == .zero {
                    break
                }
            }
        }
        
        linesRemaining = nil
        
        while maxIndex < endIndex {
            let threshold = Int(round((elementOffsets[maxIndex] + origin) * displayScale))
            
            if threshold <= maxOriginScaled {
                visibleIndices.insert(maxIndex)
            } else if linesRemaining == nil {
                linesRemaining = lines
            }
            
            maxIndex += 1
            
            if let remaining = linesRemaining {
                linesRemaining = remaining - 1
                
                if remaining == .zero {
                    break
                }
            }
        }
        
        return visibleIndices.map { index in
            let element = data[index]
            let vectorOffset = elementVectors[index] * (vectorLength + spacing)
            
            let offset = CGSize(
                width: axis == .horizontal ? elementOffsets[index] : vectorOffset,
                height: axis == .vertical ? elementOffsets[index] : vectorOffset
            )
            let size = CGSize(
                width: axis == .horizontal ? elementLengths[index] : vectorLength,
                height: axis == .vertical ? elementLengths[index] : vectorLength
            )
            
            return LazyElement(
                element: element,
                id: element[keyPath: id],
                length: size,
                offset: offset
            )
        }
    }
}


private struct LazyMasonryElementContent<Content, Element, ID>: View
where Content : View,
      ID : Hashable
{
    var axis: Axis
    var content: (Element) -> Content
    var element: LazyElement<Element, CGSize, ID>
    
    var body: some View {
        ZStack {
            content(element.element)
        }
        .frame(width: element.length.width, height: element.length.height)
        .offset(element.offset)
    }
}
