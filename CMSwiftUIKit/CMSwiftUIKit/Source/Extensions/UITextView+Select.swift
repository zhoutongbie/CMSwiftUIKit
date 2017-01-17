//
//  UITextView+Select.swift
//  YFStore
//
//  Created by I Mac on 17/1/4.
//  Base on Aerolitec Template
//  Copyright © 2017年 yfdyf. All rights reserved.
//

import Foundation


extension UITextView {
    func getInputLengthWithText(text:String) -> Int {
        var textLength = 0
        let selectedRange = self.markedTextRange
        if selectedRange != nil {
            var newText = self.text(in: selectedRange!)
            textLength = ((newText?.characters.count)! + 1) / 2 + self.offset(from: self.beginningOfDocument, to: (selectedRange?.start)!) + text.characters.count
        }
        else {
            textLength = self.text.characters.count + text.characters.count
        }
        return textLength
    }
}
