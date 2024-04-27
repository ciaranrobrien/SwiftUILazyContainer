/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import Foundation

public enum LazyContentGeometry<Geometry>: Equatable
where Geometry : Equatable
{
    case fixed(Geometry)
    case template(AnyHashable?)
    
    public static var template: Self {
        .template(nil)
    }
    public static func template(id: some Hashable) -> Self {
        .template(AnyHashable(id))
    }
}
