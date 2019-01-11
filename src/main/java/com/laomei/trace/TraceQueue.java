package com.laomei.trace;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author laomei on 2019/1/11 11:09
 */
public class TraceQueue {

    private static final Logger logger = LoggerFactory.getLogger(TraceQueue.class);

    public static void logger(String trace) {
        logger.info(trace);
    }
}
