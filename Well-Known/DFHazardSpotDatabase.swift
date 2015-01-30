//
//  DFHazardSpotDatabase.swift
//  Well-Known
//
//  Created by hw14d002 on 2015/01/22.
//  Copyright (c) 2015年 DualFang. All rights reserved.
//

class DFHazardSpotDatabase {
    init() {
        createTables()
    }
    
    private func createTables() {
        // HazardSpot table
        let createHazardSpotSQL = "CREATE TABLE IF NOT EXISTS HazardSpots (id INTEGER PRIMARY KEY AUTOINCREMENT, longitude REAL, latitude REAL, width REAL, height REAL, angle REAL, tag INTEGER);"
        let db = getDB()
        db.open()
        let ret = db.executeUpdate(createHazardSpotSQL, withArgumentsInArray: nil)
        db.close()
        
        if ret {
            println("SQL 成功")
        }
    }
    
    func getHazardSpot() {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
//        NSString *dir = [paths objectAtIndex:0];
//        FMDatabase *db = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"test.db"]];
    }
    
    private func getDB() -> FMDatabase {
        var documentPath: AnyObject =
        NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory,
            .UserDomainMask,
            true)[0]
        
        let path:String = (documentPath as NSString).stringByAppendingPathComponent("Well-Known.db")
        
        println("path:" + path)
        
        let db = FMDatabase(path: path)
 
        return db
    }
    

}
