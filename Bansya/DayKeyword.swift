//
//  DayKeyword.swift
//  Bansya
//
//  Created by 三木　杏夏 on 2023/09/24.
//

import Foundation
import RealmSwift

class DayKeyword: Object {
    //実施日
    @Persisted var Lecture: Lecture?
    //写真のファイル名
    @Persisted var keyword: String = ""
}
