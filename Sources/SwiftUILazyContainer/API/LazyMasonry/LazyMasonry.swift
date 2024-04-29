/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyMasonry<Content, ContentLengths, Data, ID>: View
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
    internal var lines: Int
    internal var spacing: CGFloat?
    
    public var body: some View {
        if let contentLengths = resolvedContentLengths {
            GeometryReader { geometry in
                let frame = geometry.frame(in: .global)
                let origin = switch axis {
                case .horizontal: frame.minX
                case .vertical: frame.minY
                }
                
                LazyMasonryLayout(
                    alignment: alignment,
                    axis: axis,
                    content: content,
                    data: data,
                    id: id,
                    lines: lines,
                    spacing: spacing ?? .defaultSpacing
                )
                .modifier(AnimatableEnvironment(keyPath: \.lazyLayoutOrigin, value: origin))
                .modifier(AnimatableEnvironment(keyPath: \.lazyLayoutSize, value: geometry.size))
            }
            .modifier(LazyMasonryModifier(
                axis: axis,
                contentLengths: contentLengths,
                count: data.count,
                lines: lines,
                spacing: spacing ?? .defaultSpacing
            ))
        }
    }
    
    private var resolvedContentLengths: [Double]? {
        guard !contentLengths.isEmpty, let containerSize
        else { return nil }
        
        return contentLengths.map {
            $0.resolve(axis: axis, containerSize: containerSize, templates: templates)
        }
    }
}


public extension LazyMasonry {
    /// A view that arranges its subviews in a masonry, and only renders each subview when
    /// visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this masonry.
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - lines: The number of lines.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - contentLength: The length of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         lines: Int,
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
        self.lines = lines
        self.spacing = spacing
    }
    
    /// A view that arranges its subviews in a masonry, and only renders each subview when
    /// visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this masonry.
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - lines: The number of lines.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - contentLength: The length of each subview.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         lines: Int,
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
        self.lines = lines
        self.spacing = spacing
    }
    
    /// A view that arranges its subviews in a masonry, and only renders each subview when
    /// visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this masonry.
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - lines: The number of lines.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - contentLengths: The repeating collection of subview lengths.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         lines: Int,
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
        self.lines = lines
        self.spacing = spacing
    }
    
    /// A view that arranges its subviews in a masonry, and only renders each subview when
    /// visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this masonry.
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - lines: The number of lines.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - contentLengths: The repeating collection of subview lengths.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         lines: Int,
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
        self.lines = lines
        self.spacing = spacing
    }
    
    /// A view that arranges its subviews in a masonry, and only renders each subview when
    /// visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this masonry.
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - lines: The number of lines.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentLength: The subview length for each element.
    init(_ axis: Axis,
         _ data: Data,
         lines: Int,
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
        self.lines = lines
        self.spacing = spacing
    }
    
    /// A view that arranges its subviews in a masonry, and only renders each subview when
    /// visible in a lazy container.
    ///
    /// `scrollTargetLayout` has no effect on this view or its subviews.
    ///
    /// - Parameters:
    ///   - axis: The layout axis of this masonry.
    ///   - data: The data that the masonry uses to create views dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - lines: The number of lines.
    ///   - alignment: The guide for aligning the subviews in this masonry.
    ///   - spacing: The distance between adjacent subviews.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    ///   - contentLength: The subview length for each element.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         lines: Int,
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
        self.lines = lines
        self.spacing = spacing
    }
}
