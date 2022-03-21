//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

import Foundation

public enum Certificates {
    public static func certificate(named: String) -> SecCertificate? {
        guard let filePath = Bundle.main.path(forResource: named, ofType: "der"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
              let certificate = SecCertificateCreateWithData(nil, data as CFData) else {
            return nil
        }

        return certificate
    }
}
