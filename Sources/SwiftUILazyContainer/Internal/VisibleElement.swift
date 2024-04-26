/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import Foundation

internal struct VisibleElement<Element, ID>: Identifiable
where ID : Hashable
{
    let element: Element
    let id: ID
    let length: CGFloat
    let offset: CGFloat
}
