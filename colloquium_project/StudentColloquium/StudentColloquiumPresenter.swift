import Foundation

protocol StudentColloquiumPresentationLogic: AnyObject {
    func presentHistory(_ response: StudentColloquiumModels.History.Response)
    func presentStart()
    func presentAttempt(rows: [(title: String, answer: String)])
}

final class StudentColloquiumPresenter: StudentColloquiumPresentationLogic {

    weak var view: StudentColloquiumViewController?

    func presentHistory(_ response: StudentColloquiumModels.History.Response) {
        let df = DateFormatter(); df.dateFormat = "dd.MM.yyyy"

        let vms: [StudentColloquiumModels.History.ItemViewModel] = response.items.map { item in
            let dateText = df.string(from: item.date)
            let clock = (item.score == nil)
            let trailing = item.score.map { "\($0)" }
            return .init(
                title: item.title,
                dateText: dateText,
                trailingText: trailing,
                showClockIcon: clock,
                email: item.email,
                code:  item.code
            )
        }
        view?.displayHistory(.init(items: vms))
    }

    func presentStart() {
        view?.navigateToStart()
    }
    
    func presentAttempt(rows: [(title: String, answer: String)]) {
        view?.showAttempt(rows) // пробросим прямо во вью
    }
}
