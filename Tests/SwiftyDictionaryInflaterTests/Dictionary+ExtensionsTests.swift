import XCTest
@testable import SwiftyDictionaryInflater

final class DictionaryExtensionTests: XCTestCase {

    func testEmptyDictionary() {
        let dic:[String: String] = [:]
        let expected: [String: Any] = [:]
        let result = dic.inflate()
        XCTAssertEqual(expected.keys.count, result.keys.count)
    }

    func testSimpleDictionary() {
        let dic:[String: String] = [
            "host":"example.backend.com",
            "protocol":"https"
        ]
        let expected: [String: Any] = [
            "host":"example.backend.com",
            "protocol":"https"
        ]
        let result = dic.inflate()
        XCTAssertEqual(expected.keys.count, result.keys.count)
    }

    func testTwoLevelDictionary() {
        let dic:[String: String] = [
            "auth/type":"saml2.web.post",
            "auth/config/saml2.web.post.authchallengeheader.name":"com.backend.example.cloud.security.login",
            "auth/config/saml2.web.post.finish.endpoint.redirectparam":"finishEndpointParam",
            "auth/config/saml2.web.post.finish.endpoint.uri":"/SAMLAuthLauncher",
            "host":"example.backend.com",
            "protocol":"https"
        ]
        let expected: [String: Any] = [
            "host":"example.backend.com",
            "protocol":"https",
            "auth": [
                ["type": "saml2.web.post",
                 "config": [
                    ["saml2.web.post.authchallengeheader.name": "com.backend.example.cloud.security.login",
                     "saml2.web.post.finish.endpoint.redirectparam" : "finishEndpointParam",
                     "saml2.web.post.finish.endpoint.uri": "/SAMLAuthLauncher"
                    ]
                 ]
                ]
            ]
        ]
        let result = dic.inflate()
        XCTAssertEqual(expected.keys.count, result.keys.count)
        XCTAssertEqual(expected.level("auth")![0]["type"] as? String, result.level("auth")![0]["type"] as? String)
    }

    func testThreeLevelDictionary() {

        let dic: [String: String] = [
            "auth/type":"oauth2",
            "auth/config/oauth2.authorizationEndpoint":"https://example.backend.com/oauth2/api/v1/authorize",
            "auth/config/oauth2.tokenEndpoint":"https://example.backend.com/oauth2/api/v1/token",
            "auth/config/oauth2.clients/clientID":"e263c334-cfac-4504-9c1a-776fc5b148fe",
            "auth/config/oauth2.clients/redirectURL":"https://example.backend.com",
            "host":"example.backend.com",
            "protocol":"https"]

        let expected: [String: Any] = [
            "auth" : [
                ["type":"oauth2",
                 "config": [
                    [
                        "oauth2.authorizationEndpoint":"https://example.backend.com/oauth2/api/v1/authorize",
                        "oauth2.tokenEndpoint":"https://example.backend.com/oauth2/api/v1/token",
                        "oauth2.clients":[
                            [
                                "clientID":"e263c334-cfac-4504-9c1a-776fc5b148fe",
                                "redirectURL":"https://example.backend.com"
                            ]
                        ]
                    ]
                 ]
                ]
            ],
            "host":"example.backend.com",
            "protocol":"https"
        ]

        let result = dic.inflate()
        XCTAssertEqual(expected.keys.count, result.keys.count)
        XCTAssertEqual(expected["host"] as! String, result["host"] as! String)
        XCTAssertEqual(expected.level("auth")![0]["type"] as? String, result.level("auth")![0]["type"] as? String)
        XCTAssertEqual("https://example.backend.com/oauth2/api/v1/authorize", result.level("auth")![0].level("config")![0]["oauth2.authorizationEndpoint"] as! String)
    }

//    func testTwoLevelWithIndexDictionary() {
//        let dic:[String: String] = [
//            "auth/type":"saml2.web.post",
//            "auth/config[0]/saml2.web.post.authchallengeheader.name":"com.backend.example.cloud.security.login",
//            "auth/config[0]/saml2.web.post.finish.endpoint.redirectparam":"finishEndpointParam",
//            "auth/config[0]/saml2.web.post.finish.endpoint.uri":"/SAMLAuthLauncher",
//            "auth/config[1]/saml2.web.post.authchallengeheader.name":"com.backend.example.cloud.security.login1",
//            "auth/config[1]/saml2.web.post.finish.endpoint.redirectparam":"finishEndpointParam1",
//            "auth/config[1]/saml2.web.post.finish.endpoint.uri":"/SAMLAuthLauncher1",
//            "host":"example.backend.com",
//            "protocol":"https"
//        ]
//        let expected: [String: Any] = [
//            "host":"example.backend.com",
//            "protocol":"https",
//            "auth": [
//                ["type": "saml2.web.post",
//                 "config": [
//                    ["saml2.web.post.authchallengeheader.name": "com.backend.example.cloud.security.login",
//                     "saml2.web.post.finish.endpoint.redirectparam" : "finishEndpointParam",
//                     "saml2.web.post.finish.endpoint.uri": "/SAMLAuthLauncher"
//                    ]
//                 ]
//                ]
//            ]
//        ]
//        let result = dic.inflate()
//        XCTAssertEqual(expected.keys.count, result.keys.count)
//    }


    static var allTests = [
        ("testExample", testEmptyDictionary),
    ]
}
