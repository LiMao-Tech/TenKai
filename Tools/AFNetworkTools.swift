//
//  AFNetworkTools.swift
//  Ten
//
//  Created by gt on 15/12/23.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
import AFNetworking

class AFNetworkTools: NSObject {
    
    static let sharedInstance = AFHTTPSessionManager()
    
    
    override init() {
        super.init()
        
    }
    
    class func getMethod(url:String,success:(NSURLSessionDataTask,AnyObject?) -> Void,failure:(NSURLSessionDataTask?,NSError) -> Void){
        
        sharedInstance.requestSerializer = AFJSONRequestSerializer()
        sharedInstance.responseSerializer = AFJSONResponseSerializer()
        
        sharedInstance.GET(url, parameters: nil, progress: nil, success: { (task, error) -> Void in
            success(task,error)
        },failure: { (task, error) -> Void in
            failure(task,error)
            print(task?.response)
        })
    }
    
    class func postMethod(url:String,parameters:[String:AnyObject],success:(NSURLSessionDataTask,AnyObject?) -> Void,failure:(NSURLSessionDataTask?,NSError) -> Void){

        sharedInstance.requestSerializer = AFJSONRequestSerializer()
        sharedInstance.responseSerializer = AFJSONResponseSerializer()
        
        sharedInstance.POST(url, parameters: parameters, progress: nil, success: { (task, response) -> Void in
            success(task,response)
            },failure:  { (task, error) -> Void in
                failure(task,error)
        })
    }
    
    class func postHeadImage(url:String,image:NSData,parameters:[String:AnyObject],success:(NSURLSessionDataTask,AnyObject?) -> Void,failure:(NSURLSessionDataTask?,NSError) -> Void){

        sharedInstance.requestSerializer = AFHTTPRequestSerializer()
        sharedInstance.responseSerializer = AFHTTPResponseSerializer()
        
        let picName = Tools.getFileNameTime(NSDate())+".png"
        sharedInstance.POST(HeadImageUrl, parameters: parameters, constructingBodyWithBlock: { (data) -> Void in
            data.appendPartWithFileData(image, name: "upload", fileName: picName, mimeType: "image/png")
            }, progress: nil, success: { (task, response) -> Void in
                success(task,response)
            },failure:  { (task, error) -> Void in
                failure(task,error)
        })
    }
    
    class func putMethod(url:String,parameters:[String:AnyObject],success:(NSURLSessionDataTask,AnyObject?) -> Void,failure:(NSURLSessionDataTask?,NSError) -> Void){

        sharedInstance.requestSerializer = AFJSONRequestSerializer()
        sharedInstance.responseSerializer = AFJSONResponseSerializer()
        
        sharedInstance.PUT(url, parameters:parameters , success: { (task, response) -> Void in
            success(task,response)
            },failure:  { (task, error) -> Void in
                failure(task,error)
        })
    }

}
