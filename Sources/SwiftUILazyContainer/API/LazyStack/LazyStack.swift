/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct LazyStack<Content, ContentSizes, Data, ID>: View
where Content : View,
      ContentSizes : RandomAccessCollection,
      ContentSizes.Element == LazySubviewSize,
      Data : RandomAccessCollection,
      Data.Index == Int,
      ID : Hashable
{
    @Environment(\.lazyContainerSize) private var containerSize
    @Environment(\.lazySubviewTemplateSizes) private var templates
    
    internal var alignment: Alignment
    internal var axis: Axis
    internal var content: (Data.Element) -> Content
    internal var contentSizeProvider: LazySubviewSizeProvider<Data.Element, ContentSizes>
    internal var data: Data
    internal var id: KeyPath<Data.Element, ID>
    internal var spacing: Double
    
    public var body: some View {
        LengthReader(axis.orthogonal) { breadth in
            if let (containerLength, layoutBreadth) = resolved(for: breadth) {
                GeometryReader { geometry in
                    let frame = geometry.frame(in: .global)
                    let (breadth, length, origin): (Double, Double, Double) = switch axis {
                    case .horizontal: (frame.height, frame.width, frame.minX)
                    case .vertical: (frame.width, frame.height, frame.minY)
                    }
                    
                    LazyStackLayout(
                        alignment: alignment,
                        axis: axis,
                        content: content,
                        data: data,
                        id: id,
                        layoutBreadth: breadth,
                        spacing: spacing
                    )
                    .modifier(AnimatableEnvironment(\.lazyLayoutLength, length))
                    .modifier(AnimatableEnvironment(\.lazyLayoutOrigin, origin))
                }
                .modifier(LazyStackModifier(
                    axis: axis,
                    containerLength: containerLength,
                    contentSizeProvider: contentSizeProvider,
                    data: data,
                    layoutBreadth: layoutBreadth,
                    spacing: spacing
                ))
            }
        }
    }
    
    private func resolved(for breadth: Double?) -> (Double, Double)? {
        guard let containerSize
        else { return nil }
        
        return switch axis {
        case .horizontal:
            (containerSize.width, breadth ?? containerSize.height)
        case .vertical:
            (containerSize.height, breadth ?? containerSize.width)
        }
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
    ///   - spacing: The distance between adjacent subviews.
    ///   - contentSize: The size of each subview.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         alignment: Alignment = .center,
         spacing: Double = .zero,
         contentSize: LazySubviewSize,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where
    ContentSizes == CollectionOfOne<LazySubviewSize>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentSizeProvider = .fixed(sizes: CollectionOfOne(contentSize))
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
    ///   - contentSize: The size of each subview.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: Alignment = .center,
         spacing: Double = .zero,
         contentSize: LazySubviewSize,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    where ContentSizes == CollectionOfOne<LazySubviewSize>
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentSizeProvider = .fixed(sizes: CollectionOfOne(contentSize))
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
    ///   - contentSizes: The repeating collection of subview sizes.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         alignment: Alignment = .center,
         spacing: Double = .zero,
         contentSizes: ContentSizes,
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
        self.contentSizeProvider = .fixed(sizes: contentSizes)
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
    ///   - contentSizes: The repeating collection of subview sizes.
    ///   - content: The view builder that creates views dynamically. Avoid persisting
    ///     state inside the content.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: Alignment = .center,
         spacing: Double = .zero,
         contentSizes: ContentSizes,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentSizeProvider = .fixed(sizes: contentSizes)
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
    ///   - contentSize: The subview size for each element.
    init(_ axis: Axis,
         _ data: Data,
         alignment: Alignment = .center,
         spacing: Double = .zero,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentSize: @escaping (Data.Element) -> LazySubviewSize)
    where
    ContentSizes == EmptyCollection<LazySubviewSize>,
    Data.Element : Identifiable,
    Data.Element.ID == ID
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentSizeProvider = .dynamic(resolveSize: contentSize)
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
    ///   - contentSize: The subview size for each element.
    init(_ axis: Axis,
         _ data: Data,
         id: KeyPath<Data.Element, ID>,
         alignment: Alignment = .center,
         spacing: Double = .zero,
         @ViewBuilder content: @escaping (Data.Element) -> Content,
         contentSize: @escaping (Data.Element) -> LazySubviewSize)
    where ContentSizes == EmptyCollection<LazySubviewSize>
    {
        self.alignment = Alignment(
            horizontal: axis == .horizontal ? .leading : alignment.horizontal,
            vertical: axis == .vertical ? .top : alignment.vertical
        )
        self.axis = axis
        self.content = content
        self.contentSizeProvider = .dynamic(resolveSize: contentSize)
        self.data = data
        self.id = id
        self.spacing = spacing
    }
}
