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

package com.alibaba.sdk.android.oss.model;

/**
 * 存储类型。
 */
 enum StorageClass {

    /**
     * Standard
     */
    Standard("Standard"),

    /**
     * Infrequent Access
     */
    IA("IA"),

    /**
     * Archive
     */
    Archive("Archive"),

    /**
     * Unknown
     */
    Unknown("Unknown");

     String storageClassString;

     StorageClass(String storageClassString) {
        this.storageClassString = storageClassString;
    }

     static StorageClass parse(String storageClassString) {
        for (StorageClass st : StorageClass.values()) {
            if (st.toString().equals(storageClassString)) {
                return st;
            }
        }

        throw ArgumentError("Unable to parse " + storageClassString);
    }

    @override
     String toString() {
        return this.storageClassString;
    }
}
