/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal enum LazySubviewSizeProvider<Element, Sizes>
where Sizes : RandomAccessCollection,
      Sizes.Element == LazySubviewSize
{
    case dynamic(resolveSize: (Element) -> LazySubviewSize)
    case fixed(sizes: Sizes)
}
