//
//  AttributedStringWalker.swift
//  iosdc-2023-sample
//
//  Created by FromAtom on 2023/08/25.
//

import UIKit
import Markdown

struct AttributedStringWalker: MarkupWalker {
    var headingSourceRanges: [SourceRange] = []
    var strongSourceRanges: [SourceRange] = []
    var inlineCodeSourceRanges: [SourceRange] = []
    var listItemSourceRanges: [SourceRange] = []

    mutating func visitHeading(_ heading: Heading) -> () {
        if let range = heading.range {
            headingSourceRanges.append(range)
        }

        descendInto(heading)
    }

    mutating func visitListItem(_ listItem: ListItem) -> () {
        if let range = listItem.range {
            listItemSourceRanges.append(range)
        }

        descendInto(listItem)
    }

    mutating func visitInlineCode(_ inlineCode: InlineCode) -> () {
        if let range = inlineCode.range {
            inlineCodeSourceRanges.append(range)
        }

        descendInto(inlineCode)
    }

    mutating func visitStrong(_ strong: Strong) -> () {
        if let range = strong.range {
            strongSourceRanges.append(range)
        }

        descendInto(strong)
    }
}
