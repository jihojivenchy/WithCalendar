//
//  LunarAPI.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/20.
//

import Foundation

//NSObject는 옵젝씨의 기본 클래스로 Swift에서 NSObject를 상속받는 이유는 크게 두 가지다.
//1. 옵젝씨 코드와 상호작용하는 데 필요한 많은 메서드와 속성들이 NSObject에 정의되어 있다. 따라서 Swift에서 옵젝씨와 상호작용 할 필요가 있는 경우 상속받음.
//2. XMLParserDelegate와 같은 프로토콜은 NSObjectProtocol을 확장하고 있기 때문에 NSObjectProtocol에 요구사항을 모두 준수하고 있어야 한다.
//근데 NSObjectProtocol의 요구사항들을 모두 NSObject가 구현하고 있기 때문에 NSObject를 상속받으면 NSObjectProtocol을 준수할 수 있음.
class LunarAPI: NSObject, XMLParserDelegate {
    
    var currentElement = String()      //현재 읽고 있는 엘리먼트의 이름
    var lunarDate : LunarDate?         //파싱한 데이터를 저장할 LunarDate 객체
    var currentLunarDate = LunarDate() //현재 만들고 있는 LunarDate 객체
    
    func fetchLunarData(year: String, month: String, day: String, completion: @escaping (Result<LunarDate, FetchLunarDataError>) -> Void) {
        guard let url = URL(string: "https://apis.data.go.kr/B090041/openapi/service/LrsrCldInfoService/getLunCalInfo?solYear=\(year)&solMonth=\(month)&solDay=\(day)&ServiceKey=\(APIKeys.lunarAPIKey)") else{
            
            completion(.failure(.failedURLRequest("URL에 문제가 발생했습니다.")))
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, _, error in
            if let e = error {
                completion(.failure(.failedURLRequest(e.localizedDescription)))
                
            }else{
                guard let safeData = data else{
                    completion(.failure(.invalidateDataError))
                    return
                }
                
                
                self.parse(with: safeData)
                
                if let lunarDate = self.lunarDate {
                    completion(.success(lunarDate))
                }else{
                    completion(.failure(.invalidateDataError))
                }
            }
        }
        
        task.resume()
    }
    
    func parse(with data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    //MARK: - XMLParserDelegate
    
    //XML 시작될 때 호출되는 작업. "item" 이라는 태그를 만나면 새로운 LunarDate 객체를 생성하고, 관련된 데이터를 처리할 준비를 함.
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName //현재 처리중인 태그 네임을 저장.
        
        if elementName == "item" {
            currentLunarDate = LunarDate()
        }
    }
    
    //태그 안에 있는 문자 데이터를 만났을 때 호출되는 작업. foundCharacters에 문자 데이터가 들어가고,
    //다음 XML 데이터는 줄바꿈이나 공백이 존재할 수 있기 때문에 제거하는 작업을 해준다.
    //가공한 데이터가 내가 원하는 데이터라면 저장해줌.
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) //공백, 줄바꿈 제거.
        
        //비어있는 데이터는 무시.
        if data.isEmpty != true {
            switch currentElement {
                
            case "lunYear":
                currentLunarDate.lunYear = data
                
            case "lunMonth":
                currentLunarDate.lunMonth = data
                
            case "lunDay":
                currentLunarDate.lunDay = data
                
            default:
                break
            }
        }
    }
    
    //마지막 "item" 으로 닫혀있는 태그를 만나면 가공을 완료한 데이터를 저장해줌.
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            lunarDate = currentLunarDate
        }
    }
}

enum FetchLunarDataError : Error {
    case failedURLRequest(String)              //URLSession을 통해 리퀘스트한 작업 도중 생긴 에러
    case invalidateDataError                   //요청한 데이터가 없음.
}
