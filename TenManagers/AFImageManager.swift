//
//  AFNetworkTools.swift
//  Ten
//
//  Created by gt on 15/12/23.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
import AFNetworking

class AFImageManager: NSObject {
    
    static let SharedInstance = AFImageManager()

    private let afHttpSessionManager = AFHTTPSessionManager()
    
    override init() {
        super.init()
        afHttpSessionManager.requestSerializer = AFHTTPRequestSerializer()
        afHttpSessionManager.responseSerializer = AFJSONResponseSerializer()
    }
    
    func postHeadImage(url:String,image:NSData,parameters:[String:AnyObject],success:(NSURLSessionDataTask,AnyObject?) -> Void,failure:(NSURLSessionDataTask?,NSError) -> Void){
        
        let picName = Tools.getFileNameTime(NSDate())+".png"
        afHttpSessionManager.POST(Url_UploadHeadImage, parameters: parameters, constructingBodyWithBlock: { (data) -> Void in
            data.appendPartWithFileData(image, name: "upload", fileName: picName, mimeType: "image/png")
            }, progress: nil, success: { (task, response) -> Void in
                success(task,response)
            },failure:  { (task, error) -> Void in
                failure(task,error)
        })
    }
    
    func postUserImage(image:NSData, parameters:[String:AnyObject], success:(NSURLSessionDataTask,AnyObject?) -> Void,failure:(NSURLSessionDataTask?,NSError) -> Void){
        
        let picName = Tools.getFileNameTime(NSDate())+".png"
        afHttpSessionManager.POST(Url_UploadPhotos, parameters: parameters, constructingBodyWithBlock: { (data) -> Void in
            data.appendPartWithFileData(image, name: "uploads", fileName: picName, mimeType: "image/png")
            }, progress: nil, success: { (task, response) -> Void in
                success(task,response)
            },failure:  { (task, error) -> Void in
                failure(task,error)
        })
    }
}
