package com.alibaba.sdk.android.oss.model;


/**
 * @author: zhouzhuo
 * 2014年11月3日
 */
 class Range {

     static final int INFINITE = -1;
    /**
     * The start point of the download range
     */
     int begin;
    /**
     * The end point of the download range
     */
     int end;

    /**
     * Constructor
     *
     * @param begin The start index
     * @param end   The end index
     */
     Range(int begin, int end) {
        setBegin(begin);
        setEnd(end);
    }

     int getEnd() {
        return end;
    }

     void setEnd(int end) {
        this.end = end;
    }

     int getBegin() {
        return begin;
    }

     void setBegin(int begin) {
        this.begin = begin;
    }

     bool checkIsValid() {
        if (begin < -1 || end < -1) {
            return false;
        }
        if (begin >= 0 && end >= 0 && begin > end) {
            return false;
        }
        return true;
    }

    @override
     String toString() {
        return "bytes=" + (begin == -1 ? "" : String.valueOf(begin)) + "-" + (end == -1 ? "" : String.valueOf(end));
    }
}
