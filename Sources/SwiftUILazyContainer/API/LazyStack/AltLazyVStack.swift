/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct AltLazyVStack<Content, ContentHeights, Data, ID>: View
where Content : View,
      ContentHeights : RandomAccessCollection,
      ContentHeights.Element == LazyContentAnchor<CGFloat>,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    public var body: LazyStack<Content, ContentHeights, Data, ID>
}


public extension AltLazyVStack {
    /// A view that arranges its subviews in a vertical line, and only renders each subview when
    /// visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentHeight: The height of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         alignment: HorizontalAlignment = .center,
         contentHeight: LazyContentAnchor<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    ContentHeights == CollectionOfOne<LazyContentAnchor<CGFloat>>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLengths: CollectionOfOne(contentHeight),
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview when
    /// visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentHeight: The height of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: HorizontalAlignment = .center,
         contentHeight: LazyContentAnchor<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where ContentHeights == CollectionOfOne<LazyContentAnchor<CGFloat>>
    {
        body = LazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLengths: CollectionOfOne(contentHeight),
            data: data,
            id: id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview when
    /// visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentHeights: The repeating collection of subview heights.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         alignment: HorizontalAlignment = .center,
         contentHeights: ContentHeights,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLengths: contentHeights,
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview when
    /// visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentHeights: The repeating collection of subview heights.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: HorizontalAlignment = .center,
         contentHeights: ContentHeights,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        body = LazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLengths: contentHeights,
            data: data,
            id: id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview when
    /// visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentHeight: The subview height for each element.
    init(_ data: Data,
         alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentHeight: (Data.Element) -> LazyContentAnchor<CGFloat>)
    where
    ContentHeights == [LazyContentAnchor<CGFloat>],
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLengths: data.map(contentHeight),
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview when
    /// visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentHeight: The subview height for each element.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentHeight: (Data.Element) -> LazyContentAnchor<CGFloat>)
    where ContentHeights == [LazyContentAnchor<CGFloat>]
    {
        body = LazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLengths: data.map(contentHeight),
            data: data,
            id: id,
            spacing: spacing
        )
    }
}
