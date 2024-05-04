## Gambler 보드 게임 설명과 매장 찾기 앱

` 한 손에 편리하게 보드게임 매장 정보를 파악해요! `

### 주요 기능
 - 보드게임 매장을 찾을 수 있어요
 - 보드게임에 대한 설명을 손쉽게 볼 수 있어요
 - 로그인 이후 원하는 정보에 대한 찜하기를 처리 할 수 있어요
 - 현 위치에 따른 가까운 정보를 조회 할 수 있어요
 - 검색을 통해 원하는 매장/ 게임을 조회 할 수 있어요

### 앱 스토어 스크린샷 화면
![스크린샷 2024-05-04 오후 5 25 08](https://github.com/gambler-iOS/gambler/assets/79183499/a71e3b8f-78f9-45e6-bdfb-3144d2140804)

### 앱 구동 화면
| 홈 화면 | 목록 화면 | 상세 화면 |
|:--:|:--:|:--:|
| 홈 화면 (사진) | 목록 화면(사진) | 상세 화면(사진) |
| 검색 화면 | 좋아요 화면 | 지도 화면 |
| 검색 화면 (사진) | 좋아요 화면(사진) | 지도 화면(사진) |
| 마이 페이지 화면 | 로그인 화면 | 리뷰 화면 |
| 마이 페이지 화면 (사진) | 로그인 화면 (사진) | 리뷰 화면 (사진) |

### 개발 환경, 기슬 스택, 아키텍쳐

#### 개발환경
- iOS 17.0 
- Xcode 15

#### 기술 스택
- SwiftUI / UIKit (Map)
- Async / Await
- SwiftData 
- Firebase / Algolia (Search)
- KingFisher (ImageCache) 
- Tuist / SwiftLint (개발환경)

#### 아키텍쳐
- MVVM 의 흐름과 비슷하게 사용하려는 뷰와 모델의 분리

### 프로젝트 폴더
```
🗂️ gambler
├── 🗂️ Project
│        └── 🗂️ Sources
│                 ├──🗂️ APP
│                 ├── 🗂️Common
│                 ├── 🗂️Extension
│                 ├── 🗂️Feature
│                 │      ├──  🗂️EventBanner
│                 │      ├──  🗂️Game
│                 │      ├──  🗂️Home
│                 │      ├──  🗂️Login
│                 │      ├──  🗂️Map
│                 │      ├──  🗂️MyPage
│                 │      ├──  🗂️Review
│                 │      ├──  🗂️Search
│                 │      └──  🗂️Shop
│                 ├── 🗂️Foundation
│                 ├── 🗂️Model
│                 ├── 🗂️Network
│                 │      └──  🗂️Firebase
│                 └── 🗂️ Service
└── 🗂️XCConfig
      └── Secrets
```

### 팀원 소개
| 👑 PM | iOS 개발 | iOS 개발 | iOS 개발 | 디자이너 | 
|:--:|:--:|:--:|:--:|:--:|
| <a href="https://github.com/empty005"> <img src="https://avatars.githubusercontent.com/u/79183499?v=4" width="140px;" alt="cha_nyeong"/> | <a href="https://github.com/licors"> <img src="https://avatars.githubusercontent.com/u/18344020?v=4" width="140px;" alt="Hyomyeong"/>| <a href="https://github.com/parkinghun"> <img src="https://avatars.githubusercontent.com/u/114156413?v=4" width="140px;" alt="Sunghun Park"/> | <a href="https://github.com/da-hye0"> <img src="https://avatars.githubusercontent.com/u/60743139?v=4" width="140px;" alt="da-hye"/> | <a href="https://github.com/zero001683348"> <img src="https://avatars.githubusercontent.com/u/83890170?v=4" width="140px;" alt="chae_yeong"/>
| 김찬형 | 안효명 | 박성훈 | 정다혜 | 김채영 | 

## 사용 라이센스 / 라이브러리
- Kakao MAP API 
- Tuist
- XMLParsing
- Firebase Function / Authentication / Extension
- Google Sign In / Apple Sign in / Kakao Login
- Algolia (search)
- KingFisher
- SwiftLint

### 더 자세한 사항은 노션 페이지 참조 (회고, 극복 사례, 회의록, 기타 참고사항)
###  <a href=" https://quilted-target-c15.notion.site/d714d31c14bc40f0a2752337ee2affe3?pvs=4"> 팀 노션 페이지

