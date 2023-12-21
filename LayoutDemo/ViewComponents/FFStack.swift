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
            } else {
                layoutOtherView(view: views[i].view, preV: views[i-1])
            }
            if i == views.count - 1 {
                self.layoutLastView(view: views[i].view)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutOtherView(view: FFView, preV: FFStackSubView) {
        switch align {
        case .top:
            view.make.out.right(preV.space).top(preV.offset).to(preV.view)
            view.make.in.edges(.vertical(0), relation: .less).to(self)
        case .center:
            view.make.out.right(preV.space).centerY(preV.offset).to(preV.view)
            view.make.in.edges(.vertical(0), relation: .less).to(self)
        case .bottom:
            view.make.out.right(preV.space).bottom(preV.offset).to(preV.view)
            view.make.in.edges(.vertical(0), relation: .less).to(self)
        case .baseline:
            view.make.out.right(preV.space).baseLine(preV.offset).to(preV.view)
            view.make.in.edges(.vertical(0), relation: .less).to(self)
        }
    }
    
    private func layoutLastView(view: FFView) {
        switch align {
        case .top:
            view.make.in.right().top().to(self)
            view.make.in.edges(.vertical(0), relation: .less).to(self)
        case .center:
            view.make.in.right().centerY().to(self)
            view.make.in.edges(.vertical(0), relation: .less).to(self)
        case .bottom:
            view.make.in.right().bottom().to(self)
            view.make.in.edges(.vertical(0), relation: .less).to(self)
        case .baseline:
            view.make.in.right().baseLine().to(self)
            view.make.in.edges(.vertical(0), relation: .less).to(self)
        }
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



