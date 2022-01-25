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
 * The wrapper class of a part's part number and its ETag
 */
 class PartETag {

     int partNumber;

     String eTag;

     int partSize;

     int crc64;

    /**
     * Constructor
     *
     * @param partNumber Part number
     * @param eTag       Part ETag
     */
     PartETag(int partNumber, String eTag) {
        setPartNumber(partNumber);
        setETag(eTag);
    }

    /**
     * Gets the Part number
     *
     * @return Part number
     */
     int getPartNumber() {
        return partNumber;
    }

    /**
     * Sets the Part number
     *
     * @param partNumber Part number
     */
     void setPartNumber(int partNumber) {
        this.partNumber = partNumber;
    }

    /**
     * Gets Part ETag
     *
     * @return Part ETag
     */
     String getETag() {
        return eTag;
    }

    /**
     * Sets Part ETag
     *
     * @param eTag Part ETag
     */
     void setETag(String eTag) {
        this.eTag = eTag;
    }

     int getPartSize() {
        return partSize;
    }

     void setPartSize(int partSize) {
        this.partSize = partSize;
    }

     int getCRC64() {
        return crc64;
    }

     void setCRC64(int crc64) {
        this.crc64 = crc64;
    }
}
