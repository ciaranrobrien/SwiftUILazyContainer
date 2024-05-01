/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyHMasonry<Content, ContentWidths, Data, ID>: View
where Content : View,
      ContentWidths : RandomAccessCollection,
      ContentWidths.Element == LazySubviewSize,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    public var body: LazyMasonry<Content, ContentWidths, Data, ID>
}


public extension LazyHMasonry {

    /// A view that arranges its subviews in a horizontal masonry, and only renders each
    /// subview when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - rows: The rows of the masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentWidths: The repeating collection of subview widths.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         rows: [LazyLineSize],
         spacing: Double = .zero,
         contentWidths: ContentWidths,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyMasonry(
            axis: .horizontal,
            content: content,
            contentSizeProvider: .fixed(sizes: contentWidths),
            data: data,
            id: \.id,
            lines: rows,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal masonry, and only renders each
    /// subview when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - rows: The rows of the masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentWidths: The repeating collection of subview widths.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         rows: [LazyLineSize],
         spacing: Double = .zero,
         contentWidths: ContentWidths,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        body = LazyMasonry(
            axis: .horizontal,
            content: content,
            contentSizeProvider: .fixed(sizes: contentWidths),
            data: data,
            id: id,
            lines: rows,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal masonry, and only renders each
    /// subview when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - rows: The rows of the masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentWidth: The subview width for each element.
    init(_ data: Data,
         rows: [LazyLineSize],
         spacing: Double = .zero,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentWidth: @escaping (Data.Element) -> LazySubviewSize)
    where
    ContentWidths == EmptyCollection<LazySubviewSize>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyMasonry(
            axis: .horizontal,
            content: content,
            contentSizeProvider: .dynamic(resolveSize: contentWidth),
            data: data,
            id: \.id,
            lines: rows,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal masonry, and only renders each
    /// subview when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - rows: The rows of the masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentWidth: The subview width for each element.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         rows: [LazyLineSize],
         spacing: Double = .zero,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentWidth: @escaping (Data.Element) -> LazySubviewSize)
    where ContentWidths == EmptyCollection<LazySubviewSize>
    {
        body = LazyMasonry(
            axis: .horizontal,
            content: content,
            contentSizeProvider: .dynamic(resolveSize: contentWidth),
            data: data,
            id: id,
            lines: rows,
            spacing: spacing
        )
    }
}
