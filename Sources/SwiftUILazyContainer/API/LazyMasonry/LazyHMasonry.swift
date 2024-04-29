/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyHMasonry<Content, ContentWidths, Data, ID>: View
where Content : View,
      ContentWidths : RandomAccessCollection,
      ContentWidths.Element == LazyContentAnchor<CGFloat>,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    public var body: LazyMasonry<Content, ContentWidths, Data, ID>
}


public extension LazyHMasonry {
    /// A view that arranges its subviews in a horizontal masonry, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - rows: The number of rows.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - contentWidth: The width of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         rows: Int,
         alignment: HorizontalAlignment = .center,
         contentWidth: LazyContentAnchor<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    ContentWidths == CollectionOfOne<LazyContentAnchor<CGFloat>>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyMasonry(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .horizontal,
            content: content,
            contentLengths: CollectionOfOne(contentWidth),
            data: data,
            id: \.id,
            lines: rows,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal masonry, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - rows: The number of rows.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - contentWidth: The width of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         rows: Int,
         alignment: HorizontalAlignment = .center,
         contentWidth: LazyContentAnchor<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where ContentWidths == CollectionOfOne<LazyContentAnchor<CGFloat>>
    {
        body = LazyMasonry(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .horizontal,
            content: content,
            contentLengths: CollectionOfOne(contentWidth),
            data: data,
            id: id,
            lines: rows,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal masonry, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - rows: The number of rows.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - contentWidths: The repeating collection of subview widths.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         rows: Int,
         alignment: HorizontalAlignment = .center,
         contentWidths: ContentWidths,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyMasonry(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .horizontal,
            content: content,
            contentLengths: contentWidths,
            data: data,
            id: \.id,
            lines: rows,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal masonry, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - rows: The number of rows.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - contentWidths: The repeating collection of subview widths.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         rows: Int,
         alignment: HorizontalAlignment = .center,
         contentWidths: ContentWidths,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        body = LazyMasonry(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .horizontal,
            content: content,
            contentLengths: contentWidths,
            data: data,
            id: id,
            lines: rows,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal masonry, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - rows: The number of rows.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentWidth: The subview width for each element.
    init(_ data: Data,
         rows: Int,
         alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentWidth: (Data.Element) -> LazyContentAnchor<CGFloat>)
    where
    ContentWidths == [LazyContentAnchor<CGFloat>],
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyMasonry(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .horizontal,
            content: content,
            contentLengths: data.map(contentWidth),
            data: data,
            id: \.id,
            lines: rows,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal masonry, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - rows: The number of rows.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentWidth: The subview width for each element.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         rows: Int,
         alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentWidth: (Data.Element) -> LazyContentAnchor<CGFloat>)
    where ContentWidths == [LazyContentAnchor<CGFloat>]
    {
        body = LazyMasonry(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .horizontal,
            content: content,
            contentLengths: data.map(contentWidth),
            data: data,
            id: id,
            lines: rows,
            spacing: spacing
        )
    }
}
