## 🙌 소개
- With Calendar는 사용자의 일정을 효율적으로 관리할 수 있도록 지원하는 스케줄 서비스입니다.
- 디자인부터 개발 그리고 심사까지 모두 혼자서 작업한 개인 프로젝트입니다.

</br>

## ✨ 주요 기능
|심플한 디자인의 달력|한눈에 보는 일정(음력 지원)|간편한 일정 편집|
|---|---|---|
|<img height ="500" src="https://github.com/jihojivenchy/WithCalendar/assets/99619107/28ddcc44-996a-4dde-af23-6c765b0c37c8">|<img height ="500" src="https://github.com/jihojivenchy/WithCalendar/assets/99619107/e5fa795c-ea6d-4f92-9070-ce0bf65276b2">|<img height ="500" src="https://github.com/jihojivenchy/WithCalendar/assets/99619107/339ff6e8-6a11-460a-a781-82fa1002d2d5">

|공유 달력|간단 메모|
|---|---|
|<img height ="500" src="https://github.com/jihojivenchy/WithCalendar/assets/99619107/18c056e9-b0c8-4503-af29-51d132a2c602">|<img height ="500" src="https://github.com/jihojivenchy/WithCalendar/assets/99619107/230b7999-3862-4cfa-8b26-c5cd27aea39f">

</br>

## 📱앱스토어
- [With Calendar](https://apps.apple.com/kr/app/with-calendar/id1661333206)

</br>

## 🛠️ 기술
### iOS
<a href="버튼을 눌렀을 때 이동할 링크" target="_blank"><img src="https://img.shields.io/badge/Swift-FF6C22?style=for-the-badge&logo=Swift&logoColor=FFFFFF"/></a>
<a href="버튼을 눌렀을 때 이동할 링크" target="_blank"><img src="https://img.shields.io/badge/UIkit-2396F3?style=for-the-badge&logo=UIkit&logoColor=FFFFFF"/></a>
<a href="버튼을 눌렀을 때 이동할 링크" target="_blank"><img src="https://img.shields.io/badge/Firebase-FFFBF5?style=for-the-badge&logo=firebase&logoColor=FF9843"/></a>

### UI/UX Tool
<a href="버튼을 눌렀을 때 이동할 링크" target="_blank"><img src="https://img.shields.io/badge/Snapkit-FF90BC?style=for-the-badge&logo=librarything&logoColor=FFFFFF"/></a>

### Design Pattern
<a href="버튼을 눌렀을 때 이동할 링크" target="_blank"><img src="https://img.shields.io/badge/MVC-7FC7D9?style=for-the-badge&logo=instructure&logoColor=FFFFFF"/></a>

</br>

## 배웠던 점
### 📌 URLSession 

#### 사용 이유
- 공공데이터 포털의 API를 이용하여 공휴일과 음력 데이터를 가져와 유저에게 보여주기 위해

#### 학습
- 연결 실패, 시간 초과, 서버 오류 등 네트워킹 시 나타날 수 있는 에러를 확인하고, 이에 대한 적절한 대응 방법에 대해 학습
- 병렬요청 처리, 작업의 우선순위 설정 등을 통해 네트워크 요청을 최적화하는 방법에 대해 학습
- [URLSession 정리](https://iosjiho.tistory.com/73)

</br>

### 📌 XML Parsing

#### 사용 이유
- XML로 저장되어 있는 데이터를 디코딩

#### 학습
- XML은 태그로 감싸진 데이터 구조로 되어있고, 특정 태그를 파악하고 원하는 데이터를 추출해야 함
이 과정에서 ‘XML Parser’ 및 ‘XMLParserDelegate’ 를 활용한 Parsing 작업을 학습

</br>

### 📌 MVC
#### 사용 이유
- ViewController에 모든 코드를 때려박던 나의 어리석음을 깨닫고 디자인 패턴을 적용

#### 성과
- 분리된 관심사: MVC로 책임을 분리함으로써 코드의 재사용성, 가독성, 유지보수 모두 향상

</br>

### 📝 어려웠던 점
- 달력 UI 위에 일정(당일 혹은 장기)을 블록형태로 보여주는 메인 기능
- 복잡한 UI에 맞게 데이터 구조를 구현하는 것이 난관
- 일렬 형태의 블록으로 보여주기 위해, 여러 상황을 고려하여 인덱싱 구현
- 결국 복잡하고 변수가 많은 문제도 해결!

</br>

###  🔧 보완
- 'UICollectionViewFlowLayout'은 단순한 형태의 레이아웃은 쉽게 구현할 수 있도록 도와주지만, 복잡하고 다양한 레이아웃을 구현하는 데 있어서는 한계가 있음.
이 한계점을 보완하기 위해 나온 UICollectionViewCompositionalLayout에 대해서 학습하고 적용해보자.
- DataSource를 관리하기 위해 수동으로 인덱싱 처리를 했지만, 이 과정은 복잡하고 오류가 발생하기 쉬운 한계가 있음.
이 한계점을 보완하기 위해 나온 DiffableDataSource 를 학습하여 적용해보자.

</br>
