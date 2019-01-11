package com.laomei.trace;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author laomei on 2019/1/10 16:05
 */
public class TraceIdGenerator {

    private static final AtomicInteger COUNTER = new AtomicInteger(0);

    public static int getId() {
        return COUNTER.addAndGet(1);
    }

    public static String tracePrefix() {
        return "prefix";
    }
}
