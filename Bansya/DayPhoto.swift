//
//  DayPhoto.swift
//  Bansya
//
//  Created by 三木　杏夏 on 2023/09/22.
//

import Foundation
import RealmSwift

class DayPhoto: Object {
    //実施日
    @Persisted var Lecture: Lecture?
    //写真のファイル名
    @Persisted var fileName: String = "default.png"
}
