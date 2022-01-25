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

import java.util.Date;

/**
 * The multipart upload's part summary class definition
 */
 class PartSummary {

     int partNumber;

     Date lastModified;

     String eTag;

     int size;

    /**
     * Constructor
     */
     PartSummary() {
    }

    /**
     * Gets the part number.
     *
     * @return Part number
     */
     int getPartNumber() {
        return partNumber;
    }

    /**
     * Gets the part number.
     *
     * @param partNumber Part number
     */
     void setPartNumber(int partNumber) {
        this.partNumber = partNumber;
    }

    /**
     * Gets the part's last modified time
     *
     * @return Part's last modified time
     */
     Date getLastModified() {
        return lastModified;
    }

    /**
     * Sets the part's last modified time
     *
     * @param lastModified Part's last modified time
     */
     void setLastModified(Date lastModified) {
        this.lastModified = lastModified;
    }

    /**
     * Gets Part ETag value
     *
     * @return Part ETag value
     */
     String getETag() {
        return eTag;
    }

    /**
     * Sets Part ETag value
     *
     * @param eTag Part ETag value
     */
     void setETag(String eTag) {
        this.eTag = eTag;
    }

    /**
     * Gets Part size in byte
     *
     * @return Part in byte
     */
     int getSize() {
        return size;
    }

    /**
     * Sets Part size in byte
     *
     * @param size Part size in byte
     */
     void setSize(int size) {
        this.size = size;
    }

}
