import Foundation

enum StudentColloquiumModels {

    enum History {
        struct Item {
            let title: String
            let date: Date
            let score: Int? // nil, если не оценено
        }

        struct Response {
            let items: [Item]
        }

        struct ItemViewModel {
            let title: String
            let dateText: String
            let trailingText: String?   // например, “8/10” или nil
            let showClockIcon: Bool     // если нет оценки – показываем часы
        }

        struct ViewModel {
            let items: [ItemViewModel]
        }
    }
}
