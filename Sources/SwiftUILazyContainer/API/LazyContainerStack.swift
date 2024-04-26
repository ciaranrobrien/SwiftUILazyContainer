/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyContainerStack<Content, Data, ID, TemplateContent>: View
where Content : View,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable,
      TemplateContent : View
{
    internal var alignment: Alignment
    internal var axis: Axis
    internal var content: (Data.Element) -> Content
    internal var contentLength: CGFloat?
    internal var data: Data
    internal var id: KeyPath<Data.Element, ID>
    internal var spacing: CGFloat
    internal var templateContent: (() -> TemplateContent)?
    
    public var body: some View {
        LazyStackBase(
            axis: axis,
            contentLength: contentLength,
            dataCount: data.count,
            spacing: spacing,
            templateContent: templateContent
        )
        .overlay(
            GeometryReader { geometry in
                let frame = geometry.frame(in: .global)
                let length = switch axis {
                case .horizontal: frame.width
                case .vertical: frame.height
                }
                let origin = switch axis {
                case .horizontal: frame.minX
                case .vertical: frame.minY
                }
                
                LazyStackContent(
                    alignment: resolvedAlignment,
                    axis: axis,
                    content: content,
                    data: data,
                    id: id,
                    spacing: spacing
                )
                .modifier(LazyStackContentModifier(stackLength: length, stackOrigin: origin))
            }
        )
    }
    
    private var resolvedAlignment: Alignment {
        switch axis {
        case .horizontal:
            Alignment(horizontal: .leading, vertical: alignment.vertical)
        case .vertical:
            Alignment(horizontal: alignment.horizontal, vertical: .top)
        }
    }
}


public extension LazyContainerStack {
    /// A view that arranges its subviews in a line, and only renders each subview when visible
    /// in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// Changes to axis are not animated on iOS 15, macOS 12, tvOS 14, watchOS 8 and
    /// earlier versions.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this stack.
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentLength: The fixed length of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         alignment: Alignment = .center,
         contentLength: CGFloat,
         spacing: CGFloat = 8,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where TemplateContent == Never, Data.Element : Identifiable, Data.Element.ID == ID
    {
        self.alignment = alignment
        self.axis = axis
        self.content = content
        self.contentLength = contentLength
        self.data = data
        self.id = \.id
        self.spacing = spacing
        self.templateContent = nil
    }
    
    /// A view that arranges its subviews in a line, and only renders each subview when visible
    /// in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// Changes to axis are not animated on iOS 15, macOS 12, tvOS 14, watchOS 8 and
    /// earlier versions.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this stack.
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentLength: The fixed length of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: Alignment = .center,
         contentLength: CGFloat,
         spacing: CGFloat = 8,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where TemplateContent == Never
    {
        self.alignment = alignment
        self.axis = axis
        self.content = content
        self.contentLength = contentLength
        self.data = data
        self.id = id
        self.spacing = spacing
        self.templateContent = nil
    }
    
    /// A view that arranges its subviews in a line, and only renders each subview when visible
    /// in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// Changes to axis and template content are not animated on iOS 15, macOS 12, tvOS 14,
    /// watchOS 8 and earlier versions.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this stack.
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    ///   - templateContent: The hidden template content used to size subviews.
    init(_ axis: Axis,
         _ data: Data,
         alignment: Alignment = .center,
         spacing: CGFloat = 8,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         @ViewBuilder template templateContent: @escaping () -> TemplateContent)
    where Data.Element : Identifiable, Data.Element.ID == ID
    {
        self.alignment = alignment
        self.axis = axis
        self.content = content
        self.contentLength = nil
        self.data = data
        self.id = \.id
        self.spacing = spacing
        self.templateContent = templateContent
    }
    
    /// A view that arranges its subviews in a line, and only renders each subview when visible
    /// in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// Changes to axis and template content are not animated on iOS 15, macOS 12, tvOS 14,
    /// watchOS 8 and earlier versions.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this stack.
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    ///   - templateContent: The hidden template content used to size subviews.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: Alignment = .center,
         spacing: CGFloat = 8,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         @ViewBuilder template templateContent: @escaping () -> TemplateContent)
    {
        self.alignment = alignment
        self.axis = axis
        self.content = content
        self.contentLength = nil
        self.data = data
        self.id = id
        self.spacing = spacing
        self.templateContent = templateContent
    }
}
