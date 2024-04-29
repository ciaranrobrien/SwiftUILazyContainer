/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyStack<Content, ContentLengths, Data, ID>: View
where Content : View,
      ContentLengths : RandomAccessCollection,
      ContentLengths.Element == LazyContentAnchor<CGFloat>,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    @Environment(\.lazyContainerSize) private var containerSize
    @Environment(\.lazyContentTemplateSizes) private var templates
    
    internal var alignment: Alignment
    internal var axis: Axis
    internal var content: (Data.Element) -> Content
    internal var contentLengths: ContentLengths
    internal var data: Data
    internal var id: KeyPath<Data.Element, ID>
    internal var spacing: CGFloat?
    
    public var body: some View {
        if let contentLengths = resolvedContentLengths {
            GeometryReader { geometry in
                let frame = geometry.frame(in: .global)
                let origin = switch axis {
                case .horizontal: frame.minX
                case .vertical: frame.minY
                }
                
                LazyStackLayout(
                    alignment: alignment,
                    axis: axis,
                    content: content,
                    data: data,
                    id: id,
                    spacing: spacing ?? .defaultSpacing
                )
                .modifier(AnimatableEnvironment(keyPath: \.lazyContentLengths, value: contentLengths))
                .modifier(AnimatableEnvironment(keyPath: \.lazyLayoutOrigin, value: origin))
            }
            .frame(
                width: axis == .horizontal ? stackLength(for: contentLengths) : nil,
                height: axis == .vertical ? stackLength(for: contentLengths) : nil
            )
        }
    }
    
    private var resolvedContentLengths: [Double]? {
        guard !contentLengths.isEmpty, let containerSize
        else { return nil }
        
        return contentLengths.map {
            $0.resolve(axis: axis, containerSize: containerSize, templates: templates)
        }
    }
    
    private func stackLength(for contentLengths: [Double]) -> CGFloat {
        let dataCount = data.count
        
        guard dataCount > .zero
        else { return .zero }
        
        let (quotient, remainder) = dataCount.quotientAndRemainder(dividingBy: contentLengths.count)
        let quotientLength = CGFloat(quotient) * contentLengths.reduce(.zero, +)
        let remainderLength = (0..<remainder).reduce(.zero) { $0 + contentLengths[$1] }
        let spacingLength = CGFloat(dataCount - 1) * (spacing ?? .defaultSpacing)
        
        return quotientLength + remainderLength + spacingLength
    }
}


public extension LazyStack {
    /// A view that arranges its subviews in a line, and only renders each subview when visible
    /// in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this stack.
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentLength: The length of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         alignment: Alignment = .center,
         contentLength: LazyContentAnchor<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    ContentLengths == CollectionOfOne<LazyContentAnchor<CGFloat>>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentLengths = CollectionOfOne(contentLength)
        self.data = data
        self.id = \.id
        self.spacing = spacing
    }
    
    /// A view that arranges its subviews in a line, and only renders each subview when visible
    /// in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this stack.
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentLength: The length of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: Alignment = .center,
         contentLength: LazyContentAnchor<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where ContentLengths == CollectionOfOne<LazyContentAnchor<CGFloat>>
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentLengths = CollectionOfOne(contentLength)
        self.data = data
        self.id = id
        self.spacing = spacing
    }
    
    /// A view that arranges its subviews in a line, and only renders each subview when visible
    /// in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this stack.
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentLengths: The repeating collection of subview lengths.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         alignment: Alignment = .center,
         contentLengths: ContentLengths,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentLengths = contentLengths
        self.data = data
        self.id = \.id
        self.spacing = spacing
    }
    
    /// A view that arranges its subviews in a line, and only renders each subview when visible
    /// in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this stack.
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentLengths: The repeating collection of subview lengths.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: Alignment = .center,
         contentLengths: ContentLengths,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentLengths = contentLengths
        self.data = data
        self.id = id
        self.spacing = spacing
    }
    
    /// A view that arranges its subviews in a line, and only renders each subview when visible
    /// in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this stack.
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentLength: The subview length for each element.
    init(_ axis: Axis,
         _ data: Data,
         alignment: Alignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentLength: @escaping (Data.Element) -> LazyContentAnchor<CGFloat>)
    where
    ContentLengths == [LazyContentAnchor<CGFloat>],
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentLengths = data.map(contentLength)
        self.data = data
        self.id = \.id
        self.spacing = spacing
    }
    
    /// A view that arranges its subviews in a line, and only renders each subview when visible
    /// in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this stack.
    ///   - data: The data that the stack uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentLength: The subview length for each element.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: Alignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentLength: @escaping (Data.Element) -> LazyContentAnchor<CGFloat>)
    where ContentLengths == [LazyContentAnchor<CGFloat>]
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentLengths = data.map(contentLength)
        self.data = data
        self.id = id
        self.spacing = spacing
    }
}
