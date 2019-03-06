import Vapor

public struct SaveTestResultsInteractor {
    func execute(
        on req: Request,
        testResults: Future<[PerformanceTestResults]>
    ) -> Future<Response> {
        return testResults.flatMap { result in
            return result.map { $0.create(on: req) }.flatten(on: req)
            }.flatMap { _ in
                return try HTTPStatus.ok.encode(for: req)
        }
    }
}


