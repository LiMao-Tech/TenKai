//
//  UserListCache.swift
//  Ten
//
//  Created by gt on 16/3/13.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class UserListCache: NSObject {
    var dbq:FMDatabaseQueue!
    
    override init() {
        
        let databasePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/userInfo.db")
        /*建数据库不应该放在这个代码中，不需要判断是否存在userInfo的文件，因为必须存在*/
        
        //判断datapath路径下有没有feedlog.db文件
        NSFileManager.defaultManager().fileExistsAtPath(databasePath)
        dbq = FMDatabaseQueue(path: databasePath)
        dbq.inDatabase { (db) -> Void in
            let sql_stmt = "CREATE TABLE IF NOT EXISTS USERLISTINFO_\(SHARED_USER.UserIndex) (ID INTEGER PRIMARY KEY,TYPE INTEGER,LIST BLOB)"
            //如果创表失败打印创表失败
            //type 0 active 1 inactive
            if !db.executeUpdate(sql_stmt, withArgumentsInArray: nil){
                print("创表失败！")
            }
        }
    }
    
    func addUserList(type:Int){
        var listData:NSData!
        if(type == 0){
            listData = NSKeyedArchiver.archivedDataWithRootObject(SHARED_CHATS.activeUserIndex)
        }else{
            listData = NSKeyedArchiver.archivedDataWithRootObject(SHARED_CHATS.inActiveUserIndex)
        }
        
        dbq.inDatabase { (db) -> Void in
            let sql_insert = "INSERT INTO USERLISTINFO_\(SHARED_USER.UserIndex)(TYPE,LIST) VALUES(?,?)"
            if !db.executeUpdate(sql_insert, withArgumentsInArray: [type,listData]){
                print("插入失败")
            }
        }
    }
    
    func getUserList(type:Int) -> Bool{
        var inDB = false
        dbq.inDatabase { (db) -> Void in
            let sql_select = "SELECT * FROM USERLISTINFO_\(SHARED_USER.UserIndex) WHERE TYPE = ?"
            if let rs = db.executeQuery(sql_select, withArgumentsInArray: [type]){  //可选绑定
                while rs.next(){
                    let data = rs.dataForColumn("LIST")
                    let array = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Int]
                    if(type == 0){
                        SHARED_CHATS.activeUserIndex = array
                    }else{
                        SHARED_CHATS.inActiveUserIndex = array
                    }
                    inDB = true
                }
            }
        }
        return (inDB)
    }
    
    func updateUserList(){
        let sql_update_active = "UPDATE USERLISTINFO_\(SHARED_USER.UserIndex) SET LIST = ? WHERE TYPE = 0"
        let sql_update_inActive = "UPDATE USERLISTINFO_\(SHARED_USER.UserIndex) SET LIST = ? WHERE TYPE = 1"
        let activeData = NSKeyedArchiver.archivedDataWithRootObject(SHARED_CHATS.activeUserIndex)
        let inActiveData = NSKeyedArchiver.archivedDataWithRootObject(SHARED_CHATS.inActiveUserIndex)
        dbq.inDatabase { (db) -> Void in
            if !db.executeUpdate(sql_update_active, withArgumentsInArray: [activeData]){
                print("update activeList failed")
            }
            if !db.executeUpdate(sql_update_inActive, withArgumentsInArray: [inActiveData]){
                print("update inActiveList failed")
            }
        }
    }


}
