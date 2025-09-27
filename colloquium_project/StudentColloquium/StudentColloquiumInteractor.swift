import Foundation

protocol StudentColloquiumBusinessLogic: AnyObject {
    func loadHistory()
    func startButtonTapped()
}

final class StudentColloquiumInteractor: StudentColloquiumBusinessLogic {

    var presenter: StudentColloquiumPresentationLogic?

    func loadHistory() {
        let response = StudentColloquiumModels.History.Response(items: [])
        presenter?.presentHistory(response)
    }

    func startButtonTapped() {
        presenter?.presentStart()
    }
}
