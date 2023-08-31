//
//  ViewController.swift
//  iosdc2023-sample
//
//  Created by FromAtom on 2023/08/16.
//

import UIKit
import Markdown

final class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.textContainerInset = .zero
            textView.delegate = self
        }
    }

    private let fontSize: CGFloat = 20.0

    override func viewDidLoad() {
        super.viewDidLoad()

        applySyntaxHighlight()
    }

    private func applySyntaxHighlight() {
        let document = Document(parsing: textView.text)
        var attributedStringWalker = AttributedStringWalker()
        attributedStringWalker.visit(document)

        let attributedString = NSMutableAttributedString(string: textView.text)
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: fontSize)], range: NSRange(0..<attributedString.length))

        for headingRange in attributedStringWalker.headingSourceRanges {
            let range = textView.convertToNSRange(from: headingRange)!
            attributedString.addAttributes([.font: UIFont.preferredFont(forTextStyle: .title1)], range: range)
        }

        for strongRange in attributedStringWalker.strongSourceRanges {
            let range = textView.convertToNSRange(from: strongRange)!
            attributedString.addAttributes([.font: UIFont.systemFont(ofSize: fontSize, weight: .bold)], range: range)
        }

        for listItemRange in attributedStringWalker.listItemSourceRanges {
            let range = textView.convertToNSRange(from: listItemRange)!
            attributedString.addAttributes([.foregroundColor: UIColor.brown], range: range)
        }

        for inlineCodeRange in attributedStringWalker.inlineCodeSourceRanges {
            let range = textView.convertToNSRange(from: inlineCodeRange)!
            attributedString.addAttributes([
                .foregroundColor: UIColor.purple,
            ], range: range)
        }

        textView.attributedText = attributedString
    }

    @IBAction func boldButtonTouchUpInside(_ sender: UIButton) {
        guard let cursorSourceLocation = textView.sourceLocation() else {
            return
        }

        let document = Document(parsing: textView.text)
        var strongWalker = StrongWalker(cursorSourceLocation: cursorSourceLocation)
        strongWalker.visit(document)

        if strongWalker.isStrong {
            var strongRemover = StrongRemover(cursorSourceLocation: cursorSourceLocation)
            let result = strongRemover.visit(document)
            textView.text = result?.format() ?? textView.text
        } else {
            if let replaceRange = textView.selectedTextRange {
                textView.replace(replaceRange, withText: "****")

                let currentLocation = textView.selectedRange.location
                let newLocation = currentLocation - 2
                textView.selectedRange = NSRange(location: newLocation, length: 0)
            } else {
                textView.text.append("****")
            }
        }
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else {
            return
        }

        applySyntaxHighlight()
    }
}

