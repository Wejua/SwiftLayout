//
//  FFStack.swift
//  LayoutDemo
//
//  Created by weijie.zhou on 2023/12/18.
//

import UIKit

struct FFStackSubView {
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

class FFHStack: FFView {
    enum FFHStackAlign {
        case top
        case center
        case bottom
        case baseline
    }
    //MARK: - 属性
    var views: [FFStackSubView]
    var align: FFHStackAlign
    
    //MARK: - 重写
    
    //MARK: - 方法
    init(_ views: [FFStackSubView], align: FFHStackAlign = .center) {
        self.views = views
        self.align = align
        super.init(frame: .zero)
        for i in views.indices {
            self.addSubview(views[i].view)
            if i == 0 {
                layoutFistView(view: views[i].view)
            } else if i == views.count - 1 {
                
            } else {
                
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutFistView(view: FFView) {
        switch align {
        case .top:
            view.make.in.left().top().to(self)
            view.make.in.edges(.vertical(0), relation: .less).to(self)
        case .center:
            view.make.in.left().centerY().to(self)
            view.make.in.edges(.vertical(0), relation: .less).to(self)
        case .bottom:
            view.make.in.left().bottom().to(self)
            view.make.in.edges(.vertical(0), relation: .less).to(self)
        case .baseline:
            view.make.in.left().baseLine().to(self)
            view.make.in.edges(.vertical(0), relation: .less).to(self)
        }
    }
}

class FFVStack: UIView {
    //MARK: - 属性
    
    //MARK: - 重写
    
    //MARK: - 方法
}



