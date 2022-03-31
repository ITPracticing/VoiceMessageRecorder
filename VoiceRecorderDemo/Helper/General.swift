//
//  Functions Helper.swift
//  VoiceRecorderDemo
//
//  Created by F_Sur on 31/03/2022.
//

import UIKit

let MainColor: UIColor = #colorLiteral(red: 0.0862745098, green: 0.3607843137, blue: 0.0862745098, alpha: 1)
let SecondaryColor: UIColor = #colorLiteral(red: 0.6901960784, green: 0.7529411765, blue: 0.6901960784, alpha: 1)

/// Size = 22
let headerSize1: CGFloat = 22
/// Size = 18
let headerSize2: CGFloat = 18
/// Size = 16
let headerSize3: CGFloat = 16
/// Size = 14
let headerSize4: CGFloat = 14
/// Size = 12
let headerSize5: CGFloat = 12


public func makeDateFormating(date: Date) -> String {
    let dateFormatting = DateFormatter()
    dateFormatting.dateFormat = "yyyy-MM-dd'T:'HH:mm:ss"
    return dateFormatting.string(from: date)
}


