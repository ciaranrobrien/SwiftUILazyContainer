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
    @Environment(\.lazyLayoutLength) private var layoutLength
    @Environment(\.lazyLayoutLines) private var layoutLines
    @Environment(\.lazyLayoutOrigin) private var layoutOrigin
    @Environment(\.lazyContainerRenderFrame) private var renderFrame
    @Environment(\.lazySubviewLengths) private var subviewLengths
    @Environment(\.lazySubviewOffsets) private var subviewOffsets
    @Environment(\.lazySubviewLineBreadths) private var subviewLineBreadths
    @Environment(\.lazySubviewLineOffsets) private var subviewLineOffsets
    
    var axis: Axis
    var content: (Data.Element) -> Content
    var data: Data
    var id: KeyPath<Data.Element, ID>
    var spacing: Double
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(visibleData) { element in
                LazyMasonryElementContent(
                    axis: axis,
                    content: content,
                    element: element
                )
            }
        }
    }
    
    private var visibleData: [VisibleElement<Data.Element, ID, CGSize>] {
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
        var linesRemaining: Int? = nil
        var minIndex = estimatedMidIndex
        var maxIndex = estimatedMidIndex
        
        // TODO: Fix bug where first and last elements are always visible.
        
        while minIndex >= startIndex {
            let threshold = Int(round((subviewOffsets[minIndex] + subviewLengths[minIndex] + layoutOrigin) * displayScale))
            
            if threshold >= minOriginScaled {
                visibleIndices.insert(minIndex)
            } else if linesRemaining == nil {
                linesRemaining = layoutLines
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
            let threshold = Int(round((subviewOffsets[maxIndex] + layoutOrigin) * displayScale))
            
            if threshold <= maxOriginScaled {
                visibleIndices.insert(maxIndex)
            } else if linesRemaining == nil {
                linesRemaining = layoutLines
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
            
            let offset = CGSize(
                width: axis == .horizontal ? subviewOffsets[index] : subviewLineOffsets[index],
                height: axis == .vertical ? subviewOffsets[index] : subviewLineOffsets[index]
            )
            let size = CGSize(
                width: axis == .horizontal ? subviewLengths[index] : subviewLineBreadths[index],
                height: axis == .vertical ? subviewLengths[index] : subviewLineBreadths[index]
            )
            
            return VisibleElement(
                element: element,
                id: element[keyPath: id],
                offset: offset,
                size: size
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
    var element: VisibleElement<Element, ID, CGSize>
    
    var body: some View {
        ZStack {
            content(element.element)
        }
        .environment(\._resolvedLazySubviewSize, element.size)
        .frame(width: element.size.width, height: element.size.height)
        .offset(element.offset)
    }
}
