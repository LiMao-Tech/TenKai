//
//  GTTextAttachment.swift
//  swiftChat
//
//  Created by gt on 15/9/14.
//  Copyright (c) 2015年 gt. All rights reserved.
//

import UIKit

class GTTextAttachment: NSTextAttachment {
    var faceCode : NSString = ""
    override func attachmentBoundsForTextContainer(textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        return CGRectMake(0, 0, 17,17)
    }
}
