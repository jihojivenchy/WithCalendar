//
//  MemoDataModel.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//


import Foundation

struct MemoData: Codable {
    var memo : String
    var date : String
    var fix : Int
    var fixColor : String
    var documentID : String
}

extension MemoData: Hashable { }
