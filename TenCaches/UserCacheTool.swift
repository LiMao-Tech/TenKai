//
//  UserCacheTool.swift
//  fmdbTest
//
//  Created by gt on 15/12/14.
//  Copyright © 2015年 ycl. All rights reserved.
//

import UIKit


class UserCacheTool: NSObject {
    
     var dbq:FMDatabaseQueue!
 
     override init() {
        
        let databasePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/userInfo.db")
        /*建数据库不应该放在这个代码中，不需要判断是否存在userInfo的文件，因为必须存在*/
        
        //判断datapath路径下有没有feedlog.db文件
        NSFileManager.defaultManager().fileExistsAtPath(databasePath)
        dbq = FMDatabaseQueue(path: databasePath)
        dbq.inDatabase { (db) -> Void in
            let sql_stmt = "CREATE TABLE IF NOT EXISTS USERINFO (ID INTEGER PRIMARY KEY,USERINDEX INTEGER , USERNAME TEXT,PHONETYPE INTEGER,GENDER INTEGER,MARRIAGE INTEGER,BIRTHDAY INTEGER,JOINEDDATE INTEGER,PCOIN REAL,OUTERSCORE INTEGER,INNERSCORE INTEGER,ENERGY INTEGER,HOBBY TEXT,QUOTE TEXT,LATI REAL,LONGI REAL,PORTRAIT BLOB,PROFILEURL TEXT,MSGINDEX INTEGER,EXPIRE INTEGER,AVG INTEGER)"
            //如果创表失败打印创表失败
            if !db.executeUpdate(sql_stmt, withArgumentsInArray: nil){
                print("创表失败！")
            }

        }
    }
    
    func updateUserInfo(dict:NSDictionary) {
        dbq.inDatabase { (db) -> Void in
            let sql_insert = "UPDATE USERINFO SET GENDER = ?,MARRIAGE = ?,PCOIN = ?,OUTERSCORE = ?,INNERSCORE = ?,ENERGY = ?,HOBBY = ?,QUOTE = ?,LATI = ?,LONGI = ?,AVG = ?,EXPIRE = ? WHERE USERINDEX = ?"
            
            if !db.executeUpdate(sql_insert, withArgumentsInArray: [dict["Gender"]!,dict["Marriage"]!,dict["PCoin"]!,dict["OuterScore"]!,dict["InnerScore"]!,dict["Energy"]!,dict["Hobby"]!,dict["Quote"]!,dict["Lati"]!,dict["Longi"]!,dict["UserIndex"]!,dict["AVG"]!,dict["Expire"]!]){                  print("修改失败")
            }
        }
    }
    
    func updateUserInfo(){
        let sql_update = "UPDATE USERINFO SET GENDER = ?,MARRIAGE = ?,PCOIN = ?,OUTERSCORE = ?,INNERSCORE = ?,ENERGY = ?,HOBBY = ?,QUOTE = ?,LATI = ?,LONGI = ?,AVG = ?,EXPIRE = ? WHERE USERINDEX = ?"
        dbq.inDatabase { (db) -> Void in
            db.executeUpdate(sql_update, withArgumentsInArray: [SHARED_USER.Gender,SHARED_USER.Marriage,SHARED_USER.PCoin,SHARED_USER.OuterScore,SHARED_USER.InnerScore,SHARED_USER.Energy,SHARED_USER.Hobby,SHARED_USER.Quote,SHARED_USER.Lati,SHARED_USER.Longi,SHARED_USER.AVG,SHARED_USER.Expire, SHARED_USER.UserIndex])
        }
    }
    
    func upDateUserPortrait(){
        let sql_update = "UPDATE USERINFO SET PORTRAIT = ? WHERE USERINDEX = ?"
        dbq.inDatabase { (db) -> Void in
            db.executeUpdate(sql_update, withArgumentsInArray: [SHARED_USER.Portrait!, SHARED_USER.UserIndex])
        }
    }
    func upDateUserPCoin(){
        let sql_update = "UPDATE USERINFO SET PCOIN = ? WHERE USERINDEX = ?"
        dbq.inDatabase { (db) -> Void in
            db.executeUpdate(sql_update, withArgumentsInArray: [SHARED_USER.PCoin, SHARED_USER.UserIndex])
        }
    }
    
    func upDateUserMsgIndex(){
        let sql_update = "UPDATE USERINFO SET MSGINDEX = ? WHERE USERINDEX = ?"
        dbq.inDatabase { (db) -> Void in
            db.executeUpdate(sql_update, withArgumentsInArray: [SHARED_USER.MsgIndex, SHARED_USER.UserIndex])
        }
    }
    
    func addUserInfoByUser(){
        dbq.inDatabase { (db) -> Void in
            let sql_insert = "INSERT INTO USERINFO(USERINDEX,USERNAME,PHONETYPE,GENDER,MARRIAGE,BIRTHDAY,JOINEDDATE,PCOIN,OUTERSCORE,INNERSCORE,ENERGY,HOBBY,QUOTE,LATI,LONGI,PORTRAIT,PROFILEURL,MSGINDEX,AVG,EXPIRE) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
            if !db.executeUpdate(sql_insert, withArgumentsInArray: [SHARED_USER.UserIndex,SHARED_USER.UserName,SHARED_USER.PhoneType,SHARED_USER.Gender,SHARED_USER.Marriage,SHARED_USER.Birthday,SHARED_USER.JoinedDate,SHARED_USER.PCoin,SHARED_USER.OuterScore,SHARED_USER.InnerScore,SHARED_USER.Energy,SHARED_USER.Hobby,SHARED_USER.Quote,SHARED_USER.Lati,SHARED_USER.Longi,SHARED_USER.Portrait!,SHARED_USER.ProfileUrl,SHARED_USER.MsgIndex,SHARED_USER.AVG,SHARED_USER.Expire]){
                print("插入失败")
            }
        }

    }
    
    func getUserInfo(userIndex:Int) -> Bool{
        var inDB = false
        dbq.inDatabase { (db) -> Void in
            let sql_select = "SELECT * FROM USERINFO WHERE USERINDEX = ?"
            if let rs = db.executeQuery(sql_select, withArgumentsInArray: [userIndex]){  //可选绑定
                
                while rs.next(){
                    SHARED_USER.UserIndex = userIndex
                    SHARED_USER.UserName = rs.stringForColumn("USERNAME")
                    SHARED_USER.PhoneType = rs.longForColumn("PHONETYPE")
                    SHARED_USER.Gender = rs.longForColumn("GENDER")
                    SHARED_USER.Birthday = NSTimeInterval(rs.longForColumn("BIRTHDAY"))
                    SHARED_USER.JoinedDate = NSTimeInterval(rs.longForColumn("JOINEDDATE"))
                    SHARED_USER.PCoin = rs.doubleForColumn("PCOIN")
                    SHARED_USER.OuterScore = rs.longForColumn("OUTERSCORE")
                    SHARED_USER.InnerScore = rs.longForColumn("INNERSCORE")
                    SHARED_USER.Energy = rs.longForColumn("ENERGY")
                    SHARED_USER.Hobby = rs.stringForColumn("HOBBY")
                    SHARED_USER.Quote = rs.stringForColumn("QUOTE")
                    SHARED_USER.Lati = rs.doubleForColumn("LATI")
                    SHARED_USER.Marriage = Int(rs.intForColumn("MARRIAGE"))
                    SHARED_USER.Longi = rs.doubleForColumn("LONGI")
                    SHARED_USER.ProfileUrl = rs.stringForColumn("PROFILEURL")
                    SHARED_USER.MsgIndex = Int(rs.intForColumn("MSGINDEX"))
                    SHARED_USER.Portrait = rs.dataForColumn("PORTRAIT")//读取到的是插入时候已经将图片转成的NSData
                    SHARED_USER.Expire = Int(rs.intForColumn("EXPIRE"))
                    SHARED_USER.AVG = Int(rs.intForColumn("AVG"))
                    inDB = true
                }
            }
        }
        return (inDB)
    }
    
    func deleteUserInfo(){
        let sql_delete = "DELETE FROM USERINFO WHERE USERINDEX = ?"
        dbq.inDatabase { (db) -> Void in
            db.executeUpdate(sql_delete, withArgumentsInArray: [SHARED_USER.UserIndex])
        }
    }
}
