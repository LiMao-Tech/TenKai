//
//  UserCacheTool.swift
//  fmdbTest
//
//  Created by gt on 15/12/14.
//  Copyright © 2015年 ycl. All rights reserved.
//

import UIKit


class UserCacheTool: NSObject {
     var db:FMDatabase!
 
     override init() {
        
        let filemng = NSFileManager.defaultManager()
        //获取library目录
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir1 = dirPath[0] as NSString
        //print(dirPath)
        let databasePath = docsDir1.stringByAppendingPathComponent("userInfo.db")
        
        /*建数据库不应该放在这个代码中，不需要判断是否存在userInfo的文件，因为必须存在*/
        
        
        //判断datapath路径下有没有feedlog.db文件
        if !filemng.fileExistsAtPath(databasePath){
             db = FMDatabase(path: databasePath)
            //打开数据库
            if  db.open() {
                /*建表语句*/
                let sql_stmt = "CREATE TABLE IF NOT EXISTS USERINFO (ID INTEGER PRIMARY KEY,USERINDEX INTEGER , USERNAME TEXT,PHONETYPE INTEGER,GENDER INTEGER,BIRTHDAY TEXT,JOINEDDATE TEXT,PCOIN REAL,OUTERSCORE INTEGER,INNERSCORE INTEGER,ENERGY INTEGER,HOBBY TEXT,QUOTE TEXT,LATI REAL,LONGI REAL，PORTRAIT BLOB)"
                //如果创表失败打印创表失败
                if !db.executeUpdate(sql_stmt, withArgumentsInArray: nil){
                    print("创表失败！")
                }
                db.close()
            }
        }else{
            db = FMDatabase(path: databasePath)
        }

    }
    
    func addUserInfo(dict:NSDictionary) {
        db.open()
        /*插入语句*/
        let sql_insert = "INSERT INTO USERINFO(USERINDEX,USERNAME,PHONETYPE,GENDER,BIRTHDAY,JOINEDDATE,PCOIN,OUTERSCORE ,INNERSCORE,ENERGY,HOBBY,QUOTE,LATI,LONGI,PORTRAIT) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        //插入自己设定的值
        if !db.executeUpdate(sql_insert, withArgumentsInArray: [dict["UserIndex"]!,dict["UserName"]!,dict["PhoneType"]!,dict["Gender"]!,dict["Birthday"]!,dict["JoinedDate"]!,dict["PCoin"]!,dict["OuterScore"]!,dict["InnerScore"]!,dict["Energy"]!,dict["Hobby"]!,dict["Quote"]!,dict["Lati"]!,dict["Longi"]!,dict["Portrait"]!]){                  print("插入失败")
        }
        db.close()
    }
    
    func getUserInfo(userIndex:Int) ->TenUser{
        let user = TenUser()
        let sql_select = "SELECT * FROM USERINFO WHERE USERINDEX = ?"
        if let rs = db.executeQuery(sql_select, withArgumentsInArray: [userIndex]){  //可选绑定
            
            while rs.next(){
                user.UserIndex = userIndex
                user.UserName = rs.stringForColumn("USERNAME")
                user.PhoneType = Int(rs.intForColumn("PHONETYPE"))
                user.Gender = Int(rs.intForColumn("GENDER"))
                user.Birthday = rs.stringForColumn("BIRTHDAY")
                user.JoinedDate = rs.stringForColumn("JOINEDDATE")
                user.PCoin = rs.doubleForColumn("PCOIN")
                user.OuterScore = Int(rs.intForColumn("OUTERSCORE"))
                user.InnerScore = Int(rs.intForColumn("INNERSCORE"))
                user.Energy = Int(rs.intForColumn("ENERGY"))
                user.Hobby = rs.stringForColumn("HOBBY")
                user.Quote = rs.stringForColumn("QUOTE")
                user.Lati = rs.doubleForColumn("LATI")
                user.Longi = rs.doubleForColumn("LONGI")
                user.Portrait = rs.dataForColumn("PORTRAIT")  //读取到的是插入时候已经将图片转成的NSData
            }
            
        }
        return user
    }
}
