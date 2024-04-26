/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyContainerHStack<Content, Data, ID, TemplateContent>: View
where Content : View,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable,
      TemplateContent : View
{
    internal var alignment: VerticalAlignment
    internal var content: (Data.Element) -> Content
    internal var contentWidth: CGFloat?
    internal var data: Data
    internal var id: KeyPath<Data.Element, ID>
    internal var spacing: CGFloat
    internal var templateContent: (() -> TemplateContent)?
    
    public var body: some View {
        LazyStackBase(
            axis: .horizontal,
            contentLength: contentWidth,
            dataCount: data.count,
            spacing: spacing,
            templateContent: templateContent
        )
        .overlay(
            GeometryReader { geometry in
                let frame = geometry.frame(in: .global)
                
                LazyStackContent(
                    alignment: Alignment(horizontal: .leading, vertical: alignment),
                    axis: .horizontal,
                    content: content,
                    data: data,
                    id: id,
                    spacing: spacing
                )
                .modifier(LazyStackContentModifier(stackLength: frame.width, stackOrigin: frame.minX))
            }
        )
    }
}


public extension LazyContainerHStack {
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentWidth: The fixed width of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         alignment: VerticalAlignment = .center,
         contentWidth: CGFloat,
         spacing: CGFloat = 8,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where TemplateContent == Never, Data.Element : Identifiable, Data.Element.ID == ID
    {
        self.alignment = alignment
        self.content = content
        self.contentWidth = contentWidth
        self.data = data
        self.id = \.id
        self.spacing = spacing
        self.templateContent = nil
    }
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentWidth: The fixed width of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: VerticalAlignment = .center,
         contentWidth: CGFloat,
         spacing: CGFloat = 8,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where TemplateContent == Never
    {
        self.alignment = alignment
        self.content = content
        self.contentWidth = contentWidth
        self.data = data
        self.id = id
        self.spacing = spacing
        self.templateContent = nil
    }
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// Changes to template content are not animated on iOS 15, macOS 12, tvOS 14,
    /// watchOS 8 and earlier versions.
    ///
    /// - Parameters:
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    ///   - templateContent: The hidden template content used to size subviews.
    init(_ data: Data,
         alignment: VerticalAlignment = .center,
         spacing: CGFloat = 8,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         @ViewBuilder template templateContent: @escaping () -> TemplateContent)
    where Data.Element : Identifiable, Data.Element.ID == ID
    {
        self.alignment = alignment
        self.content = content
        self.contentWidth = nil
        self.data = data
        self.id = \.id
        self.spacing = spacing
        self.templateContent = templateContent
    }
    
    /// A view that arranges its subviews in a horizontal line, and only renders each subview
    /// when visible in a lazy horizontal container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// Changes to template content are not animated on iOS 15, macOS 12, tvOS 14,
    /// watchOS 8 and earlier versions.
    ///
    /// - Parameters:
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    ///   - templateContent: The hidden template content used to size subviews.
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: VerticalAlignment = .center,
         spacing: CGFloat = 8,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         @ViewBuilder template templateContent: @escaping () -> TemplateContent)
    {
        self.alignment = alignment
        self.content = content
        self.contentWidth = nil
        self.data = data
        self.id = id
        self.spacing = spacing
        self.templateContent = templateContent
    }
}
