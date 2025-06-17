import Testing
@testable import Httpie

@Test func HttpieGet() async throws {
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

@Test func HttpiePost() async throws {
    struct TestingStruct: Codable {
        var message: String?
    }
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let httpClient = Httpie(baseAddress: "http://localhost:5117")
    let sampleRequest = TestingStruct(message: "testing123")
    
    let result: TestingStruct? = try! await httpClient.postFromJson(endpoint: "/car", data: sampleRequest)
    #expect(result?.message == "\(sampleRequest.message!)!")
}


func repeating(times n: UInt8, _ action: () async -> Void) async {
    for _ in 0..<n {
        await action()
    }
}
