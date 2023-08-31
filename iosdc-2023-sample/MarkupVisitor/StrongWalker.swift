//
//  StrongWalker.swift
//  iosdc-2023-sample
//
//  Created by FromAtom on 2023/08/25.
//

import Markdown

struct StrongWalker: MarkupWalker {
    var isStrong = false
    var cursorSourceLocation: SourceLocation

    mutating func visitStrong(_ strong: Strong) -> () {
        if let range = strong.range, range.contains(cursorSourceLocation) {
            isStrong = true
            return
        }

        descendInto(strong)
    }
}
