//
//  StrongRemover.swift
//  iosdc-2023-sample
//
//  Created by FromAtom on 2023/08/25.
//

import Markdown

struct StrongRemover: MarkupRewriter {
    var cursorSourceLocation: SourceLocation

    func visitStrong(_ strong: Strong) -> Markup? {
        if let range = strong.range, range.contains(cursorSourceLocation) {
            return Text(strong.plainText)
        }

        return strong
    }
}
