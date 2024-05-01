/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct LazyStackModifier<Data, Sizes>: ViewModifier
where Sizes : RandomAccessCollection,
      Sizes.Element == LazySubviewSize,
      Data : RandomAccessCollection
{
    @Environment(\.displayScale) private var displayScale
    @Environment(\.lazySubviewTemplateSizes) private var templates
    
    var axis: Axis
    var containerLength: Double
    var contentSizeProvider: LazySubviewSizeProvider<Data.Element, Sizes>
    var data: Data
    var layoutBreadth: Double
    var spacing: Double
    
    func body(content: Content) -> some View {
        if let (length, subviewLengths, subviewOffsets) = resolved {
            content
                .modifier(AnimatableEnvironment(\.lazySubviewLengths, subviewLengths))
                .modifier(AnimatableEnvironment(\.lazySubviewOffsets, subviewOffsets))
                .frame(
                    width: axis == .horizontal ? length : nil,
                    height: axis == .vertical ? length : nil
                )
        }
    }
    
    private var resolved: (Double, [Double], [Double])? {
        guard !data.isEmpty
        else { return nil }
        
        var offset = Double.zero
        var subviewLengths = [Double]()
        var subviewOffsets = [Double]()
        
        switch contentSizeProvider {
        case .dynamic(let resolveSize):
            for element in data {
                let elementLength = resolveSize(element)
                    .resolve(axis: axis, breadth: layoutBreadth, containerLength: containerLength, templates: templates)
                
                subviewLengths.append(elementLength)
                subviewOffsets.append(offset)
                
                offset += elementLength + spacing
            }
            
        case .fixed(let sizes):
            var sizeIndex = sizes.startIndex
            
            for _ in 0..<data.count {
                let elementLength = sizes[sizeIndex]
                    .resolve(axis: axis, breadth: layoutBreadth, containerLength: containerLength, templates: templates)
                
                sizes.formIndex(after: &sizeIndex)
                if sizeIndex >= sizes.endIndex {
                    sizeIndex = sizes.startIndex
                }
                
                subviewLengths.append(elementLength)
                subviewOffsets.append(offset)
                
                offset += elementLength + spacing
            }
        }
        
        return (offset - spacing, subviewLengths, subviewOffsets)
    }
}
