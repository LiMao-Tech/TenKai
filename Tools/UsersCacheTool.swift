//
//  UsersCacheTool.swift
//  Ten
//
//  Created by gt on 16/1/4.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class UsersCacheTool: NSObject {
    var dbq:FMDatabaseQueue!
    
    override init() {
        
        let databasePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/userInfo.db")
        /*建数据库不应该放在这个代码中，不需要判断是否存在userInfo的文件，因为必须存在*/
        
        
        //判断datapath路径下有没有feedlog.db文件
        NSFileManager.defaultManager().fileExistsAtPath(databasePath)
        dbq = FMDatabaseQueue(path: databasePath)
        dbq.inDatabase { (db) -> Void in
            let sql_stmt = "CREATE TABLE IF NOT EXISTS USERSINFO (ID INTEGER PRIMARY KEY,USERINDEX INTEGER , USERNAME TEXT,PHONETYPE INTEGER,GENDER INTEGER,BIRTHDAY TEXT,JOINEDDATE TEXT,PCOIN REAL,OUTERSCORE INTEGER,INNERSCORE INTEGER,ENERGY INTEGER,HOBBY TEXT,QUOTE TEXT,LATI REAL,LONGI REAL,PORTRAIT BLOB,PROFILEURL TEXT)"
            //如果创表失败打印创表失败
            if !db.executeUpdate(sql_stmt, withArgumentsInArray: nil){
                print("创表失败！")
            }
            
        }
    }
    
    func updateUserInfo(dict:NSDictionary) {
        dbq.inDatabase { (db) -> Void in
            let sql_insert = "UPDATE INTO USERSINFO(USERINDEX,USERNAME,PHONETYPE,GENDER,BIRTHDAY,JOINEDDATE,PCOIN,OUTERSCORE,INNERSCORE,ENERGY,HOBBY,QUOTE,LATI,LONGI,PROFILEURL) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
            
            if !db.executeUpdate(sql_insert, withArgumentsInArray: [dict["UserIndex"]!,dict["UserName"]!,dict["PhoneType"]!,dict["Gender"]!,dict["Birthday"]!,dict["JoinedDate"]!,dict["PCoin"]!,dict["OuterScore"]!,dict["InnerScore"]!,dict["Energy"]!,dict["Hobby"]!,dict["Quote"]!,dict["Lati"]!,dict["Longi"]!,dict["ProfileUrl"]!]){                  print("修改失败")
            }
        }
    }
    
    func upDateUserPortrait(portrait:UIImage){
        let date = UIImagePNGRepresentation(portrait)
        let sql_update = "UPDATE USERINFO SET PORTRATI = ? WHERE USERINDEX = ?"
        dbq.inDatabase { (db) -> Void in
            db.executeUpdate(sql_update, withArgumentsInArray: [date!, SHARED_USER.UserIndex])
        }
    }
    
    func addUserInfoByUser(user:SharedUser){
        dbq.inDatabase { (db) -> Void in
            let sql_insert = "INSERT INTO USERINFO(USERINDEX,USERNAME,PHONETYPE,GENDER,BIRTHDAY,JOINEDDATE,PCOIN,OUTERSCORE,INNERSCORE,ENERGY,HOBBY,QUOTE,LATI,LONGI,PORTRAIT,PROFILEURL) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
            if !db.executeUpdate(sql_insert, withArgumentsInArray: [user.UserIndex,user.UserName,user.PhoneType,user.Gender,user.Birthday,user.JoinedDate,user.PCoin,user.OuterScore,user.InnerScore,user.Energy,user.Hobby,user.Quote,user.Lati,user.Longi,user.Portrait,user.ProfileUrl]){
                print("插入失败")
            }
        }
        
    }
    
    func getUserInfo(userIndex:Int) ->(user:SharedUser,inDB:Bool){
        var inDB = false
        dbq.inDatabase { (db) -> Void in
            let sql_select = "SELECT * FROM USERINFO WHERE USERINDEX = ?"
            if let rs = db.executeQuery(sql_select, withArgumentsInArray: [userIndex]){  //可选绑定
                
                while rs.next(){
                    SHARED_USER.UserIndex = userIndex
                    SHARED_USER.UserName = rs.stringForColumn("USERNAME")
                    SHARED_USER.PhoneType = Int(rs.intForColumn("PHONETYPE"))
                    SHARED_USER.Gender = Int(rs.intForColumn("GENDER"))
                    SHARED_USER.Birthday = rs.stringForColumn("BIRTHDAY")
                    SHARED_USER.JoinedDate = rs.stringForColumn("JOINEDDATE")
                    SHARED_USER.PCoin = rs.doubleForColumn("PCOIN")
                    SHARED_USER.OuterScore = Int(rs.intForColumn("OUTERSCORE"))
                    SHARED_USER.InnerScore = Int(rs.intForColumn("INNERSCORE"))
                    SHARED_USER.Energy = Int(rs.intForColumn("ENERGY"))
                    SHARED_USER.Hobby = rs.stringForColumn("HOBBY")
                    SHARED_USER.Quote = rs.stringForColumn("QUOTE")
                    SHARED_USER.Lati = rs.doubleForColumn("LATI")
                    SHARED_USER.Longi = rs.doubleForColumn("LONGI")
                    SHARED_USER.ProfileUrl = rs.stringForColumn("PROFILEURL")
                    SHARED_USER.MsgIndex = Int(rs.intForColumn("MSGINDEX"))
                    inDB = true
                    //                    user.Portrait = rs.dataForColumn("PORTRAIT")  //读取到的是插入时候已经将图片转成的NSData
                }
            }
        }
        return (SHARED_USER, inDB)
    }
    
    func deleteUserInfo(){
        let sql_delete = "DELETE FROM USERINFO WHERE USERINDEX = ?"
        dbq.inDatabase { (db) -> Void in
            db.executeUpdate(sql_delete, withArgumentsInArray: [SHARED_USER.UserIndex])
        }
    }

}
