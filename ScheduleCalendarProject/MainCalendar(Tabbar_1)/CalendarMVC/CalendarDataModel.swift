//
//  CalendarDateModel.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct CalendarDataModel {
    //MARK: - 캘린더를 만드는데 필요한 데이터들.
    let calendar = Calendar.current
    var calendarDate = Date()
    var days : [String] = []     //달력에 날짜 표시하기 위해서 날짜들 저장 ex) 첫 째날이 월요일이라면 ["", "1", "2" ...]
    var todayIndex = Int()
    
    var specificDateArray : [String] = [] //구체적인 날짜들을 가지고 있는 배열 ex) "2023년 04월 29일"
    var currentTitle = String() //현재 달력에 나와있는 년도와 월에 대한 정보. 구체적인 날짜를 구성하는데 사용할 것임. ex) "2023년 04월"
    
    //MARK: - 주말과 공휴일을 표시하기 위한 데이터
    let sundayIndexSet : Set<Int> = [0, 7, 14, 21, 28, 35, 41]
    let saturdayIndexSet : Set<Int> = [6, 13, 20, 27, 34]
    var holidayIndexSet : Set<Int> = [] //공휴일 데이터 인덱스들.
    
    //MARK: - Firestore에서 가져오는 데이터를 담을 데이터.
    var customCalendarDataArray : [[CustomCalendarData]] = []
    
    //MARK: - 캘린더를 만드는데 필요한 메서드.
    //해당 날짜에서 년, 월을 뽑아서 Date 형식으로 저장, 저장한 Date를 가지고 day를 계산함.
    mutating func configureCalendar() {
        let components = calendar.dateComponents([.year, .month], from: Date()) //현재 날짜에서 년, 월만 뽑기
        calendarDate = calendar.date(from: components) ?? Date() //뽑아낸 정보는 dateComponents 타입이기 때문에 date 형태로 변환.
        
        //꼭 updateTitle() 메서드 이후에 updateDays를 해주어야함.
        //이유는 타이틀이 먼저 변경되어야 specificDatesArray에 데이터를 넣어줄 때, 현재 년 월을 기준으로함.
        updateTitle()
        updateDays()
        initializeCalendarDataArrayWithDefaults()
    }
    
    //해당 날짜가 속한 달의 첫 번째 날이 무슨 요일인지 알아내기 위한 메서드.
    func startDayOfTheWeek() -> Int {
        return calendar.component(.weekday, from: calendarDate) - 1
    }
    
    //해당 날짜가 속한 month가 총 몇 day인지 알기 위한 메서드
    func endDate() -> Int {
        return calendar.range(of: .day, in: .month, for: calendarDate)?.count ?? Int()
    }
    
    //Calendar Cell에 day 데이터를 넣어주기 위한 메서드.
    mutating func updateDays() {
        days.removeAll()  //다음달이나 이전달로 스크롤 할 때 days를 다시 새로 계산하니까 모두 삭제
        specificDateArray.removeAll()
        
        let startDayOfTheWeek = self.startDayOfTheWeek() //첫 번째 날 시작 인덱스를 저장하기 위해
        let totalDays = startDayOfTheWeek + self.endDate() //시작 인덱스와 총 날짜 개수를 더해서 저장
        
        for day in 0..<totalDays {
            
            if day < startDayOfTheWeek { //시작 인덱스까지 가지 못하면 빈칸으로 채우기.
                days.append("")
                specificDateArray.append("")
                continue
            }
            
            //1일이 무슨 요일부터 시작되는지 인덱스(ex 일요일이면 0)와 해당 달이 총 몇일인지 합친 값이 totalDays
            //for문 내에서 현재 돌아가는 인덱스가 day
            //따라서 현재 인덱스 - 요일 인덱스 +1 해주면 1일씩 차례대로 배열에 들어감.
            let resultDay = day - startDayOfTheWeek + 1
            var strResult = "\(resultDay)"
            
            self.days.append(strResult)
            
            if strResult.count == 1 { //만약 1자리 수라면 0을 붙여줌. ex) "01, 02, 03"
                strResult = "0\(strResult)"
            }
            
            let specificDate = "\(currentTitle) \(strResult)일"
            specificDateArray.append(specificDate)
        }
    }
    
    //현재 날짜 데이터를 View의 Title에 넣어주기 위한 메서드.
    mutating func updateTitle(){
        currentTitle = calendarDate.convertDateToString(format: "yyyy년 MM월")
    }
    
    //유저가 다음달로 달력을 넘겼을 때, 달력의 데이터를 변환시켜주는 메서드.
    mutating func plusMonth() {
        calendarDate = calendar.date(byAdding: DateComponents(month: +1), to: calendarDate) ?? Date()
        
        updateTitle()
        updateDays()
        initializeCalendarDataArrayWithDefaults()
    }
    
    //유저가 이전달로 달력을 넘겼을 때, 달력의 데이터를 변환시켜주는 메서드.
    mutating func minusMonth() {
        calendarDate = calendar.date(byAdding: DateComponents(month: -1), to: calendarDate) ?? Date()
        
        updateTitle()
        updateDays()
        initializeCalendarDataArrayWithDefaults()
    }
    
    mutating func moveToSelectedDate(date: Date) {
        calendarDate = date
        
        updateTitle()
        updateDays()
        initializeCalendarDataArrayWithDefaults()
    }
    
    //goToday 버튼을 활성화시키기 위해 유저에게 보여지고 있는 날짜와 현재 날짜가 일치하는지 확인하는 메서드.
    func checkDate() -> Bool {
        let components = calendar.dateComponents([.year, .month], from: Date())
        let date = calendar.date(from: components)
        
        if date == calendarDate{
            return true
        }else {
            return false
        }
    }
    
    //오늘 날짜를 표시해주기 위해 오늘 날짜와 days 배열의 날짜를 비교해서 일치하는 index를 todayIndex에 저장하는 메서드.
    mutating func indexOfToday() {
        let today = Date().convertDateToString(format: "d")
        
        if let index = days.firstIndex(of: today) {
            todayIndex = index
        }
    }
    
    
    //MARK: - Firestore에서 가져온 데이터들을 캘린더에 뿌려주기 위한 작업들.
    
    //캘린더에 들어가있는 날짜 데이터의 크기에 맞게 2차원 배열을 미리 준비해둔다.
    mutating func initializeCalendarDataArrayWithDefaults() {
        let defaultData = CustomCalendarData(titleText: "",
                                             startDate: "", endDate: "",
                                             detailMemo: "",
                                             count: 0, controlIndex: 0,
                                             selectedColor: "#00000000", labelColor: "#00000000",
                                             backGrondColor: "#00000000",
                                             notification: "",
                                             documentID: "",
                                             sequence: "")
        
        let defaultDataArray = [defaultData]
    
        customCalendarDataArray = Array(repeating: defaultDataArray, count: specificDateArray.count)
    }
    
    //데이터들을 받아오기 전 초기화작업.
    mutating func initArrayForFetchData() {
        initializeCalendarDataArrayWithDefaults()
        holidayIndexSet = []
    }
    
    //해당 데이터가 하루종일 모드인지, 시간설정 모드인지에 따라 구분하고 specificDatesArray에 일치하는 index를 찾아주기.
    func getIndexForFormattedDate(_ dateString: String, controlIndex: Int) -> Int {
        var result = dateString
        
        if controlIndex == 1 {
            let formattedDate = dateString.convertStringToDate(format: "yyyy년 MM월 dd일 HH시 mm분")
            result = formattedDate.convertDateToString(format: "yyyy년 MM월 dd일")
        }
        
        guard let index = specificDateArray.firstIndex(of: result) else{return 0}
        
        return index
    }
    
    //당일스케줄일 때 캘린더데이터에 배치작업.
    //일치하는 인덱스 배열에 titleText == "" 인 요소가 있는지 체크. (비어있는 이벤트)
    //비어있는 이벤트가 없으면 맨 마지막으로 추가됨.
    //비어있는 이벤트가 있다면 가져온 이벤트로 변경해줌.
    mutating func deploySingleEventToCalendarData(at index: Int, data: CustomCalendarData) {
        guard let emptyIndex = customCalendarDataArray[index].firstIndex(where: {$0.titleText == ""}) else{
            customCalendarDataArray[index].append(data)
            return
        }
        
        customCalendarDataArray[index][emptyIndex] = data
    }
    
    mutating func deployMultipleEventToCalendarData(at index: Int, data: CustomCalendarData) {
        let totalMultipleEventArray = [Int](repeating: 0, count: data.count + 1) //장기 스케줄이 총 몇일인지.
        let emptyEventData = emptyCalendarData() //나머지 스케줄을 첫 번째 인덱스에 맞추기 위해서 빈 이벤트 요소가 필요함.
        
        var firstDayEventIndex = 0 //첫 번째 스케줄이 몇 번 인덱스에 들어갔는지 저장. 나머지 스케줄도 해당 인덱스에 넣어줘야 함.
        var resultData = data      //최종적으로 배열에 들어갈 데이터.
        var checkIndex = index
        
        for (index, _) in totalMultipleEventArray.enumerated() {
            
            if index == 0 {
                resultData.sequence = "first" //장기 스케줄의 첫 번째 날. boreder를 위함.
                firstDayEventIndex = findEmptyOrLastUpdateEvent(data: resultData, at: checkIndex)
                
            }else{
                resultData.sequence = updateSequence(for: index, total: totalMultipleEventArray.count) //장기 스케줄의 마지막 날
                insertDataToCalendar(at: checkIndex, data: resultData, emptyData: emptyEventData, insertIndex: firstDayEventIndex)
                
            }
            
            checkIndex += 1 //다음 날의 인덱스로 넘겨줌.
        }
    }
    
    //비어있는 이벤트 만들어주기.
    private func emptyCalendarData() -> CustomCalendarData {
        return CustomCalendarData(titleText: "", startDate: "", endDate: "", detailMemo: "", count: 0, controlIndex: 0, selectedColor: "#00000000", labelColor: "#00000000", backGrondColor: "#00000000", notification: "", documentID: "", sequence: "")
    }
    
    //해당 일자의 유저 스케줄 중에 비어있는 이벤트가 존재한다면 가져온 이벤트로 변경해줌.
    //비어있는 이벤트가 존재하지 않는다면 새롭게 추가.
    private mutating func findEmptyOrLastUpdateEvent(data: CustomCalendarData, at index: Int) -> Int {
        let calendarDataArray = self.customCalendarDataArray[index] //해당 일자의 유저 스케줄들.
        
        if let emptyEventIndex = calendarDataArray.firstIndex(where: { $0.titleText == "" }) {
            self.customCalendarDataArray[index][emptyEventIndex] = data
            
            return emptyEventIndex
            
        }else{
            self.customCalendarDataArray[index].append(data)
            return self.customCalendarDataArray[index].count - 1 //해당 데이터가 들어간 인덱스.
        }
    }
    
    //마지막 순서의 data는 sequence에 "last"를 붙여줌. 보더를 위해
    private func updateSequence(for index: Int, total: Int) -> String {
        let check = (index == total - 1) //마지막 데이터인지 체크.
        return check ? "last" : ""
    }
    
    //1. checkIndex = customCalendarDataArray 내에서 현재 데이터를 어느 위치에 넣을 것인지 지정하는 인덱스
    //2. data = 저장할 데이터
    //3. emptyData = 데이터를 저장할 위치에 넣어주기 위해 빈 데이터를 추가. ex) 3인덱스라면 1, 2 인덱스에 빈 데이터를 넣고 3에 데이터를 넣어줌.
    //4. firstDayEventIndex = customCalendarDataArray[checkIndex] 내에서 데이터를 넣을 위치 인덱스
    private mutating func insertDataToCalendar(at checkIndex: Int, data: CustomCalendarData, emptyData: CustomCalendarData, insertIndex firstDayEventIndex: Int) {
        let currentDataArray = customCalendarDataArray[checkIndex] //현재 checkIndex 일자의 유저 이벤트들을 가져옴.
        
        //현재 이벤트들의 크기와 데이터를 넣어주어야 하는 인덱스의 크기를 비교.
        //이벤트들의 크기가 더 크다면 인덱스에 맞게 데이터를 넣어줌.
        //크기가 더 작다면 그 차이만큼 빈 데이터를 넣고 마지막에 데이터를 넣어줌.
        if currentDataArray.count > firstDayEventIndex {
            customCalendarDataArray[checkIndex][firstDayEventIndex] = data
            
        }else{
            for _ in currentDataArray.count..<firstDayEventIndex {
                customCalendarDataArray[checkIndex].append(emptyData)
            }
            
            customCalendarDataArray[checkIndex].append(data)
        }
    }
}



/*
 switch firstDayEventIndex {
     
 case 0:
     customCalendarDataArray[checkIndex][0] = resultData
     
 case 1:
     //인덱스 2에 데이터가 있다면 1번으로 넣어주고, 없으면 append.
     //인덱스 2번의 체크이유는 장기 스케줄을 1자로 넣어주는데 다 append를 하면 들쑥날쑥한 데이터가 될 수 있음.
     if customCalendarDataArray[checkIndex].indices.contains(2) {
         customCalendarDataArray[checkIndex][1] = resultData
         
     }else{
         customCalendarDataArray[checkIndex].append(resultData)
     }
     
 case 2:
     
     //인덱스 1에 데이터가 있다면 그대로 채워주면댐.
     //데이터가 없으면 우리의 첫 번째 스케줄은 이미 2번 인덱스에 들어갔죠? 똑같이 2번에 넣어주려면 빈 이벤트를 하나 넣어주고 들어감.
     if customCalendarDataArray[checkIndex].indices.contains(1) {
         customCalendarDataArray[checkIndex].append(resultData)
         
     }else{
         customCalendarDataArray[checkIndex].append(emptyEventData)
         customCalendarDataArray[checkIndex].append(resultData)
     }
     
     
 case 3:
     
     //인덱스 2에 데이터가 있으면 그대로 채워주면 댐.
     //2에 데이터가 없으면 1번으로 가서 또 체크해주고 빈 배열 넣어주고 데이터 넣어줌.
     //1에 데이터가 없으면 0번임.
     if customCalendarDataArray[checkIndex].indices.contains(2) {
         customCalendarDataArray[checkIndex].append(resultData)
         
     }else{
         
         if customCalendarDataArray[checkIndex].indices.contains(1) {
             customCalendarDataArray[checkIndex].append(emptyEventData)
             customCalendarDataArray[checkIndex].append(resultData)
             
         }else{
             customCalendarDataArray[checkIndex].append(emptyEventData)
             customCalendarDataArray[checkIndex].append(emptyEventData)
             customCalendarDataArray[checkIndex].append(resultData)
         }
     }
     
     
 default:
     print("")
     
 }
 */
