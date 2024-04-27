/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct VeryLazyVStack<Content, Data, ID>: View
where Content : View,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    public var body: VeryLazyStack<Content, Data, ID>
}


public extension VeryLazyVStack {
    /// A view that arranges its subviews in a vertical line, and only renders each subview
    /// when visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentHeight: The fixed height of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         alignment: HorizontalAlignment = .center,
         contentHeight: CGFloat,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where Data.Element : Identifiable, Data.Element.ID == ID
    {
        body = VeryLazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLength: .fixed(contentHeight),
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview
    /// when visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentHeight: The fixed height of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: HorizontalAlignment = .center,
         contentHeight: CGFloat,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        body = VeryLazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLength: .fixed(contentHeight),
            data: data,
            id: id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview
    /// when visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentHeight: The height of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         alignment: HorizontalAlignment = .center,
         contentHeight: LazyContentGeometry<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where Data.Element : Identifiable, Data.Element.ID == ID
    {
        body = VeryLazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLength: contentHeight,
            data: data,
            id: \.id,
            spacing: spacing
        )
    }
    
    /// A view that arranges its subviews in a vertical line, and only renders each subview
    /// when visible in a lazy vertical container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentHeight: The height of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: HorizontalAlignment = .center,
         contentHeight: LazyContentGeometry<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        body = VeryLazyStack(
            alignment: Alignment(horizontal: alignment, vertical: .top),
            axis: .vertical,
            content: content,
            contentLength: contentHeight,
            data: data,
            id: id,
            spacing: spacing
        )
    }
}
