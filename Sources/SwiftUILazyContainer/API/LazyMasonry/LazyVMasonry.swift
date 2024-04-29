/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyVMasonry<Content, ContentHeights, Data, ID>: View
where Content : View,
      ContentHeights : RandomAccessCollection,
      ContentHeights.Element == LazyContentAnchor<CGFloat>,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    public var body: LazyMasonry<Content, ContentHeights, Data, ID>
}


public extension LazyVMasonry {
    /// A view that arranges its subviews in a vertical masonry, and only renders each subview
    /// when visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - columns: The number of columns.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - contentHeight: The height of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         columns: Int,
         alignment: HorizontalAlignment = .center,
         contentHeight: LazyContentAnchor<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    ContentHeights == CollectionOfOne<LazyContentAnchor<CGFloat>>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyMasonry(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLengths: CollectionOfOne(contentHeight),
            data: data,
            id: \.id,
            lines: columns,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical masonry, and only renders each subview
    /// when visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - columns: The number of columns.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - contentHeight: The height of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         columns: Int,
         alignment: HorizontalAlignment = .center,
         contentHeight: LazyContentAnchor<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where ContentHeights == CollectionOfOne<LazyContentAnchor<CGFloat>>
    {
        body = LazyMasonry(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLengths: CollectionOfOne(contentHeight),
            data: data,
            id: id,
            lines: columns,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical masonry, and only renders each subview
    /// when visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - columns: The number of columns.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - contentHeights: The repeating collection of subview heights.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         columns: Int,
         alignment: HorizontalAlignment = .center,
         contentHeights: ContentHeights,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyMasonry(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLengths: contentHeights,
            data: data,
            id: \.id,
            lines: columns,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical masonry, and only renders each subview
    /// when visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - columns: The number of columns.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - contentHeights: The repeating collection of subview heights.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         columns: Int,
         alignment: HorizontalAlignment = .center,
         contentHeights: ContentHeights,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        body = LazyMasonry(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLengths: contentHeights,
            data: data,
            id: id,
            lines: columns,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical masonry, and only renders each subview
    /// when visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - columns: The number of columns.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentHeight: The subview height for each element.
    init(_ data: Data,
         columns: Int,
         alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentHeight: (Data.Element) -> LazyContentAnchor<CGFloat>)
    where
    ContentHeights == [LazyContentAnchor<CGFloat>],
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyMasonry(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLengths: data.map(contentHeight),
            data: data,
            id: \.id,
            lines: columns,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical masonry, and only renders each subview
    /// when visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - columns: The number of columns.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentHeight: The subview height for each element.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         columns: Int,
         alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentHeight: (Data.Element) -> LazyContentAnchor<CGFloat>)
    where ContentHeights == [LazyContentAnchor<CGFloat>]
    {
        body = LazyMasonry(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLengths: data.map(contentHeight),
            data: data,
            id: id,
            lines: columns,
            spacing: spacing
        )
    }
}
