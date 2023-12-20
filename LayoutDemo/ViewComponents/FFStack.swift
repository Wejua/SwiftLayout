//
//  FFStack.swift
//  LayoutDemo
//
//  Created by weijie.zhou on 2023/12/18.
//

import UIKit

class FFHStack: FFView {
    struct FFHStackSubView {
        //MARK: - 属性
        var view: FFView
        var space: Double = 10
        var offset: Double = 0
        
        //MARK: - 重写
        
        //MARK: - 方法
        init(_ view: FFView, space: Double, offset: Double) {
            self.view = view
            self.space = space
            self.offset = offset
        }
    }
    
    enum FFHStackAlign {
        case top
        case center
        case bottom
        case baseline
    }
    //MARK: - 属性
    var views: FFHStackSubView
    var align: FFHStackAlign
    
    //MARK: - 重写
    
    //MARK: - 方法
    init(_ views: FFHStackSubView, align: FFHStackAlign = .center) {
        self.views = views
        self.align = align
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FFVStack: UIView {
    //MARK: - 属性
    
    //MARK: - 重写
    
    //MARK: - 方法
}



