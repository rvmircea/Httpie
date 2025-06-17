import Testing
@testable import Httpie

@Test func example() async throws {
    struct TestingStruct: Codable {
        var message: String?
    }
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let httpClient = Httpie(baseAddress: "http://localhost:5117")
    
    await repeating(times: 3) {
        let result: TestingStruct? = try! await httpClient.getFromJson(endpoint: "/car")
        #expect(result?.message == "Hello, car!")
    }
}

func repeating(times n: UInt8, _ action: () async -> Void) async {
    for _ in 0..<n {
        await action()
    }
}
