package com.laomei.trace;

import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedList;

/**
 * @author laomei on 2019/1/10 16:52
 */
public class TraceMetaList {

    private static final LinkedList<String> TRACE_METAS = new LinkedList<String>();

    public static void addTraceMeta(String trace) {
        TRACE_METAS.add(trace);
    }

    public static Iterator<String> iterable() {
        return Collections.unmodifiableList(TRACE_METAS).iterator();
    }
}
