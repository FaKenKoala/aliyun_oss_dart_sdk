/// This is the request class that is used to select an object from OSS. It
/// wraps all the information needed to select this object.
/// User can pass sql expression to filter csv objects.

enum ExpressionType {
        SQL,
    }
 class SelectObjectRequest extends GetObjectRequest {
     static final String LINE_RANGE_PREFIX = "line-range=";
     static final String SPLIT_RANGE_PREFIX = "split-range=";

     

     String expression;
     boolean skipPartialDataRecord = false;
     long maxSkippedRecordsAllowed = 0;
     ExpressionType expressionType = ExpressionType.SQL;
     InputSerialization inputSerialization = new InputSerialization();
     OutputSerialization outputSerialization = new OutputSerialization();
    /**
     *  scanned bytes progress listener for select request,
     *  it is different from progressListener from {@link WebServiceRequest} which used for request and response bytes
     */
     ProgressListener selectProgressListener;

    //lineRange is not a generic requirement, we will move it to somewhere else later.
     long[] lineRange;

    //splitRange is a range of splits, one split is a collection of continuous lines
     long[] splitRange;

     SelectObjectRequest(String bucketName, String key) {
        super(bucketName, key);
        setProcess(SUBRESOURCE_CSV_SELECT);
    }

     long[] getLineRange() {
        return lineRange;
    }

    /**
     * For text file, we can define line range for select operations.
     * Select will only scan data between startLine and endLine, that is [startLine, endLine]
     *
     * * @param startLine
     *            <p>
     *            Start line number
     *            </p>
     *            <p>
     *            When the start is non-negative, it means the starting line
     *            to select. When the start is -1, it means the range is
     *            determined by the end only and the end could not be -1. For
     *            example, when start is -1 and end is 100. It means the
     *            select line range will be the last 100 lines.
     *            </p>
     * @param endLine
     *            <p>
     *            End line number
     *            </p>
     *            <p>
     *            When the end is non-negative, it means the ending line to
     *            select. When the end is -1, it means the range is determined
     *            by the start only and the start could not be -1. For example,
     *            when end is -1 and start is 100. It means the select range
     *            will be all exception first 100 lines.
     *            </p>
     */
     void setLineRange(long startLine, long endLine) {
        lineRange = new long[] {startLine, endLine};
    }

     SelectObjectRequest withLineRange(long startLine, long endLine) {
        setLineRange(startLine, endLine);
        return this;
    }

     long[] getSplitRange() {
        return splitRange;
    }

    /**
     * For text file, we can define split range for select operations.
     * Select will only scan data between startSplit and endSplit, that is [startSplit, endSplit]
     *
     * @param startSplit
     *            <p>
     *            Start split number
     *            </p>
     *            <p>
     *            When the start is non-negative, it means the starting split
     *            to select. When the start is -1, it means the range is
     *            determined by the end only and the end could not be -1. For
     *            example, when start is -1 and end is 100. It means the
     *            select split range will be the last 100 splits.
     *            </p>
     *
     * @param endSplit
     *            <p>
     *            End split number
     *            </p>
     *            <p>
     *            When the end is non-negative, it means the ending split to
     *            select. When the end is -1, it means the range is determined
     *            by the start only and the start could not be -1. For example,
     *            when end is -1 and start is 100. It means the select range
     *            will be all exception first 100 splits.
     *            </p>
     */
     void setSplitRange(long startSplit, long endSplit) {
        splitRange = new long[] {startSplit, endSplit};
    }

     SelectObjectRequest withSplitRange(long startSplit, long endSplit) {
        setSplitRange(startSplit, endSplit);
        return this;
    }

     String lineRangeToString(long[] range) {
        return rangeToString(LINE_RANGE_PREFIX, range);
    }

     String splitRangeToString(long[] range) {
        return rangeToString(SPLIT_RANGE_PREFIX, range);
    }

     String rangeToString(String rangePrefix, long[] range) {
        RangeSpec rangeSpec = RangeSpec.parse(range);
        switch (rangeSpec.getType()) {
            case NORMAL_RANGE:
                return String.format("%s%d-%d", rangePrefix, rangeSpec.getStart(), rangeSpec.getEnd());
            case START_TO:
                return String.format("%s%d-", rangePrefix, rangeSpec.getStart());
            case TO_END:
                return String.format("%s-%d", rangePrefix,  rangeSpec.getEnd());
        }

        return null;
    }

    /**
     * Get the expression which used to filter objects
     */
     String getExpression() {
        return expression;
    }

    /**
     * Set the expression which used to filter objects
     */
     void setExpression(String expression) {
        this.expression = expression;
    }

     SelectObjectRequest withExpression(String expression) {
        setExpression(expression);
        return this;
    }

     boolean isSkipPartialDataRecord() {
        return skipPartialDataRecord;
    }

     void setSkipPartialDataRecord(boolean skipPartialDataRecord) {
        this.skipPartialDataRecord = skipPartialDataRecord;
    }

     SelectObjectRequest withSkipPartialDataRecord(boolean skipPartialDataRecord) {
        setSkipPartialDataRecord(skipPartialDataRecord);
        return this;
    }

     long getMaxSkippedRecordsAllowed() {
        return maxSkippedRecordsAllowed;
    }

     void setMaxSkippedRecordsAllowed(long maxSkippedRecordsAllowed) {
        this.maxSkippedRecordsAllowed = maxSkippedRecordsAllowed;
    }

     SelectObjectRequest withMaxSkippedRecordsAllowed(long maxSkippedRecordsAllowed) {
        setMaxSkippedRecordsAllowed(maxSkippedRecordsAllowed);
        return this;
    }

    /**
     * Get the expression type, we only support SQL now.
     * @return {@link ExpressionType}
     */
     ExpressionType getExpressionType() {
        return expressionType;
    }

    /**
     * Get the input serialization, we use this to parse data
     * @return {@link InputSerialization}
     */
     InputSerialization getInputSerialization() {
        return inputSerialization;
    }

    /**
     * Set the input serialization, we use this to parse data
     */
     void setInputSerialization(InputSerialization inputSerialization) {
        if (inputSerialization.getSelectContentFormat() == SelectContentFormat.CSV) {
            setProcess(SUBRESOURCE_CSV_SELECT);
        } else {
            setProcess(SUBRESOURCE_JSON_SELECT);
        }
        this.inputSerialization = inputSerialization;
    }

     SelectObjectRequest withInputSerialization(InputSerialization inputSerialization) {
        setInputSerialization(inputSerialization);
        return this;
    }

    /**
     * Get the output serialization, it defines the output format
     * @return {@link OutputSerialization}
     */
     OutputSerialization getOutputSerialization() {
        return outputSerialization;
    }

    /**
     * Set the output serialization, it defines the output format
     */
     void setOutputSerialization(OutputSerialization outputSerialization) {
        this.outputSerialization = outputSerialization;
    }

     SelectObjectRequest withOutputSerialization(OutputSerialization outputSerialization) {
        setOutputSerialization(outputSerialization);
        return this;
    }

     ProgressListener getSelectProgressListener() {
        return selectProgressListener;
    }

     void setSelectProgressListener(ProgressListener selectProgressListener) {
        this.selectProgressListener = selectProgressListener;
    }

     SelectObjectRequest withSelectProgressListener(ProgressListener selectProgressListener) {
        setSelectProgressListener(selectProgressListener);
        return this;
    }
}
