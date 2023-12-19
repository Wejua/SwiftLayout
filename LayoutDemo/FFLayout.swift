//
//  FFLayout.swift
//  LayoutDemo
//
//  Created by weijie.zhou on 2023/12/16.
//

import UIKit
import SnapKit

class FFLayoutMaker {
    static let shared = FFLayoutMaker()
    
    enum MakeType {
        case make
        case update
        case remake
    }
    enum InoutType {
        case `in`
        case out
    }
    enum SideType {
        case top(inset: CGFloat?)
        case left(inset: CGFloat?)
        case bottom(inset: CGFloat?)
        case right(inset: CGFloat?)
        case bottomMargin(inset: CGFloat?)
        case topMargin(inset: CGFloat?)
        case center(offsets: FFLayoutOffset? = nil, min_insets: FFLayoutInset? = nil, width: CGFloat? = nil, height: CGFloat? = nil)
    }
    enum AlignType {
        case left(inset: CGFloat?, rightInset: CGFloat?, width: CGFloat?, height: CGFloat?)
        case centerX(offset: CGFloat?, leftRightInset: CGFloat?, width: CGFloat?, height: CGFloat?)
        case right(inset: CGFloat?, leftInset: CGFloat?, width: CGFloat?, height: CGFloat?)
        case top(inset: CGFloat?, bottomInset: CGFloat?, width: CGFloat?, height: CGFloat?)
        case centerY(offset: CGFloat?, topBottomInset: CGFloat?, width: CGFloat?, height: CGFloat?)
        case bottom(inset: CGFloat?, topInset: CGFloat?, width: CGFloat?, height: CGFloat?)
        case baseLine(inset: CGFloat?, width: CGFloat?, height: CGFloat?)
        case flexHeight(topBottomInset: CGFloat, width: CGFloat?)
        case flexWidth(leftRightInset: CGFloat, height: CGFloat?)
    }
    
    var makeType: MakeType = .remake
    var inoutType: InoutType = .in
    var sideType: SideType = .top(inset: 0)
    var alignType: AlignType = .left(inset: 10, rightInset: nil, width: 100, height: 100)
    var topBottomRelativeSafeArea: Bool = false
    var view: UIView!
    var toView: UIView!
    var edgeInsets: FFLayoutEdgeInsets?
    
    func reset() {
        self.makeType = .remake
        self.inoutType = .in
        self.sideType = .top(inset: 0)
        self.alignType = .left(inset: 10, rightInset: nil, width: 100, height: 100)
        self.topBottomRelativeSafeArea = false
        self.view = nil
        self.toView = nil
        self.edgeInsets = nil
    }
    
    func addConstraints() {
        if let insets = self.edgeInsets {
            self.addEdgesConstraints(insets: insets)
        }
        else {
            self.switchSideAndAlignment()
        }
    }
    
    private func switchSideAndAlignment() {
        switch sideType {
        case .top(let offset1):
            switch alignType {
            case .left(let offset2, let rightInset, let width, let height):
                top_alignLeft(offset1: offset1, offset2: offset2, inset: rightInset, width: width, height: height)
            case .right(let offset2, let oppositeInset, let width, let height):
                top_alignRight(offset1: offset1, offset2: offset2, inset: oppositeInset, width: width, height: height)
            case .centerX(let offset2, let leftRighInset, let width, let height):
                top_alignCenterX(offset1: offset1, offset2: offset2, min_leftRighInset: leftRighInset, width: width, height: height)
            case .flexWidth(let leftRightInset, let height):
                flexWidth(sideType: .top(inset: offset1), leftRightInset: leftRightInset, height: height)
            default:
                break
            }
        case .left(let offset1):
            switch alignType {
            case .top(let offset2, let oppositeInset, let width, let height):
                left_alignTop(offset1: offset1, offset2: offset2, inset: oppositeInset, width: width, height: height)
            case .bottom(let offset2, let oppositeInset, let width, let height):
                left_alignBottom(offset1: offset1, offset2: offset2, inset: oppositeInset, width: width, height: height)
            case .centerY(let offset2, let oppositeInset, let width, let height):
                left_alignCenterY(offset1: offset1, offset2: offset2, min_topBottomInset: oppositeInset, width: width, height: height)
            case .baseLine(let offset2, let width, let height):
                left_alignBaseline(offset1: offset1, offset2: offset2, width: width, height: height)
            case .flexHeight(let topBottomInset, let width):
                flexHeight(sideType: .left(inset: offset1), topBottomInset: topBottomInset, width: width)
            default:
                break
            }
        case .bottom(let offset1):
            switch alignType {
            case .left(let offset2, let rightInset, let width, let height):
                bottom_alignLeft(offset1: offset1, offset2: offset2, inset: rightInset, width: width, height: height)
            case .right(let offset2, let oppositeInset, let width, let height):
                bottom_alignRight(offset1: offset1, offset2: offset2, inset: oppositeInset, width: width, height: height)
            case .centerX(let offset2, let leftRighInset, let width, let height):
                bottom_alignCenterX(offset1: offset1, offset2: offset2, min_leftRighInset: leftRighInset, width: width, height: height)
            case .flexWidth(let leftRightInset, let height):
                flexWidth(sideType: .top(inset: offset1), leftRightInset: leftRightInset, height: height)
            default:
                break
            }
        case .right(let offset1):
            switch alignType {
            case .top(let offset2, let oppositeInset, let width, let height):
                right_alignTop(offset1: offset1, offset2: offset2, inset: oppositeInset, width: width, height: height)
            case .bottom(let offset2, let oppositeInset, let width, let height):
                right_alignBottom(offset1: offset1, offset2: offset2, inset: oppositeInset, width: width, height: height)
            case .centerY(let offset2, let topBottomInset, let width, let height):
                right_alignCenterY(offset1: offset1, offset2: offset2, min_topBottomInset: topBottomInset, width: width, height: height)
            case .baseLine(let offset2, let width, let height):
                right_alignBaseline(offset1: offset1, offset2: offset2, width: width, height: height)
            case .flexHeight(let topBottomInset, let width):
                flexHeight(sideType: .left(inset: offset1), topBottomInset: topBottomInset, width: width)
            default:
                break
            }
        case .bottomMargin(let offset1):
            switch alignType {
            case .left(let offset2, let rightInset, let width, let height):
                self.topBottomRelativeSafeArea = true
                bottom_alignLeft(offset1: offset1, offset2: offset2, inset: rightInset, width: width, height: height)
            case .right(let offset2, let oppositeInset, let width, let height):
                self.topBottomRelativeSafeArea = true
                bottom_alignRight(offset1: offset1, offset2: offset2, inset: oppositeInset, width: width, height: height)
            case .centerX(let offset2, let leftRighInset, let width, let height):
                self.topBottomRelativeSafeArea = true
                bottom_alignCenterX(offset1: offset1, offset2: offset2, min_leftRighInset: leftRighInset, width: width, height: height)
            case .flexWidth(let leftRightInset, let height):
                flexWidth(sideType: .top(inset: offset1), leftRightInset: leftRightInset, height: height)
            default:
                break
            }
        case .topMargin(let offset1):
            switch alignType {
            case .left(let offset2, let rightInset, let width, let height):
                self.topBottomRelativeSafeArea = true
                top_alignLeft(offset1: offset1, offset2: offset2, inset: rightInset, width: width, height: height)
            case .right(let offset2, let oppositeInset, let width, let height):
                self.topBottomRelativeSafeArea = true
                top_alignRight(offset1: offset1, offset2: offset2, inset: oppositeInset, width: width, height: height)
            case .centerX(let offset2, let leftRighInset, let width, let height):
                self.topBottomRelativeSafeArea = true
                top_alignCenterX(offset1: offset1, offset2: offset2, min_leftRighInset: leftRighInset, width: width, height: height)
            case .flexWidth(let leftRightInset, let height):
                flexWidth(sideType: .top(inset: offset1), leftRightInset: leftRightInset, height: height)
            default:
                break
            }
        case .center(let offsets, let insets, let width, let height):
            center(offsets: offsets, min_insets: insets, width: width, height: height)
        }
    }
    private func addEdgesConstraints(insets: FFLayoutEdgeInsets) {
        let maker: (ConstraintMaker) -> Void = { make in
            let toView = self.toView!
            switch insets {
            case .top(let value):
                if self.topBottomRelativeSafeArea {
                    make.top.equalTo(toView.snp.topMargin).offset(value)
                } else {
                    make.top.equalTo(toView.snp.top).offset(value)
                }
            case .left(let value):
                make.left.equalTo(toView.snp.left).offset(value)
            case .bottom(let value):
                if self.topBottomRelativeSafeArea {
                    make.bottom.equalTo(toView.snp.bottomMargin).offset(-value)
                } else {
                    make.bottom.equalTo(toView.snp.bottom).offset(-value)
                }
            case .right(let value):
                make.right.equalTo(toView.snp.right).offset(-value)
            case .horizontal(let value):
                make.left.equalTo(toView.snp.left).offset(value)
                make.right.equalTo(toView.snp.right).offset(-value)
            case .vertical(let value):
                if self.topBottomRelativeSafeArea {
                    make.top.equalTo(toView.snp.topMargin).offset(value)
                    make.bottom.equalTo(toView.snp.bottomMargin).offset(-value)
                } else {
                    make.top.equalTo(toView.snp.top).offset(value)
                    make.bottom.equalTo(toView.snp.bottom).offset(-value)
                }
            case .all(let top, let left, let bottom, let right):
                if let top = top {
                    if self.topBottomRelativeSafeArea {
                        make.top.equalTo(toView.snp.topMargin).offset(top)
                    } else {
                        make.top.equalTo(toView.snp.top).offset(top)
                    }
                }
                if let left = left {make.left.equalTo(toView.snp.left).offset(left)}
                if let bottom = bottom {
                    if self.topBottomRelativeSafeArea {
                        make.bottom.equalTo(toView.snp.bottomMargin).offset(-bottom)
                    } else {
                        make.bottom.equalTo(toView.snp.bottom).offset(-bottom)
                    }
                }
                if let right = right {make.right.equalTo(toView.snp.right).offset(-right)}
            case .allZero:
                if self.topBottomRelativeSafeArea {
                    make.top.equalTo(toView.snp.topMargin)
                } else {
                    make.top.equalTo(toView.snp.top)
                }
                make.left.equalTo(toView.snp.left)
                if self.topBottomRelativeSafeArea {
                    make.bottom.equalTo(toView.snp.bottomMargin)
                } else {
                    make.bottom.equalTo(toView.snp.bottom)
                }
                make.right.equalTo(toView.snp.right)
            }
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func center(offsets: FFLayoutOffset?, min_insets: FFLayoutInset?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            make.centerX.equalTo(self.toView.snp.centerX).offset(offsets?.hori ?? 0)
            make.centerY.equalTo(self.toView.snp.centerY).offset(offsets?.verti ?? 0)
            if let insetH = min_insets?.hori {
                make.left.greaterThanOrEqualTo(self.toView.snp.left).offset(insetH)
                make.right.lessThanOrEqualTo(self.toView.snp.right).offset(-insetH)
            }
            if let insetV = min_insets?.verti {
                make.top.greaterThanOrEqualTo(self.toView.snp.top).offset(insetV)
                make.bottom.lessThanOrEqualTo(self.toView.snp.bottom).offset(-insetV)
            }
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func top_alignLeft(offset1: CGFloat?, offset2: CGFloat?, inset: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                if self.topBottomRelativeSafeArea {
                    make.top.equalTo(self.toView.snp.topMargin).offset(offset1 ?? 0)
                } else {
                    make.top.equalTo(self.toView.snp.top).offset(offset1 ?? 0)
                }
            case .out:
                make.bottom.equalTo(self.toView.snp.top).offset(-(offset1 ?? 0))
            }
            make.left.equalTo(self.toView.snp.left).offset(offset2 ?? 0)
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
            if let inset = inset  {make.right.equalTo(self.toView.snp.right).offset(-inset)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func top_alignRight(offset1: CGFloat?, offset2: CGFloat?, inset: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                if self.topBottomRelativeSafeArea {
                    make.top.equalTo(self.toView.snp.topMargin).offset(offset1 ?? 0)
                } else {
                    make.top.equalTo(self.toView.snp.top).offset(offset1 ?? 0)
                }
            case .out:
                make.bottom.equalTo(self.toView.snp.top).offset(-(offset1 ?? 0))
            }
            make.right.equalTo(self.toView.snp.right).offset(-(offset2 ?? 0))
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
            if let inset = inset  {make.left.equalTo(self.toView.snp.left).offset(inset)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func top_alignCenterX(offset1: CGFloat?, offset2: CGFloat?, min_leftRighInset: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                if self.topBottomRelativeSafeArea {
                    make.top.equalTo(self.toView.snp.topMargin).offset(offset1 ?? 0)
                } else {
                    make.top.equalTo(self.toView.snp.top).offset(offset1 ?? 0)
                }
            case .out:
                make.bottom.equalTo(self.toView.snp.top).offset(-(offset1 ?? 0))
            }
            make.centerX.equalTo(self.toView.snp.centerX).offset(offset2 ?? 0)
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
            if let inset = min_leftRighInset  {make.right.lessThanOrEqualTo(self.toView.snp.right).offset(-inset);make.left.greaterThanOrEqualTo(self.toView.snp.left).offset(inset)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func left_alignTop(offset1: CGFloat?, offset2: CGFloat?, inset: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                make.left.equalTo(self.toView.snp.left).offset(offset1 ?? 0)
            case .out:
                make.right.equalTo(self.toView.snp.left).offset(-(offset1 ?? 0))
            }
            make.top.equalTo(self.toView.snp.top).offset(offset2 ?? 0)
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
            if let inset = inset  {make.bottom.equalTo(self.toView.snp.bottom).offset(-inset)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func left_alignCenterY(offset1: CGFloat?, offset2: CGFloat?, min_topBottomInset: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                make.left.equalTo(self.toView.snp.left).offset(offset1 ?? 0)
            case .out:
                make.right.equalTo(self.toView.snp.left).offset(-(offset1 ?? 0))
            }
            make.centerY.equalTo(self.toView.snp.centerY).offset(offset2 ?? 0)
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
            if let inset = min_topBottomInset  {make.top.greaterThanOrEqualTo(self.toView.snp.top).offset(inset)
                make.bottom.lessThanOrEqualTo(self.toView.snp.bottom).offset(-inset)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func left_alignBottom(offset1: CGFloat?, offset2: CGFloat?, inset: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                make.left.equalTo(self.toView.snp.left).offset(offset1 ?? 0)
            case .out:
                make.right.equalTo(self.toView.snp.left).offset(-(offset1 ?? 0))
            }
            make.bottom.equalTo(self.toView.snp.bottom).offset(-(offset2 ?? 0))
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
            if let inset = inset  {make.top.equalTo(self.toView.snp.top).offset(inset)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func left_alignBaseline(offset1: CGFloat?, offset2: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                make.left.equalTo(self.toView.snp.left).offset(offset1 ?? 0)
            case .out:
                make.right.equalTo(self.toView.snp.left).offset(-(offset1 ?? 0))
            }
            make.lastBaseline.equalTo(self.toView.snp.lastBaseline).offset(offset2 ?? 0)
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func bottom_alignLeft(offset1: CGFloat?, offset2: CGFloat?, inset: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                if self.topBottomRelativeSafeArea {
                    make.bottom.equalTo(self.toView.snp.bottomMargin).offset(offset1 ?? 0)
                } else {
                    make.bottom.equalTo(self.toView.snp.bottom).offset(-(offset1 ?? 0))
                }
            case .out:
                make.top.equalTo(self.toView.snp.bottom).offset(offset1 ?? 0)
            }
            make.left.equalTo(self.toView.snp.left).offset(offset2 ?? 0)
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
            if let inset = inset {make.right.equalTo(self.toView.snp.right).offset(-inset)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func bottom_alignCenterX(offset1: CGFloat?, offset2: CGFloat?, min_leftRighInset: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                if self.topBottomRelativeSafeArea {
                    make.bottom.equalTo(self.toView.snp.bottomMargin).offset(offset1 ?? 0)
                } else {
                    make.bottom.equalTo(self.toView.snp.bottom).offset(-(offset1 ?? 0))
                }
            case .out:
                make.top.equalTo(self.toView.snp.bottom).offset(offset1 ?? 0)
            }
            make.centerX.equalTo(self.toView.snp.centerX).offset(offset2 ?? 0)
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
            if let inset = min_leftRighInset {make.left.greaterThanOrEqualTo(self.toView.snp.left).offset(inset)
                make.right.lessThanOrEqualTo(self.toView.snp.right).offset(-inset)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func bottom_alignRight(offset1: CGFloat?, offset2: CGFloat?, inset: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                if self.topBottomRelativeSafeArea {
                    make.bottom.equalTo(self.toView.snp.bottomMargin).offset(offset1 ?? 0)
                } else {
                    make.bottom.equalTo(self.toView.snp.bottom).offset(-(offset1 ?? 0))
                }
            case .out:
                make.top.equalTo(self.toView.snp.bottom).offset(offset1 ?? 0)
            }
            make.right.equalTo(self.toView.snp.right).offset(-(offset2 ?? 0))
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
            if let inset = inset {make.left.equalTo(self.toView.snp.left).offset(inset)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func right_alignTop(offset1: CGFloat?, offset2: CGFloat?, inset: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                make.right.equalTo(self.toView.snp.right).offset(-(offset1 ?? 0))
            case .out:
                make.left.equalTo(self.toView.snp.right).offset(offset1 ?? 0)
            }
            make.top.equalTo(self.toView.snp.top).offset(offset2 ?? 0)
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
            if let inset = inset  {make.bottom.equalTo(self.toView.snp.bottom).offset(-inset)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func right_alignCenterY(offset1: CGFloat?, offset2: CGFloat?, min_topBottomInset: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                make.right.equalTo(self.toView.snp.right).offset(-(offset1 ?? 0))
            case .out:
                make.left.equalTo(self.toView.snp.right).offset(offset1 ?? 0)
            }
            make.centerY.equalTo(self.toView.snp.centerY).offset(offset2 ?? 0)
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
            if let inset = min_topBottomInset  {make.top.greaterThanOrEqualTo(self.toView.snp.top).offset(inset)
                make.bottom.lessThanOrEqualTo(self.toView.snp.bottom).offset(-inset)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func right_alignBottom(offset1: CGFloat?, offset2: CGFloat?, inset: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                make.right.equalTo(self.toView.snp.right).offset(-(offset1 ?? 0))
            case .out:
                make.left.equalTo(self.toView.snp.right).offset(offset1 ?? 0)
            }
            make.bottom.equalTo(self.toView.snp.bottom).offset(-(offset2 ?? 0))
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
            if let inset = inset  {make.top.equalTo(self.toView.snp.top).offset(inset)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    private func right_alignBaseline(offset1: CGFloat?, offset2: CGFloat?, width: CGFloat?, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                make.right.equalTo(self.toView.snp.right).offset(-(offset1 ?? 0))
            case .out:
                make.left.equalTo(self.toView.snp.right).offset(offset1 ?? 0)
            }
            make.lastBaseline.equalTo(self.toView.snp.lastBaseline).offset(offset2 ?? 0)
            if let width = width {make.width.equalTo(width)}
            if let height = height {make.height.equalTo(height)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    func flexWidth(sideType: SideType, leftRightInset: CGFloat, height: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                switch sideType {
                case .top(inset: let offset1):
                    if self.topBottomRelativeSafeArea {
                        make.top.equalTo(self.toView.snp.topMargin).offset(offset1 ?? 0)
                    } else {
                        make.top.equalTo(self.toView.snp.top).offset(offset1 ?? 0)
                    }
                    make.left.equalTo(self.toView.snp.left).offset(leftRightInset)
                    make.right.equalTo(self.toView.snp.right).offset(-(leftRightInset))
                case.bottom(inset: let offset1):
                    if self.topBottomRelativeSafeArea {
                        make.bottom.equalTo(self.toView.snp.bottomMargin).offset(offset1 ?? 0)
                    } else {
                        make.bottom.equalTo(self.toView.snp.bottom).offset(offset1 ?? 0)
                    }
                    make.left.equalTo(self.toView.snp.left).offset(leftRightInset)
                    make.right.equalTo(self.toView.snp.right).offset(-(leftRightInset))
                default:
                    break
                }
            case .out:
                switch sideType {
                case .top(let offset1):
                    if self.topBottomRelativeSafeArea {
                        make.bottom.equalTo(self.toView.snp.topMargin).offset(-(offset1 ?? 0))
                    } else {
                        make.bottom.equalTo(self.toView.snp.top).offset(-(offset1 ?? 0))
                    }
                    make.left.equalTo(self.toView.snp.left).offset(leftRightInset)
                    make.right.equalTo(self.toView.snp.right).offset(-(leftRightInset))
                case.bottom(let offset1):
                    if self.topBottomRelativeSafeArea {
                        make.top.equalTo(self.toView.snp.bottomMargin).offset(offset1 ?? 0)
                    } else {
                        make.top.equalTo(self.toView.snp.bottom).offset(offset1 ?? 0)
                    }
                    make.left.equalTo(self.toView.snp.left).offset(leftRightInset)
                    make.right.equalTo(self.toView.snp.right).offset(-(leftRightInset))
                default:
                    break
                }
            }
            if let height = height {make.height.equalTo(height)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
    func flexHeight(sideType: SideType, topBottomInset: CGFloat, width: CGFloat?) {
        let maker: (ConstraintMaker) -> Void = { make in
            switch self.inoutType {
            case .in:
                switch sideType {
                case.right(inset: let offset1):
                    make.right.equalTo(self.toView.snp.right).offset(-(offset1 ?? 0))
                    if self.topBottomRelativeSafeArea {
                        make.top.equalTo(self.toView.snp.topMargin).offset(topBottomInset)
                        make.bottom.equalTo(self.toView.snp.bottomMargin).offset(-topBottomInset)
                    } else {
                        make.top.equalTo(self.toView.snp.top).offset(topBottomInset)
                        make.bottom.equalTo(self.toView.snp.bottom).offset(-topBottomInset)
                    }
                case.left(inset: let offset1):
                    make.left.equalTo(self.toView.snp.left).offset((offset1 ?? 0))
                    if self.topBottomRelativeSafeArea {
                        make.top.equalTo(self.toView.snp.topMargin).offset(topBottomInset)
                        make.bottom.equalTo(self.toView.snp.bottomMargin).offset(-(topBottomInset))
                    } else {
                        make.top.equalTo(self.toView.snp.top).offset(topBottomInset)
                        make.bottom.equalTo(self.toView.snp.bottom).offset(-(topBottomInset))
                    }
                default:
                    break
                }
            case .out:
                switch sideType {
                case.right(inset: let offset1):
                    make.left.equalTo(self.toView.snp.right).offset((offset1 ?? 0))
                    if self.topBottomRelativeSafeArea {
                        make.top.equalTo(self.toView.snp.topMargin).offset(topBottomInset)
                        make.bottom.equalTo(self.toView.snp.bottomMargin).offset(-(topBottomInset))
                    } else {
                        make.top.equalTo(self.toView.snp.top).offset(topBottomInset)
                        make.bottom.equalTo(self.toView.snp.bottom).offset(-(topBottomInset))
                    }
                case.left(inset: let offset1):
                    make.right.equalTo(self.toView.snp.left).offset(-(offset1 ?? 0))
                    if self.topBottomRelativeSafeArea {
                        make.top.equalTo(self.toView.snp.topMargin).offset(topBottomInset)
                        make.bottom.equalTo(self.toView.snp.bottomMargin).offset(-(topBottomInset))
                    } else {
                        make.top.equalTo(self.toView.snp.top).offset(topBottomInset)
                        make.bottom.equalTo(self.toView.snp.bottom).offset(-(topBottomInset))
                    }
                default:
                    break
                }
            }
            if let width = width {make.width.equalTo(width)}
        }
        switch self.makeType {
        case .remake:
            self.view.snp.remakeConstraints(maker)
        case .make:
            self.view.snp.makeConstraints(maker)
        case .update:
            self.view.snp.updateConstraints(maker)
        }
    }
}

struct FFLayoutInset {
    var hori: CGFloat?
    var verti: CGFloat?
}
struct FFLayoutOffset {
    var hori: CGFloat?
    var verti: CGFloat?
}
enum FFLayoutEdgeInsets: Hashable {
    case all(_ top: CGFloat?, _ left: CGFloat?, _ bottom: CGFloat?, _ right: CGFloat?)
    case allZero
    case top(CGFloat)
    case left(CGFloat)
    case bottom(CGFloat)
    case right(CGFloat)
    case horizontal(CGFloat)
    case vertical(CGFloat)
}

extension UIView {
    var make: FFLayoutInOut {
        FFLayoutMaker.shared.reset()
        FFLayoutMaker.shared.makeType = .make
        FFLayoutMaker.shared.view = self
        return FFLayoutInOut()
    }
    var remake: FFLayoutInOut {
        FFLayoutMaker.shared.reset()
        FFLayoutMaker.shared.makeType = .remake
        FFLayoutMaker.shared.view = self
        return FFLayoutInOut()
    }
    var update: FFLayoutInOut {
        FFLayoutMaker.shared.reset()
        FFLayoutMaker.shared.makeType = .update
        FFLayoutMaker.shared.view = self
        return FFLayoutInOut()
    }
}

struct FFLayoutInOut {
    var `in`: FFLayoutInSide {
        FFLayoutMaker.shared.inoutType = .in
        return FFLayoutInSide()
    }
    var out: FFLayoutOutSide {
        FFLayoutMaker.shared.inoutType = .out
        return FFLayoutOutSide()
    }
}
struct FFLayoutOutSide {
    func top(_ inset: CGFloat = 0) -> FFLaoutHorizontalAlign {
        FFLayoutMaker.shared.sideType = .top(inset: inset)
        return FFLaoutHorizontalAlign()
    }
    func left(_ inset: CGFloat = 0) -> FFLaoutVerticalAlign {
        FFLayoutMaker.shared.sideType = .left(inset: inset)
        return FFLaoutVerticalAlign()
    }
    func bottom(_ inset: CGFloat = 0) -> FFLaoutHorizontalAlign {
        FFLayoutMaker.shared.sideType = .bottom(inset: inset)
        return FFLaoutHorizontalAlign()
    }
    func right(_ inset: CGFloat = 0) -> FFLaoutVerticalAlign {
        FFLayoutMaker.shared.sideType = .right(inset: inset)
        return FFLaoutVerticalAlign()
    }
}
struct FFLayoutInSide {
    func top(_ inset: CGFloat = 0) -> FFLaoutHorizontalAlign {
        FFLayoutMaker.shared.sideType = .top(inset: inset)
        return FFLaoutHorizontalAlign()
    }
    func left(_ inset: CGFloat = 0) -> FFLaoutVerticalAlign {
        FFLayoutMaker.shared.sideType = .left(inset: inset)
        return FFLaoutVerticalAlign()
    }
    func bottom(_ inset: CGFloat = 0) -> FFLaoutHorizontalAlign {
        FFLayoutMaker.shared.sideType = .bottom(inset: inset)
        return FFLaoutHorizontalAlign()
    }
    func right(_ inset: CGFloat = 0) -> FFLaoutVerticalAlign {
        FFLayoutMaker.shared.sideType = .right(inset: inset)
        return FFLaoutVerticalAlign()
    }
    func bottomMargin(_ inset: CGFloat = 0) -> FFLaoutHorizontalAlign {
        FFLayoutMaker.shared.sideType = .bottomMargin(inset: inset)
        return FFLaoutHorizontalAlign()
    }
    func topMargin(_ inset: CGFloat = 0) -> FFLaoutHorizontalAlign {
        FFLayoutMaker.shared.sideType = .topMargin(inset: inset)
        return FFLaoutHorizontalAlign()
    }
    func center(min_leftRightInset: CGFloat?, min_topBottomInset: CGFloat?) -> FFLayoutTo {
        FFLayoutMaker.shared.sideType = .center(offsets: nil, min_insets: .init(hori: min_leftRightInset, verti: min_topBottomInset), width: nil, height: nil)
        return FFLayoutTo()
    }
    func center(min_leftRightInset: CGFloat?, height: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.sideType = .center(offsets: nil, min_insets: .init(hori: min_leftRightInset), width: nil, height: height)
        return FFLayoutTo()
    }
    func center(min_topBottomInset: CGFloat?, width: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.sideType = .center(offsets: nil, min_insets: .init(verti: min_topBottomInset), width: width, height: nil)
        return FFLayoutTo()
    }
    func center(_ offsetX: CGFloat = 0, _ offsetY: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.sideType = .center(offsets: .init(hori: offsetX, verti: offsetY), min_insets: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func edges(_ insets: FFLayoutEdgeInsets, safeArea: Bool = true) -> FFLayoutTo {
        FFLayoutMaker.shared.topBottomRelativeSafeArea = safeArea
//        if let top = top {insets.append(.top(top))}
//        if let left = left {insets.append(.left(left))}
//        if let bottom = bottom {insets.append(.bottom(bottom))}
//        if let right = right {insets.append(.right(right))}
        FFLayoutMaker.shared.edgeInsets = insets
        return FFLayoutTo()
    }
}
struct FFLaoutHorizontalAlign {
    func left(_ inset: CGFloat = 0, rightInset: CGFloat?, height: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .left(inset: inset, rightInset: rightInset, width: nil, height: height)
        return FFLayoutTo()
    }
    func left(_ inset: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .left(inset: inset, rightInset: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func right(_ inset: CGFloat = 0, leftInset: CGFloat?, height: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .right(inset: inset, leftInset: leftInset, width: nil, height: height)
        return FFLayoutTo()
    }
    func right(_ inset: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .right(inset: inset, leftInset: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func centerX(min_leftRightInset: CGFloat?, height: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .centerX(offset: nil, leftRightInset: min_leftRightInset, width: nil, height: height)
        return FFLayoutTo()
    }
    func centerX(_ offset: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .centerX(offset: offset, leftRightInset: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func flexWidth(leftRightInset: CGFloat, height: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .flexWidth(leftRightInset: leftRightInset, height: height)
        return FFLayoutTo()
    }
}
struct FFLaoutVerticalAlign {
    func centerY(min_topBottomInset: CGFloat?, width: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .centerY(offset: nil, topBottomInset: min_topBottomInset, width: width, height: nil)
        return FFLayoutTo()
    }
    func centerY(_ offset: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .centerY(offset: offset, topBottomInset: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func bottom(_ inset: CGFloat = 0, topInset: CGFloat?, width: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .bottom(inset: inset, topInset: topInset, width: width, height: nil)
        return FFLayoutTo()
    }
    func bottom(_ inset: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .bottom(inset: inset, topInset: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func top(_ inset: CGFloat = 0, bottomInset: CGFloat?, width: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .top(inset: inset, bottomInset: bottomInset, width: width, height: nil)
        return FFLayoutTo()
    }
    func top(_ inset: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .top(inset: inset, bottomInset: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func baseLine(_ inset: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .baseLine(inset: inset, width: width, height: height)
        return FFLayoutTo()
    }
    func flexHeight(topBottomInset: CGFloat, width: CGFloat? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .flexHeight(topBottomInset: topBottomInset, width: width)
        return FFLayoutTo()
    }
}
struct FFLayoutTo {
    func to(_ view: UIView) {
        FFLayoutMaker.shared.toView = view
        FFLayoutMaker.shared.addConstraints()
    }
}


