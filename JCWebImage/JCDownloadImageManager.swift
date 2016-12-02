//
//  JCDownloadImageManager.swift
//  JCWebImage
//
//  Created by CXY on 16/12/1.
//  Copyright © 2016年 CXY. All rights reserved.
//

import UIKit

extension String {
    var ns: NSString {
        return self as NSString
    }
    var pathExtension: String? {
        return ns.pathExtension
    }
    var lastPathComponent: String? {
        return ns.lastPathComponent
        
    }
    func cachePath() -> String {
        let tmp = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        var ret: String = ""
        if let str = tmp {
            ret = str+"/"+self.lastPathComponent!
        }
        return ret
    }
}

class JCDownloadImageManager: NSObject {
    
    lazy var operationCache = Dictionary<String, Any>()
    lazy var globalQueue = OperationQueue()
    lazy var imageCache = Dictionary<String, UIImage>()
    
    static let sharedManager = JCDownloadImageManager()
    private override init() {
        
    }
    
    func downloadImageWithURLString(urlString: String, completeHandler: @escaping (UIImage)->Void) -> Void {
        if (self.operationCache[urlString] != nil) {
            print("downloading...")
            return;
        }
        //check local cache
        if self.checkImageCache(urlString: urlString) {
            let image = self.imageCache[urlString]
            if let img = image {
                completeHandler(img)
            }
            return
        }
        let operation = JCOperation.downloadImageOperationWithURLString(urlString: urlString, downloadImageFinishHandler: {(image: UIImage) -> Void in
            self.operationCache[urlString] = nil
            completeHandler(image)
        })
        operation.urlString = urlString
        self.globalQueue.addOperation(operation)
        self.operationCache[urlString] = operation
    }
    
    func checkImageCache(urlString: String) -> Bool {
        //memory cache
        if self.imageCache[urlString] != nil {
            return true
        }
        //sandbox cache
        let path = urlString.cachePath()
        let image = UIImage.init(named: path)
        if (image != nil) {
            self.imageCache[urlString] = image
            return true
        }
        return false
    }
    
    func cancelDownload(urlString: String) -> Void {
        let op = self.operationCache[urlString] as! JCOperation
        if !op.isCancelled {
            op.cancel()
        }
        self.operationCache[urlString] = nil
    }
}



