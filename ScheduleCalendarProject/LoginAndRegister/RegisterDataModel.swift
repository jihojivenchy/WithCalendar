//
//  RegisterDataModel.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import Foundation


struct RegisterUserData {
    var userName: String
    var userCode: String
    var userEmail: String
    var userPW: String
}

struct RegisterDataModel {
    var checkSign : Bool = false //닉네임 입력과 약관 동의하는 프로세스에서 사용하는 프로퍼티. 약관 체크박스에 체크를 했는지 확인.
    
    var userName : String = ""
    var userEmail : String = "" //로그인과 회원가입에 사용되는 이메일
    var userPW : String = "" //로그인과 회원가입에 사용되는 비밀번호
    
    let code = "abcdefghijklmnopqrstuvwxyz0123456789" //유저의 고유 랜덤코드를 뽑기 위한 소스.
}

