/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct LazyMasonryModifier: ViewModifier {
    @Environment(\.displayScale) private var displayScale
    
    var axis: Axis
    var contentLengths: [Double]
    var count: Int
    var lines: Int
    var spacing: CGFloat
    
    func body(content: Content) -> some View {
        if let (length, elementLengths, elementOffsets, elementVectors) = data {
            content
                .modifier(AnimatableEnvironment(keyPath: \.lazyMasonryElementLengths, value: elementLengths))
                .modifier(AnimatableEnvironment(keyPath: \.lazyMasonryElementOffsets, value: elementOffsets))
                .modifier(AnimatableEnvironment(keyPath: \.lazyMasonryElementVectors, value: elementVectors))
                .frame(
                    width: axis == .horizontal ? length : nil,
                    height: axis == .vertical ? length : nil
                )
        }
    }
    
    private var data: (CGFloat, [Double], [Double], [Double])? {
        guard count > .zero, let contentLengthLastIndex = contentLengths.indices.last
        else { return nil }
        
        let equalityTolerance = displayScale / 2
        var contentLengthsIndex = 0
        var vectorOffset = 0
        var vectors = Array(repeating: Double.zero, count: lines)
        var vectorOffsetsVisited = Set<Int>()
        
        var elementLengths = [Double]()
        var elementOffsets = [Double]()
        var elementVectors = [Double]()
        
        for _ in 0..<count {
            let elementLength = contentLengths[contentLengthsIndex]
            
            elementLengths.append(elementLength)
            elementOffsets.append(vectors[vectorOffset])
            elementVectors.append(Double(vectorOffset))
            
            vectors[vectorOffset] += elementLength + spacing
            vectorOffsetsVisited.insert(vectorOffset)
            contentLengthsIndex = contentLengthsIndex == contentLengthLastIndex ? 0 : (contentLengthsIndex + 1)
            
            let nextVectorIndex = vectors.enumerated().min {
                fabs($0.element - $1.element) < equalityTolerance
                ? $0.offset < $1.offset
                : $0.element < $1.element
            }
            vectorOffset = nextVectorIndex?.offset ?? .zero
        }
        
        let length = vectorOffsetsVisited.map { vectors[$0] - spacing }.max()
        return (length ?? .zero, elementLengths, elementOffsets, elementVectors)
    }
}
