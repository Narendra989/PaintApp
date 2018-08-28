//
//  PaintViewModel.swift
//  PaintApp
//
//  Created by Narendra Satpute on 28/08/18.
//  Copyright © 2018 Digi. All rights reserved.
//

import UIKit

class PaintViewModel: NSObject {
    var tempDrawImage: UIImageView!
    var mainImage: UIImageView!
    var lastPoint: CGPoint!
    var red: CGFloat!
    var green: CGFloat!
    var blue: CGFloat!
    var brush: CGFloat!
    var opacity: CGFloat!
    var mouseSwiped: Bool!
    var selectedColor: UIColor!
    
    //MARK: Constant
    let screenSize = UIScreen.main.bounds.size
    
    func loadView(view: UIView){
        tempDrawImage = UIImageView(frame: CGRect(x: 0, y: 0, width: screenSize.width , height: screenSize.height))
        mainImage = UIImageView(frame: CGRect(x: 0, y: 0, width: screenSize.width , height: screenSize.height))
        view.addSubview(mainImage)
        view.addSubview(tempDrawImage)
        brush = 5.0;
        opacity = 1.0;
        selectedColor = UIColor.black
    }
    
    func touchBegin(_ touches: Set<UITouch>, view: UIView) {
        mouseSwiped = false
        print("Touch Began")
        let touch = touches.first! as UITouch
        lastPoint = touch.location(in: view)
    }
    
    func touchMoved(_ touches: Set<UITouch>, view: UIView) {
        mouseSwiped = true
        let touch = touches.first! as UITouch
        let currentPoint = touch.location(in: view)
        UIGraphicsBeginImageContext(view.frame.size)
        self.tempDrawImage.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        context?.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brush)
        context?.setStrokeColor(selectedColor.cgColor)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        self.tempDrawImage.alpha = opacity
        UIGraphicsEndImageContext()
        lastPoint = currentPoint
    }
    
     func touchEnded(_ touches: Set<UITouch>, view: UIView) {
        print("Touch Ended")
        if(!mouseSwiped){
            UIGraphicsBeginImageContext(view.frame.size)
            self.tempDrawImage.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            let context = UIGraphicsGetCurrentContext()
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(brush)
            context?.setStrokeColor(selectedColor.cgColor)
            context?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            context?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            context?.strokePath()
            context?.flush()
            self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        renderImage(view: view)
    }
    
    func renderImage(view: UIView) {
        UIGraphicsBeginImageContext(self.mainImage.frame.size)
        self.mainImage.image?.draw(in: CGRect(x: 0, y: 0, width:view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        self.tempDrawImage.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext()
        self.tempDrawImage.image = nil
        UIGraphicsEndImageContext()
        AppStorage.shared.selectedImage = self.mainImage.image
    }
    
    func changeLineColor(color: UIColor) {
       selectedColor = color
    }
    
    func clearDrawing() {
        self.tempDrawImage.image = nil
        self.mainImage.image = nil
    }
    
    func changeBrushSize(size: CGFloat) {
        brush = size
    }
    
    func showImageOnCanvas(image: UIImage) {
        self.mainImage.image = image
    }
}
