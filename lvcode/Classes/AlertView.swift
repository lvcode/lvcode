//
//  AlertView.swift
//  byqmDoctor
//
//  Created by 陈某人 on 2021/5/6.
//  Copyright © 2021 Yunnan Baiyao Group Medicine Electronic Business Co., Ltd. All rights reserved.
//

import UIKit

class AlertView: UIControl {

    typealias alertBlock = (_ buttonIndex: NSInteger) -> Void

    private var block: alertBlock?

    private var titleLabel: UILabel!
    private var lineView: UIView!
    private var messageLabel: UILabel!
    private var cancelButton: UIButton!
    private var otherButton: UIButton!
    private var backView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor(white: 0/255.0, alpha: 0.5)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AlertView {
    func show() {

        UIApplication.shared.keyWindow?.endEditing(true)
        UIApplication.shared.delegate?.window??.addSubview(self)
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.3

        let values = NSMutableArray()
        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(0.3, 0.3, 1.0)))
        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)))
        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values as? [Any]

        backView.layer.add(animation, forKey: nil)

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
    }

    func dismiss() {

        UIView.animate(withDuration: 0.3, delay: 0.0, options:[ .allowUserInteraction, .curveEaseIn, .beginFromCurrentState], animations: {

            self.backView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.alpha = 0.0

        }, completion: { [weak backView,self] (_) in
            backView!.transform = CGAffineTransform.identity
            self.removeFromSuperview()
        })

    }
}


extension AlertView {

    static func alert(title: String?, message: String?, cancelButtonTitle: String?, otherButtonTitle: String?, didDismissCompletion: ((_ buttonIndex: NSInteger) -> Void)?) -> AlertView {

        let alertView = AlertView()
        alertView.block = didDismissCompletion
        alertView.config(title: title ?? "", message: message ?? "", cancelButtonTitle: cancelButtonTitle ?? "", otherButtonTitle: otherButtonTitle ?? "")
        alertView.show()

        return alertView

    }

    func config(title: String, message: String, cancelButtonTitle: String, otherButtonTitle: String) {
        backView = UIView()
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 5
        backView.layer.masksToBounds = true
        addSubview(backView)

//        if title.count > 0 {
//            titleLabel = UILabel()
//            titleLabel.textAlignment = .center
//            titleLabel.font = UIFont.systemFont(ofSize: 17)
//            titleLabel.adjustsFontSizeToFitWidth = true
//            titleLabel.textColor = UIColor.black
//            titleLabel.text = title
//            backView.addSubview(titleLabel)
//            titleLabel.snp.makeConstraints { make in
//                make.left.equalTo(backView).offset(20)
//                make.right.equalTo(backView).offset(-20)
//                make.top.equalTo(backView).offset(19)
//                make.height.equalTo(17)
//            }
//
//            lineView = UIView()
//            lineView.backgroundColor = UIColor.lightGray
//            backView.addSubview(lineView)
//            lineView.snp.makeConstraints { make in
//                make.left.equalTo(backView).offset(20)
//                make.right.equalTo(backView).offset(-20)
//                make.height.equalTo(0.5)
//                make.top.equalTo(titleLabel.snp.bottom).offset(18)
//            }
//
//            backView.snp.makeConstraints { make in
//                make.centerX.equalTo(self)
//                make.centerY.equalTo(self).multipliedBy(1.05)
//                make.width.equalTo(UIScreen.main.bounds.size.width*0.8)
//                make.height.greaterThanOrEqualTo(175)
//                make.height.lessThanOrEqualTo(UIScreen.main.bounds.size.height*0.8)
//            }
//
//        }else {
//            backView.snp.makeConstraints { make in
//                make.centerX.equalTo(self)
//                make.centerY.equalTo(self).multipliedBy(1.05)
//                make.width.equalTo(UIScreen.main.bounds.size.width*0.8)
//                make.height.greaterThanOrEqualTo(140)
//                make.height.lessThanOrEqualTo(UIScreen.main.bounds.size.height*0.8)
//            }
//        }
//
//        if message.count > 0 {
//            messageLabel = UILabel()
//            messageLabel.numberOfLines = 0
//            messageLabel.font = UIFont.systemFont(ofSize: 17)
//            messageLabel.text = message
//            messageLabel.textAlignment = .center
//            messageLabel.textColor = UIColor.darkText
//            backView.addSubview(messageLabel)
//            messageLabel.snp.makeConstraints { make in
//                make.left.equalTo(backView).offset(23)
//                make.right.equalTo(backView).offset(-23)
//                if title.count > 0 {
//                    make.top.equalTo(lineView).offset(18)
//                }else {
//                    make.top.equalTo(backView).offset(18)
//                }
//                make.height.greaterThanOrEqualTo(17)
//            }
//        }else {
//            backView.snp.updateConstraints { make in
//                make.centerX.equalTo(self)
//                make.centerY.equalTo(self).multipliedBy(1.05)
//                make.width.equalTo(UIScreen.main.bounds.size.width*0.8)
//                make.height.greaterThanOrEqualTo(135)
//                make.height.lessThanOrEqualTo(UIScreen.main.bounds.size.height*0.8)
//            }
//        }

//        if title.count > 0 {
//            if messageLabel != nil {
//                messageLabel.font = UIFont.systemFont(ofSize: 14)
//            }
//        }
//
//        cancelButton = UIButton(type: .custom)
//        cancelButton.layer.cornerRadius = 20
//        cancelButton.layer.masksToBounds = true
//        cancelButton.layer.borderWidth = 1
//        cancelButton.layer.borderColor = UIColor.yellow.cgColor
//        cancelButton.setTitle(cancelButtonTitle, for: .normal)
//
//        cancelButton.setBackgroundImage(UIImage.generateWithColor(color: .white, size: CGSize(width: 1,height: 1)), for: .normal)
//        cancelButton.setBackgroundImage(UIImage.generateWithColor(color: UIColor.lightText, size: CGSize(width: 1, height: 1)), for: .highlighted)
//        cancelButton.setTitleColor(UIColor.lightText, for: .normal)
//        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        backView.addSubview(cancelButton)
//        cancelButton.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
//        cancelButton.snp.makeConstraints { make in
//            if  otherButtonTitle.count > 0 {
//                make.left.equalTo(backView).offset(20)
//                make.width.equalTo(UIScreen.main.bounds.size.width*118)
//            }else{
//                make.width.equalTo(UIScreen.main.bounds.size.width*170)
//                make.centerX.equalTo(backView)
//            }
//            make.height.equalTo(40)
//            if messageLabel != nil {
//                make.top.equalTo(messageLabel.snp.bottom).offset(26)
//                make.bottom.equalTo(backView).offset(-15)
//            }else {
//                make.top.equalTo(lineView.snp.bottom).offset(20)
//                make.bottom.equalTo(backView).offset(-20)
//            }
//        }
//
//        if otherButtonTitle.count > 0 {
//            otherButton = UIButton(type: .custom)
//            otherButton.layer.cornerRadius = 20
//            otherButton.layer.masksToBounds = true
//            otherButton.tag = 500
//            otherButton.setTitle(otherButtonTitle, for: .normal)
//            otherButton.setBackgroundImage(UIImage.generateWithColor(color: UIColor.blue, size: CGSize(width: 1, height: 1)), for: .normal)
//            otherButton.setBackgroundImage(UIImage.generateWithColor(color: UIColor.systemBlue, size: CGSize(width: 1, height: 1)), for: .highlighted)
//            otherButton.setTitleColor(.white, for: .normal)
//            otherButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//            otherButton.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
//            backView.addSubview(otherButton)
//            otherButton.snp.makeConstraints { make in
//                make.right.equalTo(backView).offset(-20)
//                make.height.equalTo(40)
//                make.width.equalTo(UIScreen.main.bounds.size.width*118)
//                make.top.bottom.equalTo(cancelButton)
//            }
//        }else{
//            cancelButton.setBackgroundImage(UIImage.generateWithColor(color: UIColor.blue, size: CGSize(width: 1, height: 1)), for: .normal)
//            cancelButton.setBackgroundImage(UIImage.generateWithColor(color: UIColor.systemBlue, size: CGSize(width: 1, height: 1)), for: .highlighted)
//            cancelButton.setTitleColor(.white, for: .normal)
//        }
    }

    @objc func clickAction(sender: UIButton) {
        if (block != nil) {
            if sender.tag == 500 {
                block!(1)
            }else{
                block!(0)
            }
        }
        dismiss()
    }


}
