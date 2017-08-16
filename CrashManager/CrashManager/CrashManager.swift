//
//  CrashManager.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/8/15.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import Foundation


enum CrashPathEnum:String {
    case signalCrashPath = "signaCrash"
    case nsExceptionCrashPath = "nsExceptionCrash"
}


//MARK: - Crash处理总入口,请留意不要集成多个crash捕获，NSSetUncaughtExceptionHandler可能会被覆盖.NSException的crash也会同时生成一个signal异常信息
func crashHandle(crashContentAction:@escaping ([String])->Void){
    DispatchQueue.global().async {
        if CrashManager.readAllCrashInfo().count > 0 {
            //如果崩溃信息不为空，则对崩溃信息进行下一步处理
            crashContentAction(CrashManager.readAllCrashInfo())
        }
        CrashManager.deleteAllCrashFile()
    }
    //注册signal,捕获相关crash
    registerSignalHandler()
    //注册NSException,捕获相关crash
    registerUncaughtExceptionHandler()
}



class CrashManager: NSObject {

//MARK: - 保存崩溃信息
class func  saveCrash(appendPathStr:CrashPathEnum,exceptionInfo:String)
{
    let filePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/\(appendPathStr.rawValue)")
    
    if let crashPath = filePath{
        
        if !FileManager.default.fileExists(atPath: crashPath) {
            
            try? FileManager.default.createDirectory(atPath: crashPath, withIntermediateDirectories: true, attributes: nil)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd-HHmmss"
        let dateString =   dateFormatter.string(from: Date())
        
        
        let crashFilePath = crashPath.appending("/\(dateString).log")
        //cmDebugPrint(crashFilePath)
        
        try? exceptionInfo.write(toFile: crashFilePath, atomically: true, encoding: .utf8)
    }
    
    
}



//MARK: - 获取所有的log列表
class func CrashFileList(crashPathStr:CrashPathEnum) -> [String] {
    let pathcaches = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
    let cachesDirectory = pathcaches[0]
    let crashPath = cachesDirectory.appending("/\(crashPathStr.rawValue)")
    
    let fileManager = FileManager.default
    
    var logFiles: [String] = []
    let fileList = try? fileManager.contentsOfDirectory(atPath: crashPath)
    if let list = fileList {
        for fileName in list {
            if let _ = fileName.range(of: ".log") {
                logFiles.append(crashPath+"/"+fileName)
            }
        }
    }
    
    return logFiles
}




//MARK: - 读取所有的崩溃信息
    class func readAllCrashInfo() -> [String] {
        var crashInfoArr:[String] = Array()
        
        //删除signal崩溃文件
        for signalPathStr in CrashFileList(crashPathStr: .signalCrashPath){
            if let content = try? String(contentsOfFile: signalPathStr, encoding: .utf8) {
                crashInfoArr.append(content)
                //cmDebugPrint(content)
            }
        }
        //删除NSexception崩溃文件
        for exceptionPathStr in CrashFileList(crashPathStr: .nsExceptionCrashPath){
            if let content = try? String(contentsOfFile: exceptionPathStr, encoding: .utf8){
                crashInfoArr.append(content)
            }
        }
        
        return crashInfoArr
    }
    
    

  
//MARK: - 删除所有崩溃信息文件信息
    class func deleteAllCrashFile(){
        //删除signal崩溃文件
        for signalPathStr in CrashFileList(crashPathStr: .signalCrashPath){
            try? FileManager.default.removeItem(atPath: signalPathStr)
            //cmDebugPrint(signalPathStr)
        }
        //删除NSexception崩溃文件
        for exceptionPathStr in CrashFileList(crashPathStr: .nsExceptionCrashPath){
            try? FileManager.default.removeItem(atPath: exceptionPathStr)
        }
        
    }
    

//MARK: - 删除单个崩溃信息文件
    class func DeleteCrash(crashPathStr:CrashPathEnum, fileName: String) {
        let pathcaches = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cachesDirectory = pathcaches[0]
        let crashPath = cachesDirectory.appending("/\(crashPathStr)")
        
        let filePath = crashPath.appending("/\(fileName)")
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: filePath)
    }
    
//MARK: - 读取单个文件崩溃信息
    class func ReadCrash(crashPathStr:CrashPathEnum, fileName: String) -> String? {
        let pathcaches = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cachesDirectory = pathcaches[0]
        let crashPath = cachesDirectory.appending("/\(crashPathStr)")
        
        let filePath = crashPath.appending("/\(fileName)")
        let content = try? String(contentsOfFile: filePath, encoding: .utf8)
        return content
    }
    
}
