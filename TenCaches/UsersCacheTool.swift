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
            let sql_stmt = "CREATE TABLE IF NOT EXISTS USERSINFO_\(SHARED_USER.UserIndex) (ID INTEGER PRIMARY KEY,USERINDEX INTEGER , USERNAME TEXT,PHONETYPE INTEGER,GENDER INTEGER,BIRTHDAY TEXT,JOINEDDATE TEXT,PCOIN REAL,OUTERSCORE INTEGER,INNERSCORE INTEGER,ENERGY INTEGER,HOBBY TEXT,QUOTE TEXT,LATI REAL,LONGI REAL,PORTRAIT BLOB,PROFILEURL TEXT,LISTTYPE INTEGER,BADGENUM INTERGER)"
            //如果创表失败打印创表失败
            if !db.executeUpdate(sql_stmt, withArgumentsInArray: nil){
                print("创表失败！")
            }
            
        }
    }
    
    func updateUserInfo(user:TenUser) {
        dbq.inDatabase { (db) -> Void in
            let sql_insert = "UPDATE USERSINFO_\(SHARED_USER.UserIndex) SET PHONETYPE = ?,GENDER = ?,PCOIN = ?,OUTERSCORE = ?,INNERSCORE = ?,ENERGY = ?,HOBBY = ?,QUOTE = ?,LATI = ?,LONGI = ?,PROFILEURL = ?,PORTRAIT = ?,LISTTYPE = ?,BADGENUM = ? WHERE USERINDEX = ?"
            
            if !db.executeUpdate(sql_insert, withArgumentsInArray: [user.PhoneType,user.Gender,user.PCoin,user.OuterScore,user.InnerScore,user.Energy,user.Hobby,user.Quote,user.Lati,user.Longi,user.ProfileUrl,user.Portrait!,user.listType.rawValue,user.badgeNum,user.UserIndex]){
                print("修改失败")
            }
        }
    }
    
    func upDateUsersPortrait(userIndex:Int,portrait:UIImage){
        let date = UIImagePNGRepresentation(portrait)
        let sql_update = "UPDATE USERSINFO_\(SHARED_USER.UserIndex) SET PORTRAIT = ? WHERE USERINDEX = ?"
        dbq.inDatabase { (db) -> Void in
            db.executeUpdate(sql_update, withArgumentsInArray: [date!, userIndex])
        }
    }
    func updateUsersListType(userIndex:Int,listType:chatType){
        let sql_update = "UPDATE USERSINFO_\(SHARED_USER.UserIndex) SET LISTTYPE = ? WHERE USERINDEX = ?"
        dbq.inDatabase { (db) -> Void in
            db.executeUpdate(sql_update, withArgumentsInArray: [listType.rawValue, userIndex])
        }
    }
    func updateUsersBadgeNum(userIndex:Int,badgeNum:Int){
        let sql_update = "UPDATE USERSINFO_\(SHARED_USER.UserIndex) SET BADGENUM = ? WHERE USERINDEX = ?"
        dbq.inDatabase { (db) -> Void in
            db.executeUpdate(sql_update, withArgumentsInArray: [badgeNum, userIndex])
        }
    }
    
    
    func addUserInfoByUser(user:TenUser){
        dbq.inDatabase { (db) -> Void in
            let sql_insert = "INSERT INTO USERSINFO_\(SHARED_USER.UserIndex)(USERINDEX,USERNAME,PHONETYPE,GENDER,BIRTHDAY,JOINEDDATE,PCOIN,OUTERSCORE,INNERSCORE,ENERGY,HOBBY,QUOTE,LATI,LONGI,PORTRAIT,PROFILEURL,LISTTYPE,BADGENUM) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
            if !db.executeUpdate(sql_insert, withArgumentsInArray: [user.UserIndex,user.UserName,user.PhoneType,user.Gender,user.Birthday,user.JoinedDate,user.PCoin,user.OuterScore,user.InnerScore,user.Energy,user.Hobby,user.Quote,user.Lati,user.Longi,user.Portrait!,user.ProfileUrl,user.listType.rawValue,user.badgeNum]){
                print("插入失败")
            }
        }
    }
    
    func getUserInfo() ->(users:[TenUser],isEmpty:Bool){
        var isEmpty = true
        var users = [TenUser]()
        dbq.inDatabase { (db) -> Void in
            let sql_select = "SELECT * FROM USERSINFO_\(SHARED_USER.UserIndex)"
            if let rs = db.executeQuery(sql_select, withArgumentsInArray:nil){  //可选绑定
                
                while rs.next(){
                    let user = TenUser()
                    user.UserIndex = Int(rs.intForColumn("USERINDEX"))
                    user.UserName = rs.stringForColumn("USERNAME")
                    user.PhoneType = Int(rs.intForColumn("PHONETYPE"))
                    user.Gender = Int(rs.intForColumn("GENDER"))
                    user.Birthday = rs.doubleForColumn("BIRTHDAY")
                    user.JoinedDate = rs.doubleForColumn("JOINEDDATE")
                    user.PCoin = rs.doubleForColumn("PCOIN")
                    user.OuterScore = Int(rs.intForColumn("OUTERSCORE"))
                    user.InnerScore = Int(rs.intForColumn("INNERSCORE"))
                    user.Energy = Int(rs.intForColumn("ENERGY"))
                    user.Hobby = rs.stringForColumn("HOBBY")
                    user.Quote = rs.stringForColumn("QUOTE")
                    user.Lati = rs.doubleForColumn("LATI")
                    user.Longi = rs.doubleForColumn("LONGI")
                    user.ProfileUrl = rs.stringForColumn("PROFILEURL")
                    user.Portrait = rs.dataForColumn("PORTRAIT") //读取到的是插入时候已经将图片转成的NSData
                    user.listType = chatType(rawValue: Int(rs.intForColumn("LISTTYPE")))!
                    user.badgeNum = Int(rs.intForColumn("BADGENUM"))
                    isEmpty = false
                    users.append(user)
                }
            }
        }
        return (users, isEmpty)
    }
    
    func deleteUserInfo(userIndex:Int){
        let sql_delete = "DELETE FROM USERINFO WHERE USERINDEX = ?"
        dbq.inDatabase { (db) -> Void in
            db.executeUpdate(sql_delete, withArgumentsInArray: [userIndex])
        }
    }

}
