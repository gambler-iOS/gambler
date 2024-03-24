//
//  Game.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/19/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

struct Game: AvailableFirebase, AvailableAggregateReview, Hashable {
    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.id == rhs.id
    }

    var id: String
    let gameName: String
    let gameImage: String
    var descriptionContent: String
    var descriptionImage: [String]?
    var gameLink: String
    let createdDate: Date
    var reviewCount: Int
    var reviewRatingAverage: Double
    let gameIntroduction: GameIntroduction
}

struct GameIntroduction: Codable, Hashable {
    let difficulty: Double
    let minPlayerCount: Int
    let maxPlayerCount: Int
    let playTime: Int
    let genre: [GameGenre]
}

/// 예제: 열거형 사용
/// let theme: GameTheme = .fantasy
/// print(theme.rawValue)      // 출력: "Fantasy"
/// print(theme.koreanName)    // 출력: "판타지"
enum GameGenre: String, Codable, CaseIterable {
    case ageOfReason = "Age of Reason"
    case renaissance = "Renaissance"
    case fantasy = "Fantasy"
    case abstractStrategy = "Abstract Strategy"
    case mythology = "Mythology"
    case moviesTVRadioTheme = "Movies / TV / Radio theme"
    case worldWarII = "World War II"
    case math = "Math"
    case novelBased = "Novel-based"
    case civilization = "Civilization"
    case medieval = "Medieval"
    case miniatures = "Miniatures"
    case modernWarfare = "Modern Warfare"
    case maze = "Maze"
    case bluffing = "Bluffing"
    case horror = "Horror"
    case dice = "Dice"
    case wordGame = "Word Game"
    case animals = "Animals"
    case territoryBuilding = "Territory Building"
    case deduction = "Deduction"
    case civilWar = "Civil War"
    case cardGame = "Card Game"
    case memory = "Memory"
    case farming = "Farming"
    case fighting = "Fighting"
    case puzzle = "Puzzle"
    case scienceFiction = "Science Fiction"
    case nautical = "Nautical"
    case environmental = "Environmental"
    case medical = "Medical"
    case arabian = "Arabian"
    case matureAdult = "Mature / Adult"
    case childrensGame = "Children's Game"
    case spaceExploration = "Space Exploration"
    case collectibleComponents = "Collectible Components"
    case educational = "Educational"
    case postNapoleonic = "Post-Napoleonic"
    case wargame = "Wargame"
    case political = "Political"
    case travel = "Travel"
    case negotiation = "Negotiation"
    case humor = "Humor"
    case ancient = "Ancient"
    case racing = "Racing"
    case religious = "Religious"
    case economic = "Economic"
    case transportation = "Transportation"
    case trains = "Trains"
    case prehistoric = "Prehistoric"
    case murderMystery = "Murder/Mystery"
    case aviationFlight = "Aviation / Flight"
    case cityBuilding = "City Building"
    case partyGame = "Party Game"
    case pirates = "Pirates"
    case printPlay = "Print & Play"
    case spiesSecretAgents = "Spies/Secret Agents"
    case exploration = "Exploration"
    case number = "Number"
    case adventure = "Adventure"
    case americanWest = "American West"
    case expansionForBaseGame = "Expansion for Base-game"
    case industryManufacturing = "Industry / Manufacturing"
    case comicBookStrip = "Comic Book / Strip"
    case zombies = "Zombies"
    case realTime = "Real-time"
    
    var koreanName: String {
        switch self {
        case .ageOfReason: return "이성"
        case .renaissance: return "르네상스"
        case .fantasy: return "판타지"
        case .abstractStrategy: return "추상 전략"
        case .mythology: return "신화"
        case .moviesTVRadioTheme: return "영화 / TV / 라디오 테마"
        case .worldWarII: return "제2차 세계대전"
        case .math: return "수학"
        case .novelBased: return "소설 기반"
        case .civilization: return "문명"
        case .medieval: return "중세"
        case .miniatures: return "미니어처"
        case .modernWarfare: return "현대 전쟁"
        case .maze: return "미로"
        case .bluffing: return "블러핑"
        case .horror: return "호러"
        case .dice: return "주사위"
        case .wordGame: return "단어 게임"
        case .animals: return "동물"
        case .territoryBuilding: return "영토 건설"
        case .deduction: return "추리"
        case .civilWar: return "내전"
        case .cardGame: return "카드 게임"
        case .memory: return "기억력"
        case .farming: return "농업"
        case .fighting: return "전투"
        case .puzzle: return "퍼즐"
        case .scienceFiction: return "과학 소설"
        case .nautical: return "해상"
        case .environmental: return "환경"
        case .medical: return "의학"
        case .arabian: return "아라비안"
        case .matureAdult: return "성인"
        case .childrensGame: return "어린이 게임"
        case .spaceExploration: return "우주 탐사"
        case .collectibleComponents: return "수집 가능한 부품"
        case .educational: return "교육적"
        case .postNapoleonic: return "나폴레옹 전후"
        case .wargame: return "전쟁 게임"
        case .political: return "정치"
        case .travel: return "여행"
        case .negotiation: return "협상"
        case .humor: return "유머"
        case .ancient: return "고대"
        case .racing: return "레이싱"
        case .religious: return "종교적"
        case .economic: return "경제적"
        case .transportation: return "교통수단"
        case .trains: return "기차"
        case .prehistoric: return "원시시대"
        case .murderMystery: return "살인 미스터리"
        case .aviationFlight: return "항공 비행"
        case .cityBuilding: return "도시 건설"
        case .partyGame: return "파티 게임"
        case .pirates: return "해적"
        case .printPlay: return "프린트 & 플레이"
        case .spiesSecretAgents: return "스파이 / 비밀 요원"
        case .exploration: return "탐험"
        case .number: return "숫자"
        case .adventure: return "모험"
        case .americanWest: return "미국 서부"
        case .expansionForBaseGame: return "기본 게임의 확장"
        case .industryManufacturing: return "산업 / 제조"
        case .comicBookStrip: return "만화 책 / 만화"
        case .zombies: return "좀비"
        case .realTime: return "실시간"
        }
    }
}

extension Game {
    static let dummyGame = Game(
        id: UUID().uuidString,
        gameName: "아임 더 보스",
        gameImage: "https://weefun.co.kr/shopimages/weefun/007009000461.jpg?1596805186",
        descriptionContent: "게임 상세 설명",
        descriptionImage: [
            "https://boardm5.godohosting.com/goods/2024/02/dt01.png"],
        gameLink: "link",
        createdDate: Date(),
        reviewCount: 5,
        reviewRatingAverage: 3.5,
        gameIntroduction: GameIntroduction(
            difficulty: 3.1,
            minPlayerCount: 2,
            maxPlayerCount: 4,
            playTime: 2,
            genre: [.fantasy])
        )
    
    static let dummyGameList: [Game] = [
        Game(id: "100423", gameName: "Elder Sign",
             gameImage: "https://cf.geekdo-images.com/wNCSCl961fMzDUhwetfjTg__original/img/H-iLs6JcceMk96bYON5c9PFUag8=/0x0/filters:format(jpeg)/pic1236119.jpg",
             descriptionContent: "1926년, 박물관의 광범위한 이국적인 골동품과 신비로운 유물 컬렉션이 우리 세계와 차원 사이에 숨어 있는 고대 악마 사이의 장벽에 위협을 가하고 있습니다. 저 너머로 향하는 문이 새어나오기 시작하고 점점 더 강력해지는 무시무시한 생물들이 그 문을 훔쳐갑니다. 동물, 미친 사람, 그리고 더..",
             descriptionImage: [""], gameLink: "https://boardgamegeek.com/boardgame/100423",
             createdDate: Date(),
             reviewCount: 3, reviewRatingAverage: 3.542,
             gameIntroduction: GameIntroduction(difficulty: 2.3423, minPlayerCount: 1,
                                                maxPlayerCount: 8, playTime: 90,
                                                genre: [.fantasy, .adventure])
            ),
        Game(id: "172", gameName: "For Sale",
             gameImage: "https://cf.geekdo-images.com/dJh9HkZC346NgPTAicJq_A__original/img/6ib2NLakSlsf69WYwCOe9NNLcsc=/0x0/filters:format(jpeg)/pic1513085.jpg",
             descriptionContent: "For Sale은 명목상 부동산을 사고 파는 것에 관한 빠르고 재미있는 게임입니다. 게임의 두 가지 개별 단계 동안 플레이어는 먼저 여러 건물에 입찰한 다음 모든 건물을 구입한 후 가능한 최대 이익을 위해 건물을 판매합니다. 원본 Ravensburger/FX Schmid ...",
             descriptionImage: [""], gameLink: "https://boardgamegeek.com/boardgame/172",
             createdDate: Date(),
             reviewCount: 6, reviewRatingAverage: 4.242,
             gameIntroduction: GameIntroduction(difficulty: 1.2522, minPlayerCount: 3,
                                                maxPlayerCount: 6, playTime: 30,
                                                genre: [.cardGame, .economic])
            ),
        Game(id: "233867", gameName: "Welcome To...",
             gameImage: "https://cf.geekdo-images.com/g4XmxyKhNVdhC3QPd1purQ__original/img/pb6XFQZFUNOr6OPysOHB3usVDFk=/0x0/filters:format(jpeg)/pic3761012.jpg",
             descriptionContent: "Welcome To...의 건축가로서 당신은 수영장에 자원을 추가하고 직원을 고용하는 등의 작업을 통해 1950년대 미국 최고의 신도시를 건설하고자 합니다. 점수표에 결과를 표시하는 주사위 게임을 작성해 보세요. 하지만 주사위는 없습니다. 대신 세 더미의 카드를 뒤집어서 집 번호와 ...",
             descriptionImage: [""], gameLink: "https://boardgamegeek.com/boardgame/233867",
             createdDate: Date(),
             reviewCount: 5, reviewRatingAverage: 3.92,
             gameIntroduction: GameIntroduction(difficulty: 1.8351, minPlayerCount: 1,
                                                maxPlayerCount: 100, playTime: 25,
                                                genre: [.cityBuilding])
            ),
        Game(id: "124742", gameName: "Android: Netrunner",
             gameImage: "https://cf.geekdo-images.com/2ewHIIG_TRq8bYlqk0jIMw__original/img/cassW39WF2QrPImJF59efADAmM0=/0x0/filters:format(jpeg)/pic3738560.jpg",
             descriptionContent: "Beanstalk의 본고장인 New Angeles에 오신 것을 환영합니다. 인류의 업적을 기리는 이 기념비에 있는 지사 사무실에서 NBN은 여러분이 좋아하는 모든 미디어 프로그램을 자랑스럽게 방송합니다. 우리는 음악과 threedee, 뉴스와 시트콤, 고전 영화와 감각에 대한 완전히 ...",
             descriptionImage: [""], gameLink: "https://boardgamegeek.com/boardgame/124742",
             createdDate: Date(),
             reviewCount: 3, reviewRatingAverage: 3.542,
             gameIntroduction: GameIntroduction(difficulty: 2.3423, minPlayerCount: 2,
                                                maxPlayerCount: 2, playTime: 45,
                                                genre: [.bluffing, .cardGame, .collectibleComponents, .scienceFiction])
            )
    ]
}
