//
//  NotificationCacheTool.swift
//  fmdbTest
//
//  Created by gt on 16/1/11.
//  Copyright © 2016年 ycl. All rights reserved.
//

import UIKit

class NotificationCacheTool: NSObject {
    var dbq:FMDatabaseQueue!
    var databasePath:String
    let filemng = NSFileManager.defaultManager()
    
    override init() {
                //获取library目录
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir1 = dirPath[0] as NSString
        //print(dirPath)
        databasePath = docsDir1.stringByAppendingPathComponent("/notificationInfo.db")
        dbq = FMDatabaseQueue(path: databasePath)
        dbq.inDatabase { (db) -> Void in
            let sql_stmt = "CREATE TABLE IF NOT EXISTS NOTIFICATIONINFO_\(SHARED_USER.UserIndex) (ID INTEGER PRIMARY KEY,MSGTYPE INTEGER,MSGTIME TEXT,MSGCONTENT TEXT,MSGINDEX INTEGER)"
            //如果创表失败打印创表失败
            if !db.executeUpdate(sql_stmt, withArgumentsInArray: nil){
                print("创表失败！")
            }

        }
        
    }
    
    func addNotificationInfo(noti:Notification){
            let sql_insert = "INSERT INTO NOTIFICATIONINFO_\(SHARED_USER.UserIndex) (MSGTYPE,MSGTIME,MSGCONTENT,MSGINDEX) VALUES(?,?,?,?)"
            dbq.inDatabase { (db) -> Void in
                if !db.executeUpdate(sql_insert, withArgumentsInArray: [noti.MsgType,noti.MsgTime,noti.MsgContent,noti.MsgIndex]){                  print("插入失败")
                }
            }
        }
    func loadNotification () ->(notis:[NotificationFrame],isEmpty:Bool){
        var inDB = true
        var notis = [NotificationFrame]()
        let sql_select = "SELECT * FROM NOTIFICATIONINFO_\(SHARED_USER.UserIndex)"
        dbq.inDatabase { (db) -> Void in
            if let rs = db.executeQuery(sql_select, withArgumentsInArray: nil){
                while rs.next(){
                    let noteFrame = NotificationFrame()
                    let nott = Notification()
                    nott.MsgType = Int(rs.intForColumn("MSGTYPE"))
                    nott.MsgTime = rs.stringForColumn("MSGTIME")
                    nott.MsgContent = rs.stringForColumn("MSGCONTENT")
                    nott.MsgIndex = Int(rs.intForColumn("MSGINDEX"))
                    noteFrame.notification = nott
                    notis.append(noteFrame)
                    inDB = false
                }
            }
        }
        return (notis,inDB)
    }
    
}
