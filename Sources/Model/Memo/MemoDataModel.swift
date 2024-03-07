//
//  MemoDataModel.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//


import Foundation

struct MemoData {
    var memo : String
    var date : String
    var fix : Int
    var fixColor : String
    var documentID : String
}

struct MemoDataModel {
    var unFixMemoDataArray : [MemoData] = []
    var fixMemodataArray : [MemoData] = []
    
    var fixColor = "" //유저가 클립을 사용했는지. 클립을 사용했다면 선택한 색이 들어옴.
}

extension MemoData: Hashable { }
