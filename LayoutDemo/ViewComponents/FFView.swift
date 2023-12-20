//
//  FFView.swift
//  LayoutDemo
//
//  Created by weijie.zhou on 2023/12/18.
//

import UIKit

class FFView: UIView {
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
