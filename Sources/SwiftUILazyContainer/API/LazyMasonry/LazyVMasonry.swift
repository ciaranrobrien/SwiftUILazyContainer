/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyVMasonry<Content, ContentHeights, Data, ID>: View
where Content : View,
      ContentHeights : RandomAccessCollection,
      ContentHeights.Element == LazySubviewSize,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    public var body: LazyMasonry<Content, ContentHeights, Data, ID>
}


public extension LazyVMasonry {

    /// A view that arranges its subviews in a vertical masonry, and only renders each subview
    /// when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - columns: The columns of the masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentHeights: The repeating collection of subview heights.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         columns: [LazyLineSize],
         spacing: Double = .zero,
         contentHeights: ContentHeights,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyMasonry(
            axis: .vertical,
            content: content,
            contentSizeProvider: .fixed(sizes: contentHeights),
            data: data,
            id: \.id,
            lines: columns,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical masonry, and only renders each subview
    /// when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - columns: The columns of the masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentHeights: The repeating collection of subview heights.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         lines: [LazyLineSize],
         spacing: Double = .zero,
         contentHeights: ContentHeights,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        body = LazyMasonry(
            axis: .vertical,
            content: content,
            contentSizeProvider: .fixed(sizes: contentHeights),
            data: data,
            id: id,
            lines: lines,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical masonry, and only renders each subview
    /// when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - columns: The columns of the masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentHeight: The subview height for each element.
    init(_ data: Data,
         columns: [LazyLineSize],
         spacing: Double = .zero,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentHeight: @escaping (Data.Element) -> LazySubviewSize)
    where
    ContentHeights == EmptyCollection<LazySubviewSize>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyMasonry(
            axis: .vertical,
            content: content,
            contentSizeProvider: .dynamic(resolveSize: contentHeight),
            data: data,
            id: \.id,
            lines: columns,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical masonry, and only renders each subview
    /// when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - columns: The columns of the masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentHeight: The subview height for each element.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         columns: [LazyLineSize],
         spacing: Double = .zero,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentHeight: @escaping (Data.Element) -> LazySubviewSize)
    where ContentHeights == EmptyCollection<LazySubviewSize>
    {
        body = LazyMasonry(
            axis: .vertical,
            content: content,
            contentSizeProvider: .dynamic(resolveSize: contentHeight),
            data: data,
            id: id,
            lines: columns,
            spacing: spacing
        )
    }
}
