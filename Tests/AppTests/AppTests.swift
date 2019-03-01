import App
import XCTest

final class AppTests: XCTestCase {
    func testParsePerformanceTestResultsInteractor() throws {
        let interactor = ParsePerformanceTestResultsInteractor()
        
        let results = try interactor.execute(output: CircleCIConstants.performanceTestOuput)
        let expectedNames = ["testCaseSensitivePerformance", "testCaseInsensitivePerformance", "testCaseInsensitiveRoutingMatchFirstPerformance", "testCaseInsensitiveRoutingMatchLastPerformance", "testMinimalRouterCaseInsensitivePerformance", "testMinimalRouterCaseSensitivePerformance", "testMinimalEarlyFailPerformance"]
        let expectedAverages = [0.024, 0.035, 0.047, 0.047, 0.016, 0.02, 0.013]
        let expected = [0.024, 0.032, 0.045, 0.046, 0.016, 0.021, 0.013]
        XCTAssert(results.count == 7)
        XCTAssert(results.map { $0.name } == expectedNames)
        XCTAssert(results.map { $0.average } == expectedAverages)
        XCTAssert(results.map { $0.expected } == expected)
    }

    static let allTests = [
        ("testParsePerformanceTestResultsInteractor", testParsePerformanceTestResultsInteractor)
    ]
}
