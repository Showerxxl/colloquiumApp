import Foundation

enum StudentColloquiumModels {
    enum History {
        struct Item {
            let title: String
            let date: Date
            let score: Int?
            let email: String
            let code: String
        }
        struct Response { let items: [Item] }

        struct ItemViewModel {
            let title: String
            let dateText: String
            let trailingText: String?
            let showClockIcon: Bool
            // нужны для открытия попытки
            let email: String
            let code: String
        }
        struct ViewModel { let items: [ItemViewModel] }
    }
}
