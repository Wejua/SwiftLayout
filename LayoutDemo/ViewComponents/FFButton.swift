//
//  FFButton.swift
//  LayoutDemo
//
//  Created by flqy on 2023/12/19.
//

import UIKit

class FFButton: UIView {
    //MARK: - 属性
    var intrinsicSizeCustom: CGSize?
    
    //MARK: - 重写
    override var intrinsicContentSize: CGSize {
        if let intrinsicSizeCustom = intrinsicSizeCustom {
            return intrinsicSizeCustom
        } else {
            return super.intrinsicContentSize
        }
    }
    
    //MARK: - 方法
}
