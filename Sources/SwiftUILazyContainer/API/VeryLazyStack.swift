/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct VeryLazyStack<Content, Data, ID>: View
where Content : View,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    @Environment(\.lazyContentTemplateSizes) private var templates
    
    internal var alignment: Alignment
    internal var axis: Axis
    internal var content: (Data.Element) -> Content
    internal var contentLength: LazyContentGeometry<CGFloat>
    internal var data: Data
    internal var id: KeyPath<Data.Element, ID>
    internal var spacing: CGFloat?
    
    public var body: some View {
        if let resolvedContentLength {
            let stackLength = stackLength(for: resolvedContentLength)
            
            Color.clear
                .hidden()
                .frame(
                    width: axis == .horizontal ? stackLength : nil,
                    height: axis == .vertical ? stackLength : nil
                )
                .overlay(
                    GeometryReader { geometry in
                        let frame = geometry.frame(in: .global)
                        let origin = switch axis {
                        case .horizontal: frame.minX
                        case .vertical: frame.minY
                        }
                        
                        LazyStackContent(
                            alignment: alignment,
                            axis: axis,
                            content: content,
                            data: data,
                            id: id,
                            spacing: spacing ?? .defaultSpacing
                        )
                        .modifier(LazyStackContentModifier(stackLength: stackLength, stackOrigin: origin))
                    }
                )
        }
    }
    
    private var resolvedContentLength: CGFloat? {
        switch contentLength {
        case .fixed(let length): 
            length
        case .template(let id):
            if let size = templates[id] {
                switch axis {
                case .horizontal: size.width
                case .vertical: size.height
                }
            } else {
                nil
            }
        }
    }
    
    private func stackLength(for resolvedContentLength: CGFloat) -> CGFloat {
        let count = data.count
        let spacing = spacing ?? .defaultSpacing
        
        return if count == .zero {
            .zero
        } else {
            (CGFloat(count) * (resolvedContentLength + spacing)) - spacing
        }
    }
}


public extension VeryLazyStack {
    /// A view that arranges its subviews in a line, and only renders each subview when visible
    /// in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
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
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where Data.Element : Identifiable, Data.Element.ID == ID
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentLength = .fixed(contentLength)
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
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentLength = .fixed(contentLength)
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
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentLength: The length of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         alignment: Alignment = .center,
         contentLength: LazyContentGeometry<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where Data.Element : Identifiable, Data.Element.ID == ID
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentLength = contentLength
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
    ///   - data: The identified data that the stack uses to create subviews dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - alignment: The guide for aligning the subviews in this stack.
    ///   - contentLength: The length of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates subviews dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: Alignment = .center,
         contentLength: LazyContentGeometry<CGFloat>,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentLength = contentLength
        self.data = data
        self.id = id
        self.spacing = spacing
    }
}
