//
//  Lecture.swift
//  Bansya
//
//  Created by 三木　杏夏 on 2023/09/19.
//

import Foundation
import RealmSwift

class Lecture: Object {
    //実施日
    @Persisted var day: String = ""
    //id
    @Persisted var id : String = NSUUID().uuidString
//    //写真のファイル名
//    @Persisted var fileName: String = "default.png"
    @Persisted var Subject: Subject?
}
