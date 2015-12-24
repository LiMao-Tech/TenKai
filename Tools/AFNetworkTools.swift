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
    class func getMethod(url:String,success:(AFHTTPRequestOperation!,AnyObject!) -> Void,failure:(AFHTTPRequestOperation?,NSError) -> Void){
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.GET( url,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                success(operation,responseObject)
            },
            failure: { (operation,error) in
                failure(operation,error)
        })
    }
}
