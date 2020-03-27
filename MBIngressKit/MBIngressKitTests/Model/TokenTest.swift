//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBIngressKit

class TokenTest: XCTestCase {
    
    // MARK: Properties
    static let accessToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJvS3ZiY05BNkY1Qm1FRFhINnA0eFlvb01EMmNRckxXNUZaVHNIa2EwZ2wwIn0.eyJqdGkiOiJiY2ViMGQwMy1jMWM3LTQ0OGEtYTE1NS0yOTJkYWM4ZDQ1YWQiLCJleHAiOjE1MzYzMzU1MTQsIm5iZiI6MCwiaWF0IjoxNTM2MzMxOTE0LCJpc3MiOiJodHRwOi8vMTcyLjE3LjAuMTo4MDgwL2F1dGgvcmVhbG1zL0RhaW1sZXIiLCJhdWQiOiJycyIsInN1YiI6IjBlMWMzNGE5LTdmNDEtNGY5Ni04Y2E4LWQ0ZTM2NmYzMjMyMSIsInR5cCI6IkJlYXJlciIsImF6cCI6InJzIiwiYXV0aF90aW1lIjowLCJzZXNzaW9uX3N0YXRlIjoiYTYyNzBlNzgtZGVhMy00OTdmLWJlMjctYjc2ZmU5ZTNlZDkyIiwiYWNyIjoiMSIsImFsbG93ZWQtb3JpZ2lucyI6WyJsb2NhbGhvc3Q6ODA4MCJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoiZW1haWwgcHJvZmlsZSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoiSm9obiBOZXVtYW5uIiwiY2lhbWlkIjoiMDAxMjAxMTAyMTBhZGU3MCIsInByZWZlcnJlZF91c2VybmFtZSI6ImpvaG5uZXVtYW5uIiwiZ2l2ZW5fbmFtZSI6IkpvaG4iLCJmYW1pbHlfbmFtZSI6Ik5ldW1hbm4iLCJlbWFpbCI6InNpdG51dHplcisyMjItNDU3OGludEBnbWFpbC5jb20ifQ.DB5OAgJnQ6g_XdSVzG-dqqORrXSAWn_XspDZKxqY9UNen76Dkc4OCnU2kj_PZld446tvVjm73eI2svcdJkPiADBtov9Sg9tDDA0Et2lsMbP_GV5Ea4vmNcbeuts9DoKNTXczrau4aL-GYo3_mSxydlKzwulw5i8gTC-ir8UstBj-OCQtiLXtwwdERlc5PxnPvb8b-XGwjYltN2_fSQGUkoUxkBzWr5hPW4Y4kE2dDzBAIR--Ta4xVNtWqgv1BsiBwQ1rvgWLWxMCIYNVh3eupPmpBHU25eZYBoSR1_i7HkS37JxIoCJ0cJ9S3VRXwDDxdZuKHPCF1mni9a5WyWS_Jw"
    static let refreshToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJvS3ZiY05BNkY1Qm1FRFhINnA0eFlvb01EMmNRckxXNUZaVHNIa2EwZ2wwIn0.eyJqdGkiOiI1MzA1YzIzZC04NmViLTQ1MDItYjI5Zi1lYjkzNzE1NjBhNGEiLCJleHAiOjE1MzYzNDE0MDMsIm5iZiI6MCwiaWF0IjoxNTM2MzMxOTE0LCJpc3MiOiJodHRwOi8vMTcyLjE3LjAuMTo4MDgwL2F1dGgvcmVhbG1zL0RhaW1sZXIiLCJhdWQiOiJycyIsInN1YiI6IjBlMWMzNGE5LTdmNDEtNGY5Ni04Y2E4LWQ0ZTM2NmYzMjMyMSIsInR5cCI6IlJlZnJlc2giLCJhenAiOiJycyIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6ImE2MjcwZTc4LWRlYTMtNDk3Zi1iZTI3LWI3NmZlOWUzZWQ5MiIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJlbWFpbCBwcm9maWxlIn0.eQU4V06lj9IOK1iP9rruiqSOHfAVkppnmOUiAiJe8B1RUKe2flmG9_Ug0UkKYa7Q-fl1Xjari9TzG4Nkceu0AbSyAe1WbLjVpIQJ8UV-LyfUTk-NBcjjy_27XiyBCTe2qowFGYCRR97Sw_6A1fJhAwAPRrHz5QWWFGmaaQv5Q7wyklh-R3Nb7oi5aofaqPtIFe-BbZY9LbisU7_cTwM1WG1r-RL1VfzlGVilbLQ1lcaWdnhCDWfCCjgzftt3k3bHRTupXGAHhsy0ie85PIinrRC2AMrroRnL-ck6m85B6lxG0SzEdw5XbAhgHAdgFn8jlIJ31zqy4uIXbFc0cmBICA"
    static let refreshTokenOfflineAccess =
    "eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmYzdjYzJjYi1jZTE1LTRiMTgtOTcwNC04MWM1MTcyYTM4ZTUifQ.eyJqdGkiOiI4ODgzYTZjYy0wZTJmLTRmNzItYThkYS1hMmZkYWU2YmRkMmYiLCJleHAiOjAsIm5iZiI6MCwiaWF0IjoxNTY5OTk1NjY5LCJpc3MiOiJodHRwczovL2tleWNsb2FrLnJpc2luZ3N0YXJzLWludC5kYWltbGVyLmNvbS9hdXRoL3JlYWxtcy9EYWltbGVyIiwiYXVkIjoiaHR0cHM6Ly9rZXljbG9hay5yaXNpbmdzdGFycy1pbnQuZGFpbWxlci5jb20vYXV0aC9yZWFsbXMvRGFpbWxlciIsInN1YiI6ImViMWYxOWQ1LWUxYzEtNDE1NC04YjgyLTMxNjY2YmFmMWE1MyIsInR5cCI6Ik9mZmxpbmUiLCJhenAiOiJhcHAiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI2YzIxZGZmMS1jMDBkLTQyMjYtYjRjMi02ZTdmNmM2ZDljMWQiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoiZW1haWwgb2ZmbGluZV9hY2Nlc3MgcHJvZmlsZSJ9.M_M5EMoGgs78Rf1XJ2NSkDE00-Gh-UQ1v7K3cX4dcRk"
    var token: Token?
    
    
    // MARK: - Life cycle
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func initToken(withRefreshTokenOfflineAccess: Bool = false) {
        self.token = Token(accessToken: TokenTest.accessToken,
                           expirationDate: nil,
                           refreshToken: withRefreshTokenOfflineAccess ? TokenTest.refreshTokenOfflineAccess : TokenTest.refreshToken,
                           sessionState: UUID().uuidString,
                           tokenType: .native)
    }
    
    // MARK: - Tests
    
    func testAccessToken() {
        initToken()
        
        XCTAssertTrue(self.token?.accessTokenDecode != nil)
        XCTAssertTrue(self.token?.accessExpirationDate != nil)
        XCTAssertTrue(self.token?.isAccessTokenExpired == true)
        XCTAssertTrue(self.token?.isAccessTokenValid == true)
    }
    
    func testToken() {
        initToken()
        
        XCTAssertTrue(self.token?.ciamId?.isEmpty == false)
        XCTAssertTrue(self.token?.isAuthorized == true)
        XCTAssertTrue(self.token?.isExpired == true)
    }
    
    func testRefreshToken() {
        initToken()
        
        XCTAssertTrue(self.token?.refreshType == RefreshTokenType.refresh)
        XCTAssertTrue(self.token?.refreshTokenDecode != nil)
        XCTAssertTrue(self.token?.refreshExpirationDate != nil)
        XCTAssertTrue(self.token?.isRefreshTokenExpired == true)
        XCTAssertTrue(self.token?.isRefreshTokenValid == true)
    }
    
    func testRefreshTokenOfflineAccess() {
        initToken(withRefreshTokenOfflineAccess: true)
        
        XCTAssertTrue(self.token?.refreshType == RefreshTokenType.offline)
        XCTAssertTrue(self.token?.refreshTokenDecode != nil)
        XCTAssertTrue(self.token?.refreshExpirationDate != nil)
        XCTAssertTrue(self.token?.isRefreshTokenExpired == false) // Offline Tokens never expire from client's perspective
        XCTAssertTrue(self.token?.isRefreshTokenValid == true)
    }
}
