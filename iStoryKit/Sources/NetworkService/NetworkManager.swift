//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

import Alamofire
import Foundation
import NetworkServiceAPI

@available(iOS 15.0.0, *)
public class NetworkManager {
    public private(set) var configuration: NetworkConfiguration

    private lazy var evaluators: [String: ServerTrustEvaluating] = {
        guard let certificate: SecCertificate = Certificates.certificate(named: "some-certificate.der") else {
            return [:]
        }
        return [
            configuration.environment.domain:
                PinnedCertificatesTrustEvaluator(certificates: [certificate]),
        ]
    }()

    class DebugServerTrustPolicyManager: ServerTrustManager {
        override open func serverTrustEvaluator(forHost _: String) throws -> ServerTrustEvaluating? {
            DisabledTrustEvaluator()
        }
    }

    public lazy var session: Session! = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
        ]

        var ret: Session
        if configuration.environment.allowInvalidCerts {
            let trustManager = DebugServerTrustPolicyManager(evaluators: [:])
            ret = Session(configuration: config, interceptor: interceptor, serverTrustManager: trustManager)
        } else {
            let trustManager = ServerTrustManager(evaluators: evaluators)
            ret = Session(configuration: config, interceptor: interceptor, serverTrustManager: trustManager)
        }

        return ret
    }()

    private var interceptor: NetworkRequestInterceptor

    public init(configuration: NetworkConfiguration, interceptor: NetworkRequestInterceptor) {
        self.configuration = configuration
        self.interceptor = interceptor
    }
}
