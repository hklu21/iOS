//
//  userDefault.swift
//  GOMOKU
//
//  Created by huang guanming on 3/14/22.
//

import Foundation

/*Save setting in the user defualt with given setting name and value*/
func saveSetting(_ settingName:String,_ settingValue:Any){
    let userDefaults = UserDefaults.standard
    userDefaults.set(settingValue,forKey: "gomoku_setting_\(settingName)")
}

/* Load the setting according to name from user defualt*/
func loadSetting(_ settingName:String)->Any?{
    let userDefaults = UserDefaults.standard
    return userDefaults.object(forKey: "gomoku_setting_\(settingName)")
}

