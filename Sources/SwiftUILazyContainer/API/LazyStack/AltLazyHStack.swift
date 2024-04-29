/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct AltLazyHStack<Content, ContentWidths, Data, ID>: View
where Content : View,
      ContentWidths : RandomAccessCollection,
      ContentWidths.Element == LazyContentAnchor<CGFloat>,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    public var body: LazyStack<Content, ContentWidths, Data, ID>
}


public extension AltLazyHStack {
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentWidth: The width of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         alignment: VerticalAlignment = .center,
         contentWidth: LazyContentAnchor<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    ContentWidths == CollectionOfOne<LazyContentAnchor<CGFloat>>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyStack(
            alignment: Alignment(horizontal: .leading, vertical: alignment),
            axis: .horizontal,
            content: content,
            contentLengths: CollectionOfOne(contentWidth),
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentWidth: The width of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: VerticalAlignment = .center,
         contentWidth: LazyContentAnchor<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where ContentWidths == CollectionOfOne<LazyContentAnchor<CGFloat>>
    {
        body = LazyStack(
            alignment: Alignment(horizontal: .leading, vertical: alignment),
            axis: .horizontal,
            content: content,
            contentLengths: CollectionOfOne(contentWidth),
            data: data,
            id: id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentWidths: The repeating collection of subview widths.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         alignment: VerticalAlignment = .center,
         contentWidths: ContentWidths,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyStack(
            alignment: Alignment(horizontal: .leading, vertical: alignment),
            axis: .horizontal,
            content: content,
            contentLengths: contentWidths,
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentWidths: The repeating collection of subview widths.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: VerticalAlignment = .center,
         contentWidths: ContentWidths,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        body = LazyStack(
            alignment: Alignment(horizontal: .leading, vertical: alignment),
            axis: .horizontal,
            content: content,
            contentLengths: contentWidths,
            data: data,
            id: id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentWidth: The subview width for each element.
    init(_ data: Data,
         alignment: VerticalAlignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentWidth: (Data.Element) -> LazyContentAnchor<CGFloat>)
    where
    ContentWidths == [LazyContentAnchor<CGFloat>],
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyStack(
            alignment: Alignment(horizontal: .leading, vertical: alignment),
            axis: .horizontal,
            content: content,
            contentLengths: data.map(contentWidth),
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy horizontal container.
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
    ///   - contentWidth: The subview width for each element.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: VerticalAlignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentWidth: (Data.Element) -> LazyContentAnchor<CGFloat>)
    where ContentWidths == [LazyContentAnchor<CGFloat>]
    {
        body = LazyStack(
            alignment: Alignment(horizontal: .leading, vertical: alignment),
            axis: .horizontal,
            content: content,
            contentLengths: data.map(contentWidth),
            data: data,
            id: id,
            spacing: spacing
        )
    }
}
