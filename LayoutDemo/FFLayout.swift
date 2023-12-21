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
        case top(inset: Double?)
        case left(inset: Double?)
        case bottom(inset: Double?)
        case right(inset: Double?)
        case bottomMargin(inset: Double?)
        case topMargin(inset: Double?)
        case center(offsets: FFLayoutOffset? = nil, min_insets: FFLayoutInset? = nil, width: Double? = nil, height: Double? = nil)
    }
    enum AlignType {
        case left(inset: Double?, rightInset: Double?, width: Double?, height: Double?)
        case centerX(offset: Double?, leftRightInset: Double?, width: Double?, height: Double?)
        case right(inset: Double?, leftInset: Double?, width: Double?, height: Double?)
        case top(inset: Double?, bottomInset: Double?, width: Double?, height: Double?)
        case centerY(offset: Double?, topBottomInset: Double?, width: Double?, height: Double?)
        case bottom(inset: Double?, topInset: Double?, width: Double?, height: Double?)
        case baseLine(inset: Double?, width: Double?, height: Double?)
        case flexHeight(topBottomInset: Double, width: Double?)
        case flexWidth(leftRightInset: Double, height: Double?)
    }
    
    var makeType: MakeType = .remake
    var inoutType: InoutType = .in
    var sideType: SideType = .top(inset: 0)
    var alignType: AlignType = .left(inset: 10, rightInset: nil, width: 100, height: 100)
    var topBottomRelativeSafeArea: Bool = false
    var view: UIView!
    var toView: UIView!
    var edgeInsets: FFLayoutEdgeInsets?
    var relation: FFLayoutRelation = .equal
    
    func reset() {
        self.makeType = .remake
        self.inoutType = .in
        self.sideType = .top(inset: 0)
        self.alignType = .left(inset: 10, rightInset: nil, width: 100, height: 100)
        self.topBottomRelativeSafeArea = false
        self.view = nil
        self.toView = nil
        self.edgeInsets = nil
        self.relation = .equal
    }
    
    func addConstraints() {
        if let insets = self.edgeInsets {
            if self.inoutType == .in {
                self.addInEdgesConstraints(insets: insets)
            } else {
                self.addOutEdgeConstraints()
            }
        }
        else {
            self.switchSideAndAlignment()
        }
    }
    private func addOutEdgeConstraints() {
        let maker: (ConstraintMaker) -> Void = {make in
            switch self.edgeInsets {
            case .top(let val):
                switch self.relation {
                case .equal:
                    make.top.equalTo(self.toView.snp.bottom).offset(val)
                case .less:
                    make.top.lessThanOrEqualTo(self.toView.snp.bottom).offset(val)
                case .greater:
                    make.top.greaterThanOrEqualTo(self.toView.snp.bottom).offset(val)
                }
            case .left(let val):
                switch self.relation {
                case .equal:
                    make.left.equalTo(self.toView.snp.right).offset(val)
                case .less:
                    make.left.lessThanOrEqualTo(self.toView.snp.right).offset(val)
                case .greater:
                    make.left.greaterThanOrEqualTo(self.toView.snp.right).offset(val)
                }
            case .bottom(let val):
                switch self.relation {
                case .equal:
                    make.bottom.equalTo(self.toView.snp.top).offset(-val)
                case .less:
                    make.bottom.lessThanOrEqualTo(self.toView.snp.top).offset(-val)
                case .greater:
                    make.bottom.greaterThanOrEqualTo(self.toView.snp.top).offset(-val)
                }
            case .right(let val):
                switch self.relation {
                case .equal:
                    make.right.equalTo(self.toView.snp.left).offset(-val)
                case .less:
                    make.right.lessThanOrEqualTo(self.toView.snp.left).offset(-val)
                case .greater:
                    make.right.greaterThanOrEqualTo(self.toView.snp.left).offset(-val)
                }
            default:
                break
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
    private func inEdgesTop(make: ConstraintMaker, value: Double) {
        if self.topBottomRelativeSafeArea {
            switch self.relation {
            case .equal:
                make.top.equalTo(toView.snp.topMargin).offset(value)
            case .less:
                make.top.lessThanOrEqualTo(toView.snp.topMargin).offset(value)
            case .greater:
                make.top.greaterThanOrEqualTo(toView.snp.topMargin).offset(value)
            }
        } else {
            switch self.relation {
            case .equal:
                make.top.equalTo(toView.snp.top).offset(value)
            case .less:
                make.top.lessThanOrEqualTo(toView.snp.top).offset(value)
            case .greater:
                make.top.greaterThanOrEqualTo(toView.snp.top).offset(value)
            }
        }
    }
    private func inEdgeBottom(make: ConstraintMaker, value: Double) {
        if self.topBottomRelativeSafeArea {
            switch self.relation {
            case .equal:
                make.bottom.equalTo(toView.snp.bottomMargin).offset(-value)
            case .less:
                make.bottom.lessThanOrEqualTo(toView.snp.bottomMargin).offset(-value)
            case .greater:
                make.bottom.greaterThanOrEqualTo(toView.snp.bottomMargin).offset(-value)
            }
        } else {
            switch self.relation {
            case .equal:
                make.bottom.equalTo(toView.snp.bottom).offset(-value)
            case .less:
                make.bottom.lessThanOrEqualTo(toView.snp.bottom).offset(-value)
            case .greater:
                make.bottom.greaterThanOrEqualTo(toView.snp.bottom).offset(-value)
            }
        }
    }
    private func inEdgeAll(make: ConstraintMaker, top: Double?, left: Double?, bottom: Double?, right: Double?) {
        if let top = top {
            if self.topBottomRelativeSafeArea {
                switch self.relation {
                case .equal:
                    make.top.equalTo(toView.snp.topMargin).offset(top)
                case .less:
                    make.top.lessThanOrEqualTo(toView.snp.topMargin).offset(top)
                case .greater:
                    make.top.greaterThanOrEqualTo(toView.snp.topMargin).offset(top)
                }
            } else {
                switch self.relation {
                case .equal:
                    make.top.equalTo(toView.snp.top).offset(top)
                case .less:
                    make.top.lessThanOrEqualTo(toView.snp.top).offset(top)
                case .greater:
                    make.top.greaterThanOrEqualTo(toView.snp.top).offset(top)
                }
            }
        }
        if let left = left {
            switch self.relation {
            case .equal:
                make.left.equalTo(toView.snp.left).offset(left)
            case .less:
                make.left.lessThanOrEqualTo(toView.snp.left).offset(left)
            case .greater:
                make.left.greaterThanOrEqualTo(toView.snp.left).offset(left)
            }
        }
        if let bottom = bottom {
            if self.topBottomRelativeSafeArea {
                switch self.relation {
                case .equal:
                    make.bottom.equalTo(toView.snp.bottomMargin).offset(-bottom)
                case .less:
                    make.bottom.lessThanOrEqualTo(toView.snp.bottomMargin).offset(-bottom)
                case .greater:
                    make.bottom.greaterThanOrEqualTo(toView.snp.bottomMargin).offset(-bottom)
                }
            } else {
                switch self.relation {
                case .equal:
                    make.bottom.equalTo(toView.snp.bottom).offset(-bottom)
                case .less:
                    make.bottom.lessThanOrEqualTo(toView.snp.bottom).offset(-bottom)
                case .greater:
                    make.bottom.greaterThanOrEqualTo(toView.snp.bottom).offset(-bottom)
                }
            }
        }
        if let right = right {
            switch self.relation {
            case .equal:
                make.right.equalTo(toView.snp.right).offset(-right)
            case .less:
                make.right.lessThanOrEqualTo(toView.snp.right).offset(-right)
            case .greater:
                make.right.greaterThanOrEqualTo(toView.snp.right).offset(-right)
            }
        }
    }
    private func inEdgeAllZero(make: ConstraintMaker) {
        if self.topBottomRelativeSafeArea {
             switch self.relation {
             case .equal:
                 make.top.equalTo(toView.snp.topMargin)
             case .less:
                 make.top.lessThanOrEqualTo(toView.snp.topMargin)
             case .greater:
                 make.top.greaterThanOrEqualTo(toView.snp.topMargin)
             }
        } else {
            switch self.relation {
            case .equal:
                make.top.equalTo(toView.snp.top)
            case .less:
                make.top.lessThanOrEqualTo(toView.snp.top)
            case .greater:
                make.top.greaterThanOrEqualTo(toView.snp.top)
            }
        }
        switch self.relation {
        case .equal:
            make.left.equalTo(toView.snp.left)
        case .less:
            make.left.lessThanOrEqualTo(toView.snp.left)
        case .greater:
            make.left.greaterThanOrEqualTo(toView.snp.left)
        }
        if self.topBottomRelativeSafeArea {
            switch self.relation {
            case .equal:
                make.bottom.equalTo(toView.snp.bottomMargin)
            case .less:
                make.bottom.lessThanOrEqualTo(toView.snp.bottomMargin)
            case .greater:
                make.bottom.greaterThanOrEqualTo(toView.snp.bottomMargin)
            }
        } else {
            switch self.relation {
            case .equal:
                make.bottom.equalTo(toView.snp.bottom)
            case .less:
                make.bottom.lessThanOrEqualTo(toView.snp.bottom)
            case .greater:
                make.bottom.greaterThanOrEqualTo(toView.snp.bottom)
            }
        }
        switch self.relation {
        case .equal:
            make.right.equalTo(toView.snp.right)
        case .less:
            make.right.lessThanOrEqualTo(toView.snp.right)
        case .greater:
            make.right.greaterThanOrEqualTo(toView.snp.right)
        }
    }
    private func inEdgeHorizontal(make: ConstraintMaker, value: Double) {
        switch self.relation {
        case .equal:
            make.left.equalTo(toView.snp.left).offset(value)
        case .less:
            make.left.lessThanOrEqualTo(toView.snp.left).offset(value)
        case .greater:
            make.left.greaterThanOrEqualTo(toView.snp.left).offset(value)
        }
        switch self.relation {
        case .equal:
            make.right.equalTo(toView.snp.right).offset(-value)
        case .less:
            make.right.lessThanOrEqualTo(toView.snp.right).offset(-value)
        case .greater:
            make.right.greaterThanOrEqualTo(toView.snp.right).offset(-value)
        }
    }
    private func inEdgeVertical(make: ConstraintMaker, value: Double) {
        if self.topBottomRelativeSafeArea {
            switch self.relation {
            case .equal:
                make.top.equalTo(toView.snp.topMargin).offset(value)
            case .less:
                make.top.greaterThanOrEqualTo(toView.snp.topMargin).offset(value)
            case .greater:
                make.top.lessThanOrEqualTo(toView.snp.topMargin).offset(value)
            }
            switch self.relation {
            case .equal:
                make.bottom.equalTo(toView.snp.bottomMargin).offset(-value)
            case .less:
                make.bottom.lessThanOrEqualTo(toView.snp.bottomMargin).offset(-value)
            case .greater:
                make.bottom.greaterThanOrEqualTo(toView.snp.bottomMargin).offset(-value)
            }
        } else {
            switch self.relation {
            case .equal:
                make.top.equalTo(toView.snp.top).offset(value)
            case .less:
                make.top.lessThanOrEqualTo(toView.snp.top).offset(value)
            case .greater:
                make.top.greaterThanOrEqualTo(toView.snp.top).offset(value)
            }
            switch self.relation {
            case .equal:
                make.bottom.equalTo(toView.snp.bottom).offset(-value)
            case .less:
                make.bottom.lessThanOrEqualTo(toView.snp.bottom).offset(-value)
            case .greater:
                make.bottom.greaterThanOrEqualTo(toView.snp.bottom).offset(-value)
            }
        }
    }
    private func addInEdgesConstraints(insets: FFLayoutEdgeInsets) {
        let maker: (ConstraintMaker) -> Void = { make in
            let toView = self.toView!
            switch insets {
            case .top(let value):
                self.inEdgesTop(make: make, value: value)
            case .left(let value):
                switch self.relation {
                case .equal:
                    make.left.equalTo(toView.snp.left).offset(value)
                case .less:
                    make.left.lessThanOrEqualTo(toView.snp.left).offset(value)
                case .greater:
                    make.left.greaterThanOrEqualTo(toView.snp.left).offset(value)
                }
            case .bottom(let value):
                self.inEdgeBottom(make: make, value: value)
            case .right(let value):
                switch self.relation {
                case .equal:
                    make.right.equalTo(toView.snp.right).offset(-value)
                case .less:
                    make.right.lessThanOrEqualTo(toView.snp.right).offset(-value)
                case .greater:
                    make.right.greaterThanOrEqualTo(toView.snp.right).offset(-value)
                }
            case .horizontal(let value):
                self.inEdgeHorizontal(make: make, value: value)
            case .vertical(let value):
                self.inEdgeVertical(make: make, value: value)
            case .all(let top, let left, let bottom, let right):
                self.inEdgeAll(make: make, top: top, left: left, bottom: bottom, right: right)
            case .allZero:
                self.inEdgeAllZero(make: make)
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
    private func center(offsets: FFLayoutOffset?, min_insets: FFLayoutInset?, width: Double?, height: Double?) {
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
    private func top_alignLeft(offset1: Double?, offset2: Double?, inset: Double?, width: Double?, height: Double?) {
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
    private func top_alignRight(offset1: Double?, offset2: Double?, inset: Double?, width: Double?, height: Double?) {
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
    private func top_alignCenterX(offset1: Double?, offset2: Double?, min_leftRighInset: Double?, width: Double?, height: Double?) {
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
    private func left_alignTop(offset1: Double?, offset2: Double?, inset: Double?, width: Double?, height: Double?) {
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
    private func left_alignCenterY(offset1: Double?, offset2: Double?, min_topBottomInset: Double?, width: Double?, height: Double?) {
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
    private func left_alignBottom(offset1: Double?, offset2: Double?, inset: Double?, width: Double?, height: Double?) {
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
    private func left_alignBaseline(offset1: Double?, offset2: Double?, width: Double?, height: Double?) {
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
    private func bottom_alignLeft(offset1: Double?, offset2: Double?, inset: Double?, width: Double?, height: Double?) {
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
    private func bottom_alignCenterX(offset1: Double?, offset2: Double?, min_leftRighInset: Double?, width: Double?, height: Double?) {
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
    private func bottom_alignRight(offset1: Double?, offset2: Double?, inset: Double?, width: Double?, height: Double?) {
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
    private func right_alignTop(offset1: Double?, offset2: Double?, inset: Double?, width: Double?, height: Double?) {
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
    private func right_alignCenterY(offset1: Double?, offset2: Double?, min_topBottomInset: Double?, width: Double?, height: Double?) {
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
    private func right_alignBottom(offset1: Double?, offset2: Double?, inset: Double?, width: Double?, height: Double?) {
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
    private func right_alignBaseline(offset1: Double?, offset2: Double?, width: Double?, height: Double?) {
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
    func flexWidth(sideType: SideType, leftRightInset: Double, height: Double?) {
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
    func flexHeight(sideType: SideType, topBottomInset: Double, width: Double?) {
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
    var hori: Double?
    var verti: Double?
}
struct FFLayoutOffset {
    var hori: Double?
    var verti: Double?
}

enum FFLayoutRelation {
    case equal
    case less
    case greater
}
enum FFLayoutEdgeInsets: Hashable {
    case all(_ top: Double?, _ left: Double?, _ bottom: Double?, _ right: Double?)
    case allZero
    case top(Double)
    case left(Double)
    case bottom(Double)
    case right(Double)
    case horizontal(Double)
    case vertical(Double)
}
enum FFLayoutOutEdge: Hashable {
    case top(Double)
    case left(Double)
    case bottom(Double)
    case right(Double)
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
    func top(_ inset: Double = 0) -> FFLaoutHorizontalAlign {
        FFLayoutMaker.shared.sideType = .top(inset: inset)
        return FFLaoutHorizontalAlign()
    }
    func left(_ inset: Double = 0) -> FFLaoutVerticalAlign {
        FFLayoutMaker.shared.sideType = .left(inset: inset)
        return FFLaoutVerticalAlign()
    }
    func bottom(_ inset: Double = 0) -> FFLaoutHorizontalAlign {
        FFLayoutMaker.shared.sideType = .bottom(inset: inset)
        return FFLaoutHorizontalAlign()
    }
    func right(_ inset: Double = 0) -> FFLaoutVerticalAlign {
        FFLayoutMaker.shared.sideType = .right(inset: inset)
        return FFLaoutVerticalAlign()
    }
    func edge(_ edge: FFLayoutOutEdge, relation: FFLayoutRelation = .equal) -> FFLayoutTo {
        switch edge {
        case .top(let val):
            FFLayoutMaker.shared.edgeInsets = .top(val)
            FFLayoutMaker.shared.relation = relation
        case .left(let val):
            FFLayoutMaker.shared.edgeInsets = .left(val)
            FFLayoutMaker.shared.relation = relation
        case .bottom(let val):
            FFLayoutMaker.shared.edgeInsets = .bottom(val)
            FFLayoutMaker.shared.relation = relation
        case .right(let val):
            FFLayoutMaker.shared.edgeInsets = .right(val)
            FFLayoutMaker.shared.relation = relation
        }
        return FFLayoutTo()
    }
}
struct FFLayoutInSide {
    func top(_ inset: Double = 0) -> FFLaoutHorizontalAlign {
        FFLayoutMaker.shared.sideType = .top(inset: inset)
        return FFLaoutHorizontalAlign()
    }
    func left(_ inset: Double = 0) -> FFLaoutVerticalAlign {
        FFLayoutMaker.shared.sideType = .left(inset: inset)
        return FFLaoutVerticalAlign()
    }
    func bottom(_ inset: Double = 0) -> FFLaoutHorizontalAlign {
        FFLayoutMaker.shared.sideType = .bottom(inset: inset)
        return FFLaoutHorizontalAlign()
    }
    func right(_ inset: Double = 0) -> FFLaoutVerticalAlign {
        FFLayoutMaker.shared.sideType = .right(inset: inset)
        return FFLaoutVerticalAlign()
    }
    func bottomMargin(_ inset: Double = 0) -> FFLaoutHorizontalAlign {
        FFLayoutMaker.shared.sideType = .bottomMargin(inset: inset)
        return FFLaoutHorizontalAlign()
    }
    func topMargin(_ inset: Double = 0) -> FFLaoutHorizontalAlign {
        FFLayoutMaker.shared.sideType = .topMargin(inset: inset)
        return FFLaoutHorizontalAlign()
    }
    func center(min_leftRightInset: Double?, min_topBottomInset: Double?) -> FFLayoutTo {
        FFLayoutMaker.shared.sideType = .center(offsets: nil, min_insets: .init(hori: min_leftRightInset, verti: min_topBottomInset), width: nil, height: nil)
        return FFLayoutTo()
    }
    func center(min_leftRightInset: Double?, height: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.sideType = .center(offsets: nil, min_insets: .init(hori: min_leftRightInset), width: nil, height: height)
        return FFLayoutTo()
    }
    func center(min_topBottomInset: Double?, width: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.sideType = .center(offsets: nil, min_insets: .init(verti: min_topBottomInset), width: width, height: nil)
        return FFLayoutTo()
    }
    func center(_ offsetX: Double = 0, _ offsetY: Double = 0, width: Double? = nil, height: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.sideType = .center(offsets: .init(hori: offsetX, verti: offsetY), min_insets: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func edges(_ insets: FFLayoutEdgeInsets, relation: FFLayoutRelation = .equal, safeArea: Bool = false) -> FFLayoutTo {
        FFLayoutMaker.shared.relation = relation
        FFLayoutMaker.shared.topBottomRelativeSafeArea = safeArea
        FFLayoutMaker.shared.edgeInsets = insets
        return FFLayoutTo()
    }
}
struct FFLaoutHorizontalAlign {
    func left(_ inset: Double = 0, rightInset: Double?, height: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .left(inset: inset, rightInset: rightInset, width: nil, height: height)
        return FFLayoutTo()
    }
    func left(_ inset: Double = 0, width: Double? = nil, height: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .left(inset: inset, rightInset: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func right(_ inset: Double = 0, leftInset: Double?, height: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .right(inset: inset, leftInset: leftInset, width: nil, height: height)
        return FFLayoutTo()
    }
    func right(_ inset: Double = 0, width: Double? = nil, height: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .right(inset: inset, leftInset: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func centerX(min_leftRightInset: Double?, height: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .centerX(offset: nil, leftRightInset: min_leftRightInset, width: nil, height: height)
        return FFLayoutTo()
    }
    func centerX(_ offset: Double? = nil, width: Double? = nil, height: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .centerX(offset: offset, leftRightInset: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func flexWidth(leftRightInset: Double, height: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .flexWidth(leftRightInset: leftRightInset, height: height)
        return FFLayoutTo()
    }
}
struct FFLaoutVerticalAlign {
    func centerY(min_topBottomInset: Double?, width: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .centerY(offset: nil, topBottomInset: min_topBottomInset, width: width, height: nil)
        return FFLayoutTo()
    }
    func centerY(_ offset: Double? = nil, width: Double? = nil, height: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .centerY(offset: offset, topBottomInset: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func bottom(_ inset: Double = 0, topInset: Double?, width: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .bottom(inset: inset, topInset: topInset, width: width, height: nil)
        return FFLayoutTo()
    }
    func bottom(_ inset: Double = 0, width: Double? = nil, height: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .bottom(inset: inset, topInset: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func top(_ inset: Double = 0, bottomInset: Double?, width: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .top(inset: inset, bottomInset: bottomInset, width: width, height: nil)
        return FFLayoutTo()
    }
    func top(_ inset: Double = 0, width: Double? = nil, height: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .top(inset: inset, bottomInset: nil, width: width, height: height)
        return FFLayoutTo()
    }
    func baseLine(_ inset: Double = 0, width: Double? = nil, height: Double? = nil) -> FFLayoutTo {
        FFLayoutMaker.shared.alignType = .baseLine(inset: inset, width: width, height: height)
        return FFLayoutTo()
    }
    func flexHeight(topBottomInset: Double, width: Double? = nil) -> FFLayoutTo {
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

extension Double {
    var fit: Double {
        let SFrame = UIScreen.main.bounds
        //按屏幕宽度算
        let ratio_ff = SFrame.width / 375.0
        //按对对角线算
    //    let ratio_ff = hypot(SFrame.width, SFrame.height) / hypot(375.0, 812.0)
        return self * ratio_ff
    }
}


