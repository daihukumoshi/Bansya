//
//  Subject.swift
//  Bansya
//
//  Created by 三木　杏夏 on 2023/09/18.
//

import Foundation
import RealmSwift

class Subject: Object {
    //科目名
    @Persisted var title: String = ""
    //曜日
    @Persisted var day: String = ""
    //id
    @Persisted var id : String = NSUUID().uuidString
    //時限
    @Persisted var time: String = ""
    //色
    @Persisted var color: String = "green"
    //通知オンオフ
//    @Persisted var notice: Bool = false
    //通知時間(1970使う)
//    @Persisted var time: Float = 0
}
