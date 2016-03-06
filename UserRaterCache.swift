//
//  UserRaterCache.swift
//  Ten
//
//  Created by gt on 16/3/6.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class UserRaterCache: NSObject {
    var dbq:FMDatabaseQueue!
    
    override init() {
        
        let databasePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/UserRaterInfo.db")
        /*建数据库不应该放在这个代码中，不需要判断是否存在userInfo的文件，因为必须存在*/
        
        
        //判断datapath路径下有没有feedlog.db文件
        NSFileManager.defaultManager().fileExistsAtPath(databasePath)
        dbq = FMDatabaseQueue(path: databasePath)
        dbq.inDatabase { (db) -> Void in
            let sql_stmt = "CREATE TABLE IF NOT EXISTS USERRATERINFO_\(SHARED_USER.UserIndex) (ID INTEGER PRIMARY KEY,RATERINDEX INTEGER)"
            //如果创表失败打印创表失败
            if !db.executeUpdate(sql_stmt, withArgumentsInArray: nil){
                print("创表失败！")
            }
            
        }
    }
    
    func addUserRaterByArray(raterArray:[Int]){
        let sql_insert = "INSERT INTO USERRATERINFO_\(SHARED_USER.UserIndex)(RATERINDEX) VALUES(?)"

        for rater in raterArray{
            dbq.inDatabase { (db) -> Void in
                if !db.executeUpdate(sql_insert, withArgumentsInArray: [rater]){
                    print("插入失败")
                }
            }
        }
        
    }
    func addUserRater(raterIndex:Int){
        
        let sql_insert = "INSERT INTO USERRATERINFO_\(SHARED_USER.UserIndex)(RATERINDEX) VALUES(?)"
        dbq.inDatabase { (db) -> Void in
            if !db.executeUpdate(sql_insert, withArgumentsInArray: [raterIndex]){
                print("插入失败")
            }
        }
        
    }

    
    func getUserRaterInfo() ->(raterIndexs:[Int],isEmpty:Bool){
        var isEmpty = true
        var raterIndexs = [Int]()
        dbq.inDatabase { (db) -> Void in
            let sql_select = "SELECT * FROM USERRATERINFO_\(SHARED_USER.UserIndex)"
            if let rs = db.executeQuery(sql_select, withArgumentsInArray:nil){  //可选绑定
                
                while rs.next(){
                    raterIndexs.append(Int(rs.intForColumn("RATERINDEX")))
                    isEmpty = false
                }
            }
        }
        return (raterIndexs, isEmpty)
    }
    
    func removeAllRater(){
        let sql_delete = "DELETE FROM USERRATERINFO_\(SHARED_USER.UserIndex)"
//        let sql_seqSet = "UPDATE SQLITE_SEQUENCE SET SEQ = 0 WHERE NAME = 'USERRATERINFO_\(SHARED_USER.UserIndex)'"
        dbq.inDatabase { (db) -> Void in
            if !db.executeUpdate(sql_delete, withArgumentsInArray: nil){
                print("rater table delete failed")
            }
//            if !db.executeUpdate(sql_seqSet, withArgumentsInArray: nil){
//                print("rater seq set zero failed")
//            }
        }
    }

}
