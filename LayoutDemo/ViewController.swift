//
//  ViewController.swift
//  LayoutDemo
//
//  Created by weijie.zhou on 2023/12/10.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    //MARK: - 属性
    private lazy var contentLabel: UILabel = {
        let contentLabel = createLabel(text: "", backgroundColor: .red)
        self.view.addSubview(contentLabel)
        return contentLabel
    }()
    private lazy var label1 = {
        let label1 = createLabel(text: "label1.remake.in.top().left().to(contentLabel)", backgroundColor: .blue)
        contentLabel.addSubview(label1)
        return label1
    }()
    private lazy var label2 = {
        let label2 = createLabel(text: "label2.remake.in.top().centerX().to(contentLabel)", backgroundColor: .blue)
        contentLabel.addSubview(label2)
        return label2
    }()
    private lazy var label3 = {
        let label3 = createLabel(text: "label3.remake.in.top().right().to(contentLabel)", backgroundColor: .blue)
        contentLabel.addSubview(label3)
        return label3
    }()
    private lazy var label4 = {
        let label4 = createLabel(text: "label4.remake.in.left().centerY().to(contentLabel)", backgroundColor: .blue)
        contentLabel.addSubview(label4)
        return label4
    }()
    private lazy var label5 = {
        let label5 = createLabel(text: "label5.remake.in.centerWithSize().to(contentLabel)", backgroundColor: .blue)
        contentLabel.addSubview(label5)
        return label5
    }()
    private lazy var label6 = {
        let label6 = createLabel(text: "label6.remake.in.right().centerY().to(contentLabel)", backgroundColor: .blue)
        contentLabel.addSubview(label6)
        return label6
    }()
    private lazy var label7 = {
        let label7 = createLabel(text: "label7.remake.in.bottom().left().to(contentLabel)", backgroundColor: .blue)
        contentLabel.addSubview(label7)
        return label7
    }()
    private lazy var label8 = {
        let label8 = createLabel(text: "label8.remake.in.bottom().centerX().to(contentLabel)", backgroundColor: .blue)
        contentLabel.addSubview(label8)
        return label8
    }()
    private lazy var label9 = {
        let label9 = createLabel(text: "label9.remake.in.bottom().right().to(contentLabel)", backgroundColor: .blue)
        contentLabel.addSubview(label9)
        return label9
    }()
    
    //MARK: - 重写
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.test_in_size()
//        self.test_in_inset()
//        test_out_size()
        test_out_inset()
    }
    
    //MARK: - 方法
    private func test_out_inset() {
        contentLabel.remake.in.edges(.all(200, 100, 200, 100), safeArea: false).to(self.view)
        let inset: Double = 20
        let height: Double = 70
        let width: Double = 40
        //一行代码解决视图布局，代码简短易读，写起来也快
        //解决经常写错布局的问题，错误的布局不会通过点语法提示出来
        //根据布局规律套用对应方法，降低忘记有关约束的概率，比如label设置了left和top，但是忘记了right和屏幕右边的间距，在label内容很长的时候就超出了屏幕右边
        label1.remake.out.top(inset).left(inset, rightInset: inset, height: height).to(contentLabel)
        label1.remake.out.left(inset).top(inset, bottomInset: inset, width: width).to(contentLabel)

        label2.remake.out.top(inset).centerX(min_leftRightInset: inset, height: height).to(contentLabel)

        label3.remake.out.top(inset).right(inset, leftInset: inset, height: height).to(contentLabel)
        label3.remake.out.right(inset).top(inset, bottomInset: inset, width: width).to(contentLabel)

        label4.remake.out.left(inset).centerY(min_topBottomInset: inset, width: width).to(contentLabel)

        label6.remake.out.right(inset).centerY(min_topBottomInset: inset, width: width).to(contentLabel)

        label7.remake.out.bottom(inset).left(inset, rightInset: inset, height: height).to(contentLabel)
//        label7.remake.out.left(inset).bottom(inset, topInset: inset, width: width).to(contentLabel)

//        label8.remake.out.bottom(inset).centerX(min_leftRightInset: inset, height: height).to(contentLabel)

//        label9.remake.out.bottom(inset).right(inset, leftInset: inset, height: height).to(contentLabel)
//        label9.remake.out.right(inset).bottom(inset, topInset: inset, width: width).to(contentLabel)
        
    }
    private func test_out_size() {
        contentLabel.remake.in.edges(.all(200, 100, 200, 100)).to(self.view)
        let inset: Double = 20
        let height: Double = 70
        let width: Double = 40
        
        label1.remake.out.top(inset).left(inset, width: width, height: height).to(contentLabel)
        label2.remake.out.top(inset).centerX(0, width: width, height: height).to(contentLabel)
        label3.remake.out.top(inset).right(inset, width: width, height: height).to(contentLabel)
        
//        label4.remake.out.right(inset).top(inset, width: width, height: height).to(contentLabel)
//        label5.remake.out.right(inset).centerY(offset: inset, width: width, height: height).to(contentLabel)
//        label6.remake.out.right(inset).bottom(inset, width: width, height: height).to(contentLabel)
//
        label4.remake.out.left(inset).top(inset, width: width, height: height).to(contentLabel)
        label5.remake.out.left(inset).centerY(inset, width: width, height: height).to(contentLabel)
        label6.remake.out.left(inset).bottom(inset, width: width, height: height).to(contentLabel)
        
        label7.remake.out.bottom(inset).left(inset, width: width, height: height).to(contentLabel)
        label8.remake.out.bottom(inset).centerX(0, width: width, height: height).to(contentLabel)
        label9.remake.out.bottom(inset).right(inset, width: width, height: height).to(contentLabel)
    }
    
    private func test_in_inset() {
        contentLabel.remake.in.edges(.all(20, 20, 20, 20)).to(self.view)
        let inset: Double = 20
        let height: Double? = 130
        let width: Double? = 80
        //一行代码解决视图布局，代码简短易读，写起来也快
        //解决经常写错布局的问题，错误的布局不会通过点语法提示出来
        //根据布局规律套用对应方法，降低忘记有关约束的概率，比如label设置了left和top，但是忘记了right和屏幕右边的间距，在label内容很长的时候就超出了屏幕右边
        label1.remake.in.top(inset).left(inset, rightInset: inset, height: height).to(contentLabel)
//        label1.remake.in.left(inset).top(inset, bottomInset: inset, width: width).to(contentLabel)

        label2.remake.in.top(inset).centerX(min_leftRightInset: inset, height: height).to(contentLabel)
        
        label3.remake.in.top(inset).right(inset, leftInset: inset, height: height).to(contentLabel)
//        label3.remake.in.right(inset).top(inset, bottomInset: inset, width: width).to(contentLabel)

        label4.remake.in.left(inset).centerY(min_topBottomInset: inset, width: width).to(contentLabel)

        label5.remake.in.center(min_topBottomInset: inset, width: width).to(contentLabel)
//        label5.remake.in.center(min_leftRightInset: inset, height: height).to(contentLabel)
//        label5.remake.in.center(min_leftRightInset: inset, min_topBottomInset: inset).to(contentLabel)

        label6.remake.in.right(inset).centerY(min_topBottomInset: inset, width: width).to(contentLabel)

        label7.remake.in.bottom(inset).left(inset, rightInset: inset, height: height).to(contentLabel)
//        label7.remake.in.left(inset).bottom(inset, topInset: inset, width: width).to(contentLabel)

        label8.remake.in.bottom(inset).centerX(min_leftRightInset: inset, height: height).to(contentLabel)

        label9.remake.in.bottom(inset).right(inset, leftInset: inset, height: height).to(contentLabel)
//        label9.remake.in.right(inset).bottom(inset, topInset: inset, width: width).to(contentLabel)
    }
    
    private func test_in_size() {
        contentLabel.remake.in.edges(.all(20, 20, 20, 20)).to(self.view)
        
        let width: Double? = 80
        let height: Double? = 130
        let inset: Double = 10
        label1.remake.in.top(inset).left(inset, width: width, height: height).to(contentLabel)
        label2.remake.in.top(inset).centerX(inset, width: width, height: height).to(contentLabel)
        label3.remake.in.top(inset).right(inset, width: width, height: height).to(contentLabel)
        label4.remake.in.left(inset).centerY(inset, width: width, height: height).to(contentLabel)
        label5.remake.in.center(inset, inset, width: width, height: height).to(contentLabel)
        
        label6.remake.in.right(inset).centerY(inset, width: width, height: height).to(contentLabel)
        label7.remake.in.bottom(inset).left(inset, width: width, height: height).to(contentLabel)
        label8.remake.in.bottom(inset).centerX(inset, width: width, height: height).to(contentLabel)
        label9.remake.in.bottom(inset).right(inset, width: width, height: height).to(contentLabel)
    }
    
    private func createLabel(text: String, backgroundColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.backgroundColor = backgroundColor
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        return label
    }
}


