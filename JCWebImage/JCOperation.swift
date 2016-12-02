//
//  JCOperation.swift
//  JCWebImage
//
//  Created by CXY on 16/12/1.
//  Copyright © 2016年 CXY. All rights reserved.
//

import UIKit


class JCOperation: Operation {
    var urlString = ""
    var downloadImageFinishHandler: ((UIImage) -> Void)?
    class func downloadImageOperationWithURLString(urlString: String, downloadImageFinishHandler: @escaping (UIImage)->Void) -> JCOperation {
        let downloadOperation = JCOperation()
        downloadOperation.urlString = urlString
        downloadOperation.downloadImageFinishHandler = downloadImageFinishHandler
        return downloadOperation
    }
    
    /**
     *  通过重写main方法来干涉操作的内部，从而实现中断/取消下载
     */
    override func main() {
        
        let url = URL(string: urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request,
                                        completionHandler: {(data, response, error) -> Void in
                                            if error != nil{
                                                print(error.debugDescription)
                                            } else {
                                                var image: UIImage? = nil
                                                if (data != nil) {
                                                    let nsdata = data! as NSData
                                                    nsdata.write(toFile: self.urlString.cachePath(), atomically: true)
                                                    image = UIImage(data: data!)
                                                }
                                                if self.isCancelled {
                                                    print("cancel downloading...")
                                                    return
                                                }
                                                
                                                OperationQueue.main.addOperation { 
                                                    if (self.downloadImageFinishHandler != nil && image != nil) {
                                                        self.downloadImageFinishHandler!(image!)
                                                    }
                                                }
                                            }
        }) as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()

    }
}
