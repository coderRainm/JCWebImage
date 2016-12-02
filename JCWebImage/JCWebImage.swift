//
//  JCWebImage.swift
//  JCWebImage
//
//  Created by CXY on 16/12/1.
//  Copyright © 2016年 CXY. All rights reserved.
//

import UIKit

let JCAssociatedObjectKey = "JCAssociatedObjectKey"


// MARK: - UIImageView extension
extension UIImageView {
    
    var currentURLString: String? {
        get {
            return objc_getAssociatedObject(self, JCAssociatedObjectKey) as! String?
        }
        set {
            objc_setAssociatedObject(self, JCAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    func jc_setImageWithURLString(urlString: String) -> Void {
        JCDownloadImageManager.sharedManager.downloadImageWithURLString(urlString: urlString, completeHandler: { (image: UIImage) -> Void in
            self.image = image
        })
        self.currentURLString = urlString
    }
}
