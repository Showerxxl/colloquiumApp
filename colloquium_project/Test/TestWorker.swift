//
//  TestWorker.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

protocol TestWorkerProtocol {
    func loadTest(_ completion: @escaping (Result<Test, Error>) -> Void)
}

final class TestWorker: TestWorkerProtocol {
    private let service: TestServiceProtocol
    init(service: TestServiceProtocol) {
        self.service = service
    }
    func loadTest(_ completion: @escaping (Result<Test, Error>) -> Void) {
        service.fetchTest(completion: completion)
    }
}
