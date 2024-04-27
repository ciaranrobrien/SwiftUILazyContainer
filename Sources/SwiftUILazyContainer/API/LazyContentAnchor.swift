/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import Foundation

/// The anchor used to determine the size of lazy content.
public struct LazyContentAnchor<Value>: Equatable
where Value : Equatable
{
    private init(_ source: Source) {
        self.source = source
    }
    
    internal var source: Source
}


public extension LazyContentAnchor {
    /// The anchor fixed to a length.
    static func fixed(_ value: Value) -> Self
    where Value == CGFloat
    {
        Self(.fixed(max(value, 0)))
    }
    
    /// The anchor fixed to a size.
    static func fixed(_ value: Value) -> Self
    where Value == CGSize
    {
        Self(.fixed(CGSize(width: max(value.width, 0), height: max(value.height, 0))))
    }
    
    /// The anchor fixed to a fraction of the container's length.
    static func fraction(_ value: Value) -> Self
    where Value == CGFloat
    {
        Self(.fraction(max(value, 0)))
    }
    
    /// The anchor fixed to a fraction of the container's size.
    static func fraction(_ value: Value) -> Self
    where Value == CGSize
    {
        Self(.fraction(CGSize(width: max(value.width, 0), height: max(value.height, 0))))
    }
    
    /// The anchor fixed to the size of the hidden template content.
    ///
    /// Use `lazyContentTemplate` on the container to set the hidden template content.
    static var template: Self {
        Self(.template(nil))
    }
    
    /// The anchor fixed to the size of the hidden template content with the provided identifier.
    ///
    /// Use `lazyContentTemplate` on the container to set the hidden template content.
    static func template(id: some Hashable) -> Self {
        Self(.template(AnyHashable(id)))
    }
}
