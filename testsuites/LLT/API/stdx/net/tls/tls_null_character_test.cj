/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: ./files
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %f -o %output
// RUN-EXEC: %set_stdx_path %run %run_opt %output %run_args

/*
 * Test description:
 *      test null character
 */

import stdx.net.tls.*
import stdx.crypto.x509.{X509Certificate, PrivateKey}
import std.fs.*
import std.io.*

main(): Int64 {
    var cfgC = TlsClientConfig()
    try {
        cfgC.domain = "oss.PMS.com\0123"
        return -5
    } catch (e: IllegalArgumentException) {
    }
    try {
        cfgC.cipherSuitesV1_2 = ["ECDHE-RSA-AES128-GCM-SHA256", "ECDHE-RSA-CHACHA20-POLY1305\03"]
        return -6
    } catch (e: IllegalArgumentException) {
    }
    try {
        cfgC.cipherSuitesV1_3 = ["TLS_AES_128_GCM_SHA256", "TLS_CHACHA20_POLY1305_SHA256\0"]
        return -7
    } catch (e: IllegalArgumentException) {
    }
    try {
        cfgC.alpnProtocolsList = ["http/1.1", "h2\01"]
        return -8
    } catch (e: IllegalArgumentException) {
    }

    let pem0 = String.fromUtf8(readToEnd(File("./files/end_ecdsa.cer", Read)))
    let pem02 = String.fromUtf8(readToEnd(File("./files/end_ecdsa_private_key.pem", Read)))
    var cfgS = TlsServerConfig(X509Certificate.decodeFromPem(pem0), PrivateKey.decodeFromPem(pem02))
    cfgS.minVersion = TlsVersion.V1_2
    cfgS.maxVersion = TlsVersion.V1_3
    try {
        cfgS.cipherSuitesV1_2 = ["ECDHE-RSA-AES128-GCM-SHA256\0", "ECDHE-RSA-CHACHA20-POLY1305"]
        return -13
    } catch (e: IllegalArgumentException) {
    }
    try {
        cfgS.cipherSuitesV1_3 = ["TLS_AES_128_GCM_SHA256\03", "TLS_CHACHA20_POLY1305_SHA256"]
        return -14
    } catch (e: IllegalArgumentException) {
    }
    try {
        cfgC.alpnProtocolsList = ["http/1.1", "h2\01"]
        return -16
    } catch (e: IllegalArgumentException) {
    }
    return 0
}
