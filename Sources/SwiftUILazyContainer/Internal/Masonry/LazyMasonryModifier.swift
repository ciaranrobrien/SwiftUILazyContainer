/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct LazyMasonryModifier<Data, Sizes>: ViewModifier
where Sizes : RandomAccessCollection,
      Sizes.Element == LazySubviewSize,
      Data : RandomAccessCollection
{
    @Environment(\.lazyContainerSize) private var containerSize
    @Environment(\.displayScale) private var displayScale
    @Environment(\.lazySubviewTemplateSizes) private var templates
    
    var axis: Axis
    var contentSizeProvider: LazySubviewSizeProvider<Data.Element, Sizes>
    var data: Data
    var lineBreadths: [Double]
    var spacing: Double
    
    func body(content: Content) -> some View {
        if let (length, subviewLengths, subviewOffsets, subviewLineBreadths, subviewLineOffsets) = resolved {
            content
                .environment(\.lazyLayoutLines, lineBreadths.count)
                .modifier(AnimatableEnvironment(\.lazySubviewLengths, subviewLengths))
                .modifier(AnimatableEnvironment(\.lazySubviewOffsets, subviewOffsets))
                .modifier(AnimatableEnvironment(\.lazySubviewLineBreadths, subviewLineBreadths))
                .modifier(AnimatableEnvironment(\.lazySubviewLineOffsets, subviewLineOffsets))
                .frame(
                    width: axis == .horizontal ? length : nil,
                    height: axis == .vertical ? length : nil
                )
        }
    }
    
    private var resolved: (Double, [Double], [Double], [Double], [Double])? {
        guard !data.isEmpty, let containerSize
        else { return nil }
        
        let containerLength: Double = switch axis {
        case .horizontal: containerSize.width
        case .vertical: containerSize.height
        }
        
        let lineCount = lineBreadths.count
        let equalityTolerance = displayScale / 2
        
        let lineOffsets = lineBreadths.reduce(into: [Double]()) { offsets, breadth in
            if let last = offsets.last {
                offsets.append(last + breadth + spacing)
            } else {
                offsets.append(.zero)
                offsets.append(breadth + spacing)
            }
        }
        
        var lineIndex = 0
        var lineLengths = Array(repeating: Double.zero, count: lineCount)
        var lineIndicesVisited = Set<Int>()
        
        var subviewLengths = [Double]()
        var subviewOffsets = [Double]()
        var subviewLineBreadths = [Double]()
        var subviewLineOffsets = [Double]()
        
        switch contentSizeProvider {
        case .dynamic(let resolveSize):
            for element in data {
                let lineBreadth = lineBreadths[lineIndex]
                
                let elementLength = resolveSize(element)
                    .resolve(axis: axis, breadth: lineBreadth, containerLength: containerLength, templates: templates)
                
                subviewLengths.append(elementLength)
                subviewOffsets.append(lineLengths[lineIndex])
                subviewLineBreadths.append(lineBreadth)
                subviewLineOffsets.append(lineOffsets[lineIndex])
                
                lineLengths[lineIndex] += elementLength + spacing
                lineIndicesVisited.insert(lineIndex)
                
                let nextLineIndex = lineLengths.indices.min { firstIndex, secondIndex in
                    let first = lineLengths[firstIndex]
                    let second = lineLengths[secondIndex]
                    
                    return fabs(first - second) < equalityTolerance
                    ? firstIndex < secondIndex
                    : first < second
                }
                lineIndex = nextLineIndex ?? .zero
            }
            
        case .fixed(let sizes):
            var sizeIndex = sizes.startIndex
            
            for _ in 0..<data.count {
                let lineBreadth = lineBreadths[lineIndex]
                
                let elementLength = sizes[sizeIndex]
                    .resolve(axis: axis, breadth: lineBreadth, containerLength: containerLength, templates: templates)
                
                sizes.formIndex(after: &sizeIndex)
                if sizeIndex >= sizes.endIndex {
                    sizeIndex = sizes.startIndex
                }
                
                subviewLengths.append(elementLength)
                subviewOffsets.append(lineLengths[lineIndex])
                subviewLineBreadths.append(lineBreadth)
                subviewLineOffsets.append(lineOffsets[lineIndex])
                
                lineLengths[lineIndex] += elementLength + spacing
                lineIndicesVisited.insert(lineIndex)
                
                let nextLineIndex = lineLengths.indices.min { firstIndex, secondIndex in
                    let first = lineLengths[firstIndex]
                    let second = lineLengths[secondIndex]
                    
                    return fabs(first - second) < equalityTolerance
                    ? firstIndex < secondIndex
                    : first < second
                }
                lineIndex = nextLineIndex ?? .zero
            }
        }
        
        let length = lineIndicesVisited.map { lineLengths[$0] - spacing }.max()
        return (length ?? .zero, subviewLengths, subviewOffsets, subviewLineBreadths, subviewLineOffsets)
    }
}
