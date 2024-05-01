/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import Foundation

/// The size in the major axis of a subview in a lazy layout.
public struct LazySubviewSize: Equatable {
    private init(_ source: Source) {
        self.sources = [source]
    }
    private init(_ sources: [Source]) {
        self.sources = sources
    }
    
    internal var sources: [Source]
}


public extension LazySubviewSize {
    
    /// A fixed size.
    static func fixed(_ size: Double) -> Self {
        Self(.fixed(min(max(size, .zero), .greatestFiniteMagnitude)))
    }
    
    /// A fraction of the container's size.
    static func fraction(_ fraction: Double) -> Self {
        Self(.fraction(min(max(fraction, .zero), .greatestFiniteMagnitude)))
    }
    
    /// A ratio of width to height, relative to the layout's size in the minor axis.
    static func aspect(_ ratio: Double) -> Self {
        Self(.aspect(min(max(ratio, .zero), .greatestFiniteMagnitude)))
    }
    
    /// A size derived from the hidden template content.
    ///
    /// Use `lazySubviewTemplate` within `lazyContainer` to set the hidden template content.
    static var template: Self {
        Self(.template(nil))
    }
    
    /// A size derived from the hidden template content with the provided identifier.
    ///
    /// Use `lazySubviewTemplate` within `lazyContainer` to set the hidden template content.
    static func template(id: some Hashable) -> Self {
        Self(.template(AnyHashable(id)))
    }
    
    /// A sum of multiple sizes.
    static func sum(_ sizes: Self...) -> Self {
        Self(sizes.flatMap(\.sources))
    }
    
    /// A sum of multiple sizes.
    static func sum<Sizes>(_ sizes: Sizes) -> Self
    where Sizes : Sequence,
          Sizes.Element == Self
    {
        Self(sizes.flatMap(\.sources))
    }
}


extension LazySubviewSize: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self = .fixed(Double(value))
    }
    
    public init(floatLiteral value: Double) {
        self = .fixed(value)
    }
    
    static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.sources + rhs.sources)
    }
}
