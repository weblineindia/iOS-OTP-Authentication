//
//  HelperClass.swift
//  DemoLoginWithOTP
//
//  Created by WeblineIndia on 01/07/20.
//  Copyright © 2020 WeblineIndia. All rights reserved.
//

import UIKit

class HelperClass: NSObject {

    ///- Show progress view
    class func showActivityIndicatory(uiView: UIView) {
           
           for subview in uiView.subviews {
               if subview.tag == -123 {
                   print("already added")
                   return
               }
           }
           let container: UIView = UIView()
           container.tag = -123
           container.frame = uiView.frame
           container.center = uiView.center
           container.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
           
           let loadingView: UIView = UIView()
           loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
           loadingView.center = uiView.center
           loadingView.backgroundColor = .black
           loadingView.clipsToBounds = true
           loadingView.layer.cornerRadius = 10
           
           let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
           actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        if #available(iOS 13.0, *) {
            actInd.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
           actInd.color = .white
           actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                   y: loadingView.frame.size.height / 2);
           loadingView.addSubview(actInd)
           container.addSubview(loadingView)
           uiView.addSubview(container)
           actInd.startAnimating()
       }
    
    ///- Hide progress view
       class func hideActivityIndicator(uiView: UIView) {
           let container = uiView.viewWithTag(-123)
           // I think you forgot to remove it?
           container?.removeFromSuperview()
           
           if let subview = uiView.viewWithTag(-123) {
               subview.removeFromSuperview()
           }
       }
}
