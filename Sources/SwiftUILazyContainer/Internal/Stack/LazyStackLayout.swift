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
    @Environment(\.displayScale) private var displayScale
    @Environment(\.lazyLayoutLength) private var layoutLength
    @Environment(\.lazyLayoutOrigin) private var layoutOrigin
    @Environment(\.lazyContainerRenderFrame) private var renderFrame
    @Environment(\.lazySubviewLengths) private var subviewLengths
    @Environment(\.lazySubviewOffsets) private var subviewOffsets
    
    var alignment: Alignment
    var axis: Axis
    var content: (Data.Element) -> Content
    var data: Data
    var id: KeyPath<Data.Element, ID>
    var layoutBreadth: Double
    var spacing: Double
    
    var body: some View {
        ZStack(alignment: alignment) {
            ForEach(visibleData) { element in
                LazyStackElementContent(
                    axis: axis,
                    content: content,
                    element: element,
                    layoutBreadth: layoutBreadth
                )
            }
        }
    }
    
    private var visibleData: [VisibleElement<Data.Element, ID, Double>] {
        let startIndex = data.startIndex
        let endIndex = data.endIndex
        
        guard let renderFrame, startIndex != endIndex
        else { return [] }
        
        let (minOrigin, midOrigin, maxOrigin) = switch axis {
        case .horizontal: (renderFrame.minX, renderFrame.midX, renderFrame.maxX)
        case .vertical: (renderFrame.minY, renderFrame.midY, renderFrame.maxY)
        }
        
        let estimatedPosition = Double(data.count) * (midOrigin + (spacing / 2) - layoutOrigin) / layoutLength
        let estimatedMidIndex = min(max(Int(round(estimatedPosition)) + startIndex, startIndex), endIndex - 1)
        let minOriginScaled = Int(round(minOrigin * displayScale))
        let maxOriginScaled = Int(round(maxOrigin * displayScale))
        
        var visibleIndices = Set<Int>()
        var minIndex = estimatedMidIndex
        var maxIndex = estimatedMidIndex
        
        // TODO: Fix bug where first and last elements are always visible.
        
        while minIndex >= startIndex {
            let threshold = Int(round((subviewOffsets[minIndex] + subviewLengths[minIndex] + layoutOrigin) * displayScale))
            
            if threshold >= minOriginScaled {
                visibleIndices.insert(minIndex)
                minIndex -= 1
            } else {
                break
            }
        }
        
        while maxIndex < endIndex {
            let threshold = Int(round((subviewOffsets[maxIndex] + layoutOrigin) * displayScale))
            
            if threshold <= maxOriginScaled {
                visibleIndices.insert(maxIndex)
                maxIndex += 1
            } else {
                break
            }
        }
        
        return visibleIndices.map { index in
            let element = data[index]
            
            return VisibleElement(
                element: element,
                id: element[keyPath: id],
                offset: subviewOffsets[index],
                size: subviewLengths[index]
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
    var element: VisibleElement<Element, ID, Double>
    var layoutBreadth: Double
    
    var body: some View {
        switch axis {
        case .horizontal:
            ZStack {
                content(element.element)
            }
            .environment(\._resolvedLazySubviewSize, .init(width: element.size, height: layoutBreadth))
            .frame(width: element.size)
            .offset(x: element.offset)
            
        case .vertical:
            ZStack {
                content(element.element)
            }
            .environment(\._resolvedLazySubviewSize, .init(width: layoutBreadth, height: element.size))
            .frame(height: element.size)
            .offset(y: element.offset)
        }
    }
}
