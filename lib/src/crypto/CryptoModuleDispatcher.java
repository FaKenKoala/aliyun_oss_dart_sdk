/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package com.aliyun.oss.crypto;

import java.io.File;
import com.aliyun.oss.model.GetObjectRequest;
import com.aliyun.oss.model.InitiateMultipartUploadRequest;
import com.aliyun.oss.model.InitiateMultipartUploadResult;
import com.aliyun.oss.model.OSSObject;
import com.aliyun.oss.model.ObjectMetadata;
import com.aliyun.oss.model.PutObjectRequest;
import com.aliyun.oss.model.PutObjectResult;
import com.aliyun.oss.model.UploadPartRequest;
import com.aliyun.oss.model.UploadPartResult;

/**
 * A proxy cryptographic module used to dispatch method calls to the appropriate
 * underlying cryptographic module depending on the current configuration.
 */
public class CryptoModuleDispatcher implements CryptoModule {
    private final CryptoModuleAesCtr cryptoMouble;
    public CryptoModuleDispatcher(OSSDirect ossDirect,
                                  EncryptionMaterials encryptionMaterials,
                                  CryptoConfiguration cryptoConfig) {
        cryptoConfig = cryptoConfig.clone(); 
        this.cryptoMouble = new CryptoModuleAesCtr(ossDirect,
                                   encryptionMaterials, cryptoConfig);
    }

    @override
    public PutObjectResult putObjectSecurely(PutObjectRequest putObjectRequest) {
        return cryptoMouble.putObjectSecurely(putObjectRequest);
    }

    @override
    public OSSObject getObjectSecurely(GetObjectRequest req) {
        return cryptoMouble.getObjectSecurely(req);
    }

    @override
    public ObjectMetadata getObjectSecurely(GetObjectRequest req, File file) {
        return cryptoMouble.getObjectSecurely(req, file);
    }

    @override
    public InitiateMultipartUploadResult initiateMultipartUploadSecurely(InitiateMultipartUploadRequest request,
            MultipartUploadCryptoContext context) {
        return cryptoMouble.initiateMultipartUploadSecurely(request, context);
    }

    @override
    public UploadPartResult uploadPartSecurely(UploadPartRequest request, MultipartUploadCryptoContext context) {
        return cryptoMouble.uploadPartSecurely(request, context);
    }

}
