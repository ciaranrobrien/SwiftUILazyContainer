/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct AltLazyHStack<Content, ContentWidths, Data, ID>: View
where Content : View,
      ContentWidths : RandomAccessCollection,
      ContentWidths.Element == LazySubviewSize,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    public var body: LazyStack<Content, ContentWidths, Data, ID>
}


public extension AltLazyHStack {
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentWidth: The width of each subview.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         alignment: VerticalAlignment = .center,
         spacing: Double = .zero,
         contentWidth: LazySubviewSize,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    ContentWidths == CollectionOfOne<LazySubviewSize>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyStack(
            alignment: Alignment(horizontal: .leading, vertical: alignment),
            axis: .horizontal,
            content: content,
            contentSizeProvider: .fixed(sizes: CollectionOfOne(contentWidth)),
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentWidth: The width of each subview.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: VerticalAlignment = .center,
         spacing: Double = .zero,
         contentWidth: LazySubviewSize,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where ContentWidths == CollectionOfOne<LazySubviewSize>
    {
        body = LazyStack(
            alignment: Alignment(horizontal: .leading, vertical: alignment),
            axis: .horizontal,
            content: content,
            contentSizeProvider: .fixed(sizes: CollectionOfOne(contentWidth)),
            data: data,
            id: id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentWidths: The repeating collection of subview widths.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         alignment: VerticalAlignment = .center,
         spacing: Double = .zero,
         contentWidths: ContentWidths,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyStack(
            alignment: Alignment(horizontal: .leading, vertical: alignment),
            axis: .horizontal,
            content: content,
            contentSizeProvider: .fixed(sizes: contentWidths),
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentWidths: The repeating collection of subview widths.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: VerticalAlignment = .center,
         spacing: Double = .zero,
         contentWidths: ContentWidths,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        body = LazyStack(
            alignment: Alignment(horizontal: .leading, vertical: alignment),
            axis: .horizontal,
            content: content,
            contentSizeProvider: .fixed(sizes: contentWidths),
            data: data,
            id: id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy container.
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
         spacing: Double = .zero,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentWidth: @escaping (Data.Element) -> LazySubviewSize)
    where
    ContentWidths == EmptyCollection<LazySubviewSize>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyStack(
            alignment: Alignment(horizontal: .leading, vertical: alignment),
            axis: .horizontal,
            content: content,
            contentSizeProvider: .dynamic(resolveSize: contentWidth),
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy container.
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
         spacing: Double = .zero,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentWidth: @escaping (Data.Element) -> LazySubviewSize)
    where ContentWidths == EmptyCollection<LazySubviewSize>
    {
        body = LazyStack(
            alignment: Alignment(horizontal: .leading, vertical: alignment),
            axis: .horizontal,
            content: content,
            contentSizeProvider: .dynamic(resolveSize: contentWidth),
            data: data,
            id: id,
            spacing: spacing
        )
    }
}
