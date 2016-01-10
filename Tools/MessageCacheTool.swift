//
//  MessageCacheTool.swift
//  Ten
//
//  Created by gt on 16/1/9.
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
            let sql_stmt = "CREATE TABLE IF NOT EXISTS MESSAGEINFO_\(userIndex) (ID INTEGER PRIMARY KEY,MSGINDEX INTEGER,BELONGTYPE INTEGER,ISLOCKED INTEGER,MSGTYPE INTEGER,MSGTIME TEXT,MSGCONTENT TEXT)"
            let sql_pic_stmt = "CREATE TABLE IF NOT EXISTS MESSAGEINFO_PIC_\(userIndex) (ID INTEGER PRIMARY KEY,MSGINDEX INTEGER,PICTURE BLOB,WIDTH REAL,HEIGHT REAL)"
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
        let sql_insert = "INSERT INTO MESSAGEINFO_\(userIndex) (MSGINDEX,BELONGTYPE,ISLOCKED,MSGTYPE,MSGTIME,MSGCONTENT) VALUES(?,?,?,?,?,?)"
        dbq.inDatabase { (db) -> Void in
            if !db.executeUpdate(sql_insert, withArgumentsInArray: [msg.MsgIndex,msg.belongType.rawValue,msg.IsLocked,msg.messageType.rawValue,msg.MsgTime,msg.MsgContent]){                  print("插入失败")
            }
            if(msg.messageType == .Image){
                self.addMessageImage(userIndex, msg: msg)
            }
        }
    }
    
    func deleteMessageInfo(userIndex:Int,msg:SingleChatMessage){
        let sql_insert = "DELETE FROM MESSAGEINFO_\(userIndex) WHERE MSGINDEX = ?"
        dbq.inDatabase { (db) -> Void in
        if !db.executeUpdate(sql_insert, withArgumentsInArray: [msg.MsgIndex]){                  print("删除失败")
            }
        }
        if(msg.messageType == .Image){
            self.deleteMessageImage(userIndex, msg: msg)
        }
    }
    
    func loadMessage (userIndex:Int) ->SingleChatMessage{
        let msgg = SingleChatMessage()
        let sql_select = "SELECT * FROM MESSAGEINFO_\(userIndex)"
        dbq.inDatabase { (db) -> Void in
            if let rs = db.executeQuery(sql_select, withArgumentsInArray: nil){
                
                while rs.next(){
                    msgg.belongType = (rs.intForColumn("BELONGTYPE") == 0) ? ChatBelongType.Me : ChatBelongType.Other
                    msgg.IsLocked = Int(rs.intForColumn("ISLOCKED")) == 0
                    msgg.messageType = ChatMessageType(rawValue: Int(rs.intForColumn("MSGTYPE")))!
                    // image?
                    
                    msgg.MsgTime = rs.stringForColumn("MSGTIME")
                    msgg.MsgContent = rs.stringForColumn("MSGCONTENT")
                }
            }
        }
        return msgg
    }
    
    private func addMessageImage(userIndex:Int,msg:SingleChatMessage){
        let sql_pic_stmt = "INSERT INTO MESSAGEINFO_PIC_\(userIndex) (MSGINDEX,PICTURE,WIDTH,HEIGHT) VALUES(?,?,?,?)"
        dbq.inDatabase { (db) -> Void in
            if !db.executeUpdate(sql_pic_stmt, withArgumentsInArray: [msg.MsgIndex,UIImagePNGRepresentation(msg.MsgImage!)!,(msg.MsgImage?.size.width)!,(msg.MsgImage?.size.height)!]){
                print("图片插入失败")
            }
        }
    }
    
    private func deleteMessageImage(userIndex:Int,msg:SingleChatMessage){
        let sql_pic_stmt = "DELETE FROM MESSAGEINFO_PIC_\(userIndex) WHERE MSGINDEX = ?"
        dbq.inDatabase { (db) -> Void in
            if !db.executeUpdate(sql_pic_stmt, withArgumentsInArray: [msg.MsgIndex]){
                print("图片删除失败失败")
            }
        }
    }
    
    // string转attributeString
    class func stringToAttributeString(matchString:String) -> (text:NSMutableAttributedString,isString:Bool) {
        let Str:NSString = matchString as NSString
        var isString = true
        let pattern = "\\[\\d{3}\\]"
        var text = NSMutableAttributedString(string: matchString)
        var array = Array<NSTextCheckingResult>()
        let expression=try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        expression.enumerateMatchesInString(matchString, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, matchString.characters.count)) { (result, flag, stop) -> Void in
            if((result) != nil){
                array.append(result!)
            }
        }
        
        if(array.count > 0){
            isString = false
            let len = text.length - (array[array.count-1].range.location + array[array.count-1].range.length)
            for(var i = array.count - 1; i >= 0; i--){
                let attr = NSMutableAttributedString(attributedString: text)
                let temp = Str.substringWithRange((array[i].range)) as NSString
                let temp0 = attr.attributedSubstringFromRange(NSMakeRange(0, array[i].range.location))
                let location1 = array[i].range.location + array[i].range.length
                let len1 = attr.length - location1
                let temp1 = attr.attributedSubstringFromRange(NSMakeRange(location1, len1))
                if(faceCodes.containsObject(temp)){
                    let attachment = GTTextAttachment()
                    attachment.image = UIImage(named:temp.substringWithRange(NSMakeRange(1, 3)) as String)
                    attachment.faceCode = temp
                    let attStr = NSAttributedString(attachment: attachment)
                    attr.setAttributedString(NSAttributedString(string: ""))
                    attr.appendAttributedString(temp0)
                    attr.setAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15)], range: NSMakeRange(0, temp0.length))
                    attr.appendAttributedString(attStr)
                    attr.appendAttributedString(temp1)
                    attr.setAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15)], range: NSMakeRange(attr.length-len,len))
                    text = attr
                }
            }
        }
        return (text,isString)
    }
    
}
