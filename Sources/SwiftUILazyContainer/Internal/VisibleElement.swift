/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct VisibleElement<Element, ID, Size>: Identifiable
where ID : Hashable
{
    let element: Element
    let id: ID
    let offset: Size
    let size: Size
}
