/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct AltLazyVStack<Content, ContentHeights, Data, ID>: View
where Content : View,
      ContentHeights : RandomAccessCollection,
      ContentHeights.Element == LazySubviewSize,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    public var body: LazyStack<Content, ContentHeights, Data, ID>
}


public extension AltLazyVStack {
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview 
    /// when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentHeight: The height of each subview.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         alignment: HorizontalAlignment = .center,
         spacing: Double = .zero,
         contentHeight: LazySubviewSize,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    ContentHeights == CollectionOfOne<LazySubviewSize>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentSizeProvider: .fixed(sizes: CollectionOfOne(contentHeight)),
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview
    /// when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentHeight: The height of each subview.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: HorizontalAlignment = .center,
         spacing: Double = .zero,
         contentHeight: LazySubviewSize,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where ContentHeights == CollectionOfOne<LazySubviewSize>
    {
        body = LazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentSizeProvider: .fixed(sizes: CollectionOfOne(contentHeight)),
            data: data,
            id: id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview
    /// when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentHeights: The repeating collection of subview heights.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         alignment: HorizontalAlignment = .center,
         spacing: Double = .zero,
         contentHeights: ContentHeights,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentSizeProvider: .fixed(sizes: contentHeights),
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview
    /// when visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentHeights: The repeating collection of subview heights.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: HorizontalAlignment = .center,
         spacing: Double = .zero,
         contentHeights: ContentHeights,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        body = LazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentSizeProvider: .fixed(sizes: contentHeights),
            data: data,
            id: id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview
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
    ///   - contentHeight: The subview height for each element.
    init(_ data: Data,
         alignment: HorizontalAlignment = .center,
         spacing: Double = .zero,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentHeight: @escaping (Data.Element) -> LazySubviewSize)
    where
    ContentHeights == EmptyCollection<LazySubviewSize>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        body = LazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentSizeProvider: .dynamic(resolveSize: contentHeight),
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview
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
    ///   - contentHeight: The subview height for each element.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: HorizontalAlignment = .center,
         spacing: Double = .zero,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentHeight: @escaping (Data.Element) -> LazySubviewSize)
    where ContentHeights == EmptyCollection<LazySubviewSize>
    {
        body = LazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentSizeProvider: .dynamic(resolveSize: contentHeight),
            data: data,
            id: id,
            spacing: spacing
        )
    }
}
