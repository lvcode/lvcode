//
//  UIImage+Extension.swift
//  byqmDoctor
//
//  Created by Lyu Qiang on 2021/4/23.
//  Copyright © 2021 Yunnan Baiyao Group Medicine Electronic Business Co., Ltd. All rights reserved.
//

import ImageIO
import UIKit

extension UIImage {
    /// 颜色生成图片
    /// - Parameter color: 图片颜色
    /// - Returns: UIImage
    static func generateWithColor(color: UIColor) -> UIImage {
        return UIImage.generateWithColor(color: color, size: CGSize(width: 1, height: 1))
    }
    
    /// 颜色生成图片
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: CGSize
    /// - Returns: UIImage
    static func generateWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 更改图片的背景色
    func replaceImageBgColor(tintColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        tintColor.setFill()
        let bounds = CGRect(origin: CGPoint.zero, size: self.size)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: .destinationIn, alpha: 1)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
    
    /// 取图片某点像素的颜色
    /// - Parameter atPixel: CGPoint
    /// - Returns: UIColor
    func getColor(atPixel: CGPoint) -> UIColor? {
        let width = self.size.width
        let height = self.size.height
        if !CGRect(x: 0, y: 0, width: width, height: height).contains(atPixel) {
            return nil
        }
        let pointX = trunc(atPixel.x) // 取整
        let pointY = trunc(atPixel.y)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * 1
        let bitsPerComponent = 8
        var pixelData = Array<Int>.init()
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        context?.setBlendMode(CGBlendMode.copy)
        context?.translateBy(x: pointX, y: pointY - height)
        context?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        let red = CGFloat(pixelData[0]) / 255.0
        let green = CGFloat(pixelData[1]) / 255.0
        let blue = CGFloat(pixelData[2]) / 255.0
        let alpha = CGFloat(pixelData[3]) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 设置图片圆角
    /// - Parameter radius: 圆角 CGFloat
    /// - Returns: UIImage
    func imageCornerRadius(radius: CGFloat) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath)
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 生成二维码
    ///
    /// - Parameters:
    ///   - content: 二维码内容
    ///   - logoImage: 中心展示的logo，如果不展示则不传入
    class func qrCode(content: String?, logoImage: UIImage? = nil) -> UIImage? {
        guard let stringData = content?.data(using: .utf8, allowLossyConversion: false) else { return nil }
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setDefaults()
        filter.setValue(stringData, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = filter.outputImage
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        let codeImage = UIImage(ciImage: colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))
        
        if let logoImage = logoImage {
            let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
            UIGraphicsBeginImageContext(rect.size)
            codeImage.draw(in: rect)
            let avatarSize = CGSize(width: rect.size.width * 0.25, height: rect.size.height * 0.25)
            let x = (rect.width - avatarSize.width) * 0.5
            let y = (rect.height - avatarSize.height) * 0.5
            logoImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resultImage
        }
        
        return codeImage
    }
    
    /// 生成条形码
    ///
    /// - Parameters:
    ///   - content: 内容
    ///   - width: 宽
    ///   - height: 高
    class func barCode(content: String?, width: CGFloat, height: CGFloat) -> UIImage? {
        guard let content = content else { return nil }
        
        if content.count > 0, width > 0, height > 0 {
            let inputData = content.data(using: .utf8)
            guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else { return nil }
            filter.setValue(inputData, forKey: "inputMessage")
            guard var ciImage = filter.outputImage else { return nil }
            let scaleX = width / ciImage.extent.size.width
            let scaleY = height / ciImage.extent.size.height
            ciImage = ciImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            return UIImage(ciImage: ciImage)
        }
        return nil
    }
}
