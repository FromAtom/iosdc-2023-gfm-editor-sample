//
//  UITextViewExtensions.swift
//  iosdc-2023-sample
//
//  Created by FromAtom on 2023/08/24.
//

import UIKit
import Markdown

extension UITextView {
    func sourceLocation() -> SourceLocation? {
        guard let selectedTextRange else {
            return nil
        }

        // ドキュメントの先頭からカーソル位置までの文字列を取得
        guard
            let beginningOfDocumentToCursorPositionRange = textRange(from: beginningOfDocument, to: selectedTextRange.start),
            let beginningOfDocumentToCursorPositionString = text(in: beginningOfDocumentToCursorPositionRange)
        else {
            return nil
        }

        let lineCount = beginningOfDocumentToCursorPositionString.components(separatedBy: .newlines).count

        // カーソルがある行の行頭からカーソル位置までの文字列を取得
        guard
            let lineRange = tokenizer.rangeEnclosingPosition(selectedTextRange.start, with: .line, inDirection: .storage(.forward)),
            let columnStringRange = textRange(from: lineRange.start, to: selectedTextRange.start),
            let columnString = text(in: columnStringRange)
        else {
            return nil
        }

        // SourceLocationのcolumnはUTF-8でカウントする
        // SourceLocationはカウントが1から始まるので1を足す
        let utf8BasedColumnCount = columnString.utf8.count + 1

        return SourceLocation(line: lineCount, column: utf8BasedColumnCount, source: nil)
    }

    func convertToNSRange(from sourceRange: SourceRange) -> NSRange? {
        guard
            let start = convertToBound(from: sourceRange.lowerBound),
            let end = convertToBound(from: sourceRange.upperBound)
        else {
            return nil
        }

        return NSRange(start..<end)
    }

    private func convertToBound(from sourceLocation: SourceLocation) -> Int? {
        var currentLine: Int = 1
        var utf16CharCount: Int = 0
        for line in text.components(separatedBy: .newlines) {
            if currentLine == sourceLocation.line {
                let columnString = line.utf8.prefix(sourceLocation.column - 1)
                let columnStringUtf16Count = columnString.endIndex.utf16Offset(in: line)
                return utf16CharCount + columnStringUtf16Count
            }

            currentLine += 1
            utf16CharCount += line.utf16.count + "\n".utf16.count
        }

        return nil
    }
}
