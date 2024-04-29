/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct LazyElement<Element, Geometry, ID>: Identifiable
where Geometry : Equatable,
      ID : Hashable
{
    let element: Element
    let id: ID
    let length: Geometry
    let offset: Geometry
}
