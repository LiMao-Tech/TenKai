//
//  MessageCacheTool.swift
//  Ten
//
//  Created by gt on 16/2/29.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class MessageCacheTool: NSObject {
    var dbq:FMDatabaseQueue!
    var databasePath:String
    let filemng = NSFileManager.defaultManager()
    
    init(userIndex:Int) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir1 = dirPath[0] as NSString
        databasePath = docsDir1.stringByAppendingPathComponent("/messageInfoNew.db")
        dbq = FMDatabaseQueue(path: databasePath)
        
        dbq.inDatabase { (db) -> Void in
            let sql_stmt = "CREATE TABLE IF NOT EXISTS MESSAGEINFO_\(SHARED_USER.UserIndex)_\(userIndex) (ID INTEGER PRIMARY KEY,MSGINDEX INTEGER,SENDER INTEGER,RECEIVER,ISLOCKED INTEGER,MSGTYPE INTEGER,MSGTIME INTEGER,PHONETYPE INTEGER,MSGCONTENT TEXT)"
            let sql_pic_stmt = "CREATE TABLE IF NOT EXISTS MESSAGEINFO_PIC_\(SHARED_USER.UserIndex)_\(userIndex) (ID INTEGER PRIMARY KEY,MSGINDEX INTEGER,PICTURE BLOB,WIDTH REAL,HEIGHT REAL)"
            //如果创表失败打印创表失败
            if !db.executeUpdate(sql_stmt, withArgumentsInArray: nil){
                print("创表失败！")
            }
            if !db.executeUpdate(sql_pic_stmt, withArgumentsInArray: nil){
                print("创图片存储表失败！")
            }
            
        }
    }
    //相应用户的聊天信息表中插入聊天信息
    func addMessageInfo(userIndex:Int,msg:SingleChatMessage){
        let sql_insert = "INSERT INTO MESSAGEINFO_\(SHARED_USER.UserIndex)_\(userIndex) (MSGINDEX,SENDER,RECEIVER,ISLOCKED,MSGTYPE,MSGTIME,PHONETYPE,MSGCONTENT) VALUES(?,?,?,?,?,?,?,?)"
        dbq.inTransaction { (db, rollBack) -> Void in
            if !db.executeUpdate(sql_insert, withArgumentsInArray: [msg.MsgIndex,msg.Sender,msg.Receiver,msg.IsLocked,msg.messageType.rawValue,msg.MsgTime,msg.PhoneType,msg.MsgContent]){                  print("插入失败")
            }else{
               print("插入成功")
            }
            if(msg.messageType == .Image){
                let sql_pic_stmt = "INSERT INTO MESSAGEINFO_PIC_\(SHARED_USER.UserIndex)_\(userIndex) (MSGINDEX,PICTURE) VALUES(?,?)"
                if !db.executeUpdate(sql_pic_stmt, withArgumentsInArray: [msg.MsgIndex,UIImagePNGRepresentation(msg.MsgImage!)!]){
                    print("图片插入失败")
                }else{
                    print("插入图片！！！")
                }
               
            }
        }
    }
    
    func upDateLockState(userIndex:Int,MsgIndex:Int,isLock:Bool){
        let sql_update = "UPDATE MESSAGEINFO_\(SHARED_USER.UserIndex)_\(userIndex) SET ISLOCKED = ? WHERE MSGINDEX = ?"
        dbq.inDatabase { (db) -> Void in
            db.executeUpdate(sql_update, withArgumentsInArray: [isLock ? 1:0, MsgIndex])
        }
    }
    
    func deleteMessageInfo(userIndex:Int,msg:SingleChatMessage){
        dbq.inTransaction({ (db, rollBack) -> Void in
            let sql_insert = "DELETE FROM MESSAGEINFO_\(SHARED_USER.UserIndex)_\(userIndex) WHERE MSGINDEX = ?"
            if !db.executeUpdate(sql_insert, withArgumentsInArray: [msg.MsgIndex]){
                print("删除失败")
            }
            if(msg.messageType == .Image){
                let sql_pic_stmt = "DELETE FROM MESSAGEINFO_PIC_\(SHARED_USER.UserIndex)_\(userIndex) WHERE MSGINDEX = ?"
                if !db.executeUpdate(sql_pic_stmt, withArgumentsInArray: [msg.MsgIndex]){
                    print("图片删除失败失败")
                }
            }
        })
    }
    
    func loadMessage (userIndex:Int) ->[SingleChatMessageFrame]{
        var messageFrames = [SingleChatMessageFrame]()
        
        let sql_select = "SELECT * FROM MESSAGEINFO_\(SHARED_USER.UserIndex)_\(userIndex)"
        dbq.inTransaction { (db, rollBack) -> Void in
            if let rs = db.executeQuery(sql_select, withArgumentsInArray: nil){
                while rs.next(){
                    let message = SingleChatMessage()
                    let msgFrame = SingleChatMessageFrame()
                    message.MsgIndex = Int(rs.intForColumn("MSGINDEX"))
                    message.Sender = Int(rs.intForColumn("SENDER"))
                    message.Receiver = Int(rs.intForColumn("RECEIVER"))
                    message.IsLocked = Int(rs.intForColumn("ISLOCKED")) == 1
                    message.messageType = ChatMessageType(rawValue: Int(rs.intForColumn("MSGTYPE")))!
                    message.MsgTime = NSTimeInterval(rs.intForColumn("MSGTIME"))
                    message.PhoneType = Int(rs.intForColumn("PHONETYPE"))
                    message.MsgContent = rs.stringForColumn("MSGCONTENT")
                    
                    if(message.messageType == .Image){
                        let sql_pic_stmt = "SELECT PICTURE FROM MESSAGEINFO_PIC_\(SHARED_USER.UserIndex)_\(userIndex) WHERE MSGINDEX = ?"
                        if let rs = db.executeQuery(sql_pic_stmt, withArgumentsInArray: [message.MsgIndex]){
                            while rs.next(){
                                message.MsgImage = UIImage(data: rs.dataForColumn("PICTURE"))
                            }
                        }
                    }
                    msgFrame.chatMessage = message
                    messageFrames.append(msgFrame)
                }
            }
        }
        return messageFrames
    }
    
    func loadMessage (userIndex:Int,msgIndex:Int) ->(messageFrames:[SingleChatMessageFrame],isEmpty:Bool){
        var messageFrames = [SingleChatMessageFrame]()
        let sql_select = "SELECT * FROM MESSAGEINFO_\(SHARED_USER.UserIndex)_\(userIndex) WHERE MSGINDEX < \(msgIndex) ORDER BY MSGINDEX DESC LIMIT 18"
        var isEmpty = true
        dbq.inTransaction { (db, rollBack) -> Void in
            if let rs = db.executeQuery(sql_select, withArgumentsInArray: nil){
                while rs.next(){
                    let message = SingleChatMessage()
                    let msgFrame = SingleChatMessageFrame()
                    message.MsgIndex = Int(rs.intForColumn("MSGINDEX"))
                    message.Sender = Int(rs.intForColumn("SENDER"))
                    message.Receiver = Int(rs.intForColumn("RECEIVER"))
                    message.IsLocked = Int(rs.intForColumn("ISLOCKED")) == 1
                    message.messageType = ChatMessageType(rawValue: Int(rs.intForColumn("MSGTYPE")))!
                    message.MsgTime = NSTimeInterval(rs.intForColumn("MSGTIME"))
                    message.PhoneType = Int(rs.intForColumn("PHONETYPE"))
                    message.MsgContent = rs.stringForColumn("MSGCONTENT")
                    print(message.messageType)
                    if(message.messageType == .Image){
                        let sql_pic_stmt = "SELECT PICTURE FROM MESSAGEINFO_PIC_\(SHARED_USER.UserIndex)_\(userIndex) WHERE MSGINDEX = ?"
                        if let rs = db.executeQuery(sql_pic_stmt, withArgumentsInArray: [message.MsgIndex]){
                            while rs.next(){
                                message.MsgImage = UIImage(data: rs.dataForColumn("PICTURE"))
                            }
                        }
                    }
                    isEmpty = false
                    msgFrame.chatMessage = message
                    messageFrames.append(msgFrame)
                }
            }
        }
        return (messageFrames.reverse(),isEmpty)
    }

}
