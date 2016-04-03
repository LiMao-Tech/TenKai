//
//  PcoinPurchaseHistoryCache.swift
//  Ten
//
//  Created by gt on 16/2/29.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class PcoinPurchaseHistoryCache: NSObject {
    var dbq:FMDatabaseQueue!
    
    override init() {
        
        let databasePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/purchaseHistoryInfo.db")
        /*建数据库不应该放在这个代码中，不需要判断是否存在userInfo的文件，因为必须存在*/
        
        
        //判断datapath路径下有没有feedlog.db文件
        NSFileManager.defaultManager().fileExistsAtPath(databasePath)
        dbq = FMDatabaseQueue(path: databasePath)
        dbq.inDatabase { (db) -> Void in
            let sql_stmt = "CREATE TABLE IF NOT EXISTS PURCHASEHISTORYINFO_\(SHARED_USER.UserIndex) (NEWID INTEGER PRIMARY KEY,ID INTEGER,CONTENT TEXT,MODIFIEDDATE INTEGER,PURCHASEDATE INTEGER,PUCHASETYPE INTEGER,STATUS TEXT,USERID TEXT)"
            //如果创表失败打印创表失败
            if !db.executeUpdate(sql_stmt, withArgumentsInArray: nil){
                print("创表失败！")
            }
            
        }
    }
    
    func addPurchaseHistoryInfo(info:PCoinHistoryModel){
        dbq.inDatabase { (db) -> Void in
            let sql_insert = "INSERT INTO PURCHASEHISTORYINFO_\(SHARED_USER.UserIndex)(ID,CONTENT,MODIFIEDDATE,PURCHASEDATE,PUCHASETYPE,STATUS,USERID) VALUES(?,?,?,?,?,?,?)"
            if !db.executeUpdate(sql_insert, withArgumentsInArray: [info.ID,info.Content,info.ModifiedDate,info.PurchaseDate,info.PurchaseType,info.Status,info.UserId]){
                print("插入失败")
            }
        }
        
    }
    
    func getPurchaseHistoryInfo() ->(infos:[PCoinHistoryModel],isEmpty:Bool){
        var isEmpty = true
        var infos = [PCoinHistoryModel]()
        dbq.inDatabase { (db) -> Void in
            let sql_select = "SELECT * FROM PURCHASEHISTORYINFO_\(SHARED_USER.UserIndex)"
            if let rs = db.executeQuery(sql_select, withArgumentsInArray:nil){  //可选绑定
                while rs.next(){
                    let info = PCoinHistoryModel()
                    info.ID = Int(rs.intForColumn("ID"))
                    info.Content = rs.stringForColumn("CONTENT")
                    info.ModifiedDate = NSTimeInterval(rs.intForColumn("MODIFIEDDATE"))
                    info.PurchaseDate = NSTimeInterval(rs.intForColumn("PURCHASEDATE"))
                    info.PurchaseType = Int(rs.intForColumn("PUCHASETYPE"))
                    info.Status = rs.stringForColumn("STATUS")
                    info.UserId = rs.stringForColumn("USERID")
                    isEmpty = false
                    infos.append(info)
                }
            }
        }
        return (infos, isEmpty)
    }
}
