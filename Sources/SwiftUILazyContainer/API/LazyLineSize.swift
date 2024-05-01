/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// The size in the minor axis of one or more lines in a lazy layout.
public enum LazyLineSize : Sendable {

    /// A single line with a fixed size.
    case fixed(Double)
    
    /// A single line with a flexible size.
    case flexible
    
    /// Multiple lines in the space of a single flexible line.
    ///
    /// The provided `constraint` is used to determine the number of lines.
    case adaptive(constraint: AdaptiveConstraint)
    
    /// Multiple lines in the space of a single flexible line.
    ///
    /// The provided `minSize` is used to determine the number of lines.
    public static func adaptive(minSize: Double) -> Self {
        .adaptive(constraint: .min(minSize))
    }
    
    /// Multiple lines in the space of a single flexible line.
    ///
    /// The provided `maxSize` is used to determine the number of lines.
    public static func adaptive(maxSize: Double) -> Self {
        .adaptive(constraint: .max(maxSize))
    }
}


public extension LazyLineSize {
    
    /// The constraint used to determine the number of lines in an adaptive line.
    enum AdaptiveConstraint : Sendable {
        
        /// The minimum size of a line.
        case min(Double)
        
        /// The maximum size of a line.
        case max(Double)
    }
}


extension [LazyLineSize]: ExpressibleByIntegerLiteral {
    
    /// Multiple lines in the space of a single flexible line.
    ///
    /// The provided `minSize` is used to determine the number of lines.
    public static func adaptive(minSize: Double) -> Self {
        [.adaptive(constraint: .min(minSize))]
    }
    
    /// Multiple lines in the space of a single flexible line.
    ///
    /// The provided `maxSize` is used to determine the number of lines.
    public static func adaptive(maxSize: Double) -> Self {
        [.adaptive(constraint: .max(maxSize))]
    }
    
    public init(integerLiteral value: Int) {
        self.init(repeating: .flexible, count: value)
    }
}


extension LazyLineSize: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public init(integerLiteral value: Int) {
        self = .fixed(Double(value))
    }
    
    public init(floatLiteral value: Double) {
        self = .fixed(value)
    }
}
