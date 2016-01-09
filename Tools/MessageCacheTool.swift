//
//  MessageCacheTool.swift
//  Ten
//
//  Created by gt on 16/1/9.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class MessageCacheTool: NSObject {
    var db:FMDatabaseQueue!
    var databasePath:String
    let filemng = NSFileManager.defaultManager()
    
    init(userIndex:Int) {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir1 = dirPath[0] as NSString
        databasePath = docsDir1.stringByAppendingPathComponent("messageInfoNew.db")
        db = FMDatabaseQueue(path: databasePath)
     
        db.inDatabase { (db) -> Void in
            let sql_stmt = "CREATE TABLE IF NOT EXISTS MESSAGEINFO_\(userIndex) (ID INTEGER PRIMARY KEY,MSGINDEX INTEGER,BELONGTYPE INTEGER,ISLOCKED INTEGER,MSGTYPE INTEGER,MSGTIME TEXT,MSGCONTENT TEXT)"
            //如果创表失败打印创表失败
            if !db.executeUpdate(sql_stmt, withArgumentsInArray: nil){
                print("创表失败！")
            }
        }
    }
    //相应用户的聊天信息表中插入聊天信息
    func addMessageInfo(userIndex:Int,msg:SingleChatMessage){
        let sql_insert = "INSERT INTO MESSAGEINFO_\(userIndex) (MSGINDEX,BELONGTYPE,ISLOCKED,MSGTYPE,MSGTIME,MSGCONTENT) VALUES(?,?,?,?,?,?)"
        db.inDatabase { (db) -> Void in
            if !db.executeUpdate(sql_insert, withArgumentsInArray: [msg.MsgIndex,msg.belongType.rawValue,msg.IsLocked,msg.messageType.rawValue,msg.MsgTime,msg.MsgContent]){                  print("插入失败")
            }
        }
    }
    
    func loadMessage (userIndex:Int) ->SingleChatMessage{
        let msgg = SingleChatMessage()
        let sql_select = "SELECT * FROM MESSAGEINFO_\(userIndex)"
        db.inDatabase { (db) -> Void in
            if let rs = db.executeQuery(sql_select, withArgumentsInArray: nil){
                
                while rs.next(){
                    msgg.belongType = (rs.intForColumn("BELONGTYPE") == 0) ? ChatBelongType.Me : ChatBelongType.Other
                    msgg.IsLocked = Int(rs.intForColumn("ISLOCKED")) == 0
                    switch Int(rs.intForColumn("MSGTYPE")){
                    case 0: msgg.messageType = ChatMessageType.Message
                    case 1: msgg.messageType = ChatMessageType.Image
                    case 2: msgg.messageType = ChatMessageType.Pcoin
                    default:break
                    }
                    msgg.MsgTime = rs.stringForColumn("MSGTIME")
                    msgg.MsgContent = rs.stringForColumn("MSGCONTENT")
                    print("--------------")
                    print("MsgContent:"+msgg.MsgContent)
                    print("--------------")
                }
            }
        }
        return msgg
    }
}
