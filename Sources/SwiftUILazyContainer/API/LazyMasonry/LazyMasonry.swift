/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyMasonry<Content, ContentSizes, Data, ID>: View
where Content : View,
      ContentSizes : RandomAccessCollection,
      ContentSizes.Element == LazySubviewSize,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    @Environment(\.lazyContainerSize) private var containerSize
    
    internal var axis: Axis
    internal var content: (Data.Element) -> Content
    internal var contentSizeProvider: LazySubviewSizeProvider<Data.Element, ContentSizes>
    internal var data: Data
    internal var id: KeyPath<Data.Element, ID>
    internal var lines: [LazyLineSize]
    internal var spacing: Double
    
    public var body: some View {
        LengthReader(axis.orthogonal) { breadth in
            if let lineBreadths = lineBreadths(for: breadth) {
                GeometryReader { geometry in
                    let frame = geometry.frame(in: .global)
                    let (length, origin): (Double, Double) = switch axis {
                    case .horizontal: (frame.width, frame.minX)
                    case .vertical: (frame.height, frame.minY)
                    }
                    
                    LazyMasonryLayout(
                        axis: axis,
                        content: content,
                        data: data,
                        id: id,
                        spacing: spacing
                    )
                    .modifier(AnimatableEnvironment(\.lazyLayoutLength, length))
                    .modifier(AnimatableEnvironment(\.lazyLayoutOrigin, origin))
                }
                .modifier(LazyMasonryModifier(
                    axis: axis,
                    contentSizeProvider: contentSizeProvider,
                    data: data,
                    lineBreadths: lineBreadths,
                    spacing: spacing
                ))
            }
        }
    }
    
    private func lineBreadths(for breadth: Double?) -> [Double]? {
        guard !lines.isEmpty, let containerSize
        else { return nil }
        
        var remainingSpace: Double = if let breadth {
            breadth
        } else {
            switch axis {
            case .horizontal: containerSize.height
            case .vertical: containerSize.width
            }
        }
        
        guard remainingSpace > .zero else { return nil }
        remainingSpace += spacing
        
        var lineIndices = lines.indices.map { $0 }
        var resolvedLines = Array(repeating: [Double](), count: lines.count)
        
        lineIndices = lineIndices.reduce(into: [Int]()) { indices, index in
            switch lines[index] {
            case .adaptive, .flexible:
                indices.append(index)
            case .fixed(let length):
                resolvedLines[index] = [length]
                remainingSpace -= length + spacing
            }
        }
        
        if !lineIndices.isEmpty {
            let flexibleSpace = remainingSpace / Double(lineIndices.count)
            
            for index in lineIndices {
                switch lines[index] {
                case .flexible:
                    resolvedLines[index] = [flexibleSpace - spacing]
                    
                case .adaptive(let constraint):
                    let rawCount = switch constraint {
                    case .min(let minLength):
                        floor(flexibleSpace / (minLength + spacing))
                    case .max(let maxLength):
                        ceil(flexibleSpace / (maxLength + spacing))
                    }
                    
                    let count = Int(rawCount)
                    guard count > .zero else { return nil }
                    
                    let length = flexibleSpace / rawCount
                    resolvedLines[index] = Array(repeating: length - spacing, count: Int(count))
                    
                case .fixed:
                    break
                }
            }
        }
        
        return resolvedLines.flatMap { $0 }
    }
}


public extension LazyMasonry {
    
    /// A view that arranges its subviews in a masonry, and only renders each subview when
    /// visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this masonry.
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - lines: The lines of the masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentSizes: The repeating collection of subview sizes.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         lines: [LazyLineSize],
         spacing: Double = .zero,
         contentSizes: ContentSizes,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        self.axis = axis
        self.content = content
        self.contentSizeProvider = .fixed(sizes: contentSizes)
        self.data = data
        self.id = \.id
        self.lines = lines
        self.spacing = spacing
    }
    
    /// A view that arranges its subviews in a masonry, and only renders each subview when
    /// visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this masonry.
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - lines: The lines of the masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentSizes: The repeating collection of subview sizes.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         lines: [LazyLineSize],
         spacing: Double = .zero,
         contentSizes: ContentSizes,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        self.axis = axis
        self.content = content
        self.contentSizeProvider = .fixed(sizes: contentSizes)
        self.data = data
        self.id = id
        self.lines = lines
        self.spacing = spacing
    }
    
    /// A view that arranges its subviews in a masonry, and only renders each subview when
    /// visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this masonry.
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - lines: The lines of the masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentSize: The subview size for each element.
    init(_ axis: Axis,
         _ data: Data,
         lines: [LazyLineSize],
         spacing: Double = .zero,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentSize: @escaping (Data.Element) -> LazySubviewSize)
    where
    ContentSizes == EmptyCollection<LazySubviewSize>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        self.axis = axis
        self.content = content
        self.contentSizeProvider = .dynamic(resolveSize: contentSize)
        self.data = data
        self.id = \.id
        self.lines = lines
        self.spacing = spacing
    }
    
    /// A view that arranges its subviews in a masonry, and only renders each subview when
    /// visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this masonry.
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - lines: The lines of the masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentSize: The subview size for each element.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         lines: [LazyLineSize],
         spacing: Double = .zero,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentSize: @escaping (Data.Element) -> LazySubviewSize)
    where ContentSizes == EmptyCollection<LazySubviewSize>
    {
        self.axis = axis
        self.content = content
        self.contentSizeProvider = .dynamic(resolveSize: contentSize)
        self.data = data
        self.id = id
        self.lines = lines
        self.spacing = spacing
    }
}
