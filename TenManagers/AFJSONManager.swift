//
//  AFNetworkTools.swift
//  Ten
//
//  Created by gt on 15/12/23.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
import AFNetworking

class AFJSONManager: NSObject {
    
    static let SharedInstance = AFJSONManager()
    
    private let afHttpSessionManager = AFHTTPSessionManager()
    
    override init() {
        super.init()
        afHttpSessionManager.requestSerializer = AFJSONRequestSerializer()
        afHttpSessionManager.responseSerializer = AFJSONResponseSerializer()
    }
    
    func getMethod(url:String,success:(NSURLSessionDataTask,AnyObject?) -> Void, failure:(NSURLSessionDataTask?,NSError) -> Void){
        
        afHttpSessionManager.GET(url, parameters: nil, progress: nil, success: { (task, error) -> Void in
            success(task,error)
        },failure: { (task, error) -> Void in
            failure(task,error)
            print(task?.response)
        })
    }
    
    func getMethodWithParams(url:String,parameters:[String:AnyObject],success:(NSURLSessionDataTask,AnyObject?) -> Void,failure:(NSURLSessionDataTask?,NSError) -> Void){
        
        afHttpSessionManager.GET(url, parameters: parameters, progress: nil, success: { (task, error) -> Void in
            success(task,error)
            },failure: { (task, error) -> Void in
                failure(task,error)
                print(task?.response)
        })
    }
    
    func postMethod(url:String,parameters:[String:AnyObject],success:(NSURLSessionDataTask,AnyObject?) -> Void,failure:(NSURLSessionDataTask?,NSError) -> Void){
        
        afHttpSessionManager.POST(url, parameters: parameters, progress: nil, success: { (task, response) -> Void in
            success(task,response)
            },failure:  { (task, error) -> Void in
                failure(task,error)
        })
    }
    
    func putMethod(url:String,parameters:[String:AnyObject],success:(NSURLSessionDataTask,AnyObject?) -> Void,failure:(NSURLSessionDataTask?,NSError) -> Void){
        
        afHttpSessionManager.PUT(url, parameters:parameters , success: { (task, response) -> Void in
            success(task,response)
            },failure:  { (task, error) -> Void in
                failure(task,error)
        })
    }
    
    func putMethod(url:String,success:(NSURLSessionDataTask,AnyObject?) -> Void,failure:(NSURLSessionDataTask?,NSError) -> Void){
        
        afHttpSessionManager.PUT(url, parameters:nil , success: { (task, response) -> Void in
            success(task,response)
            },failure:  { (task, error) -> Void in
                failure(task,error)
        })
    }
}
