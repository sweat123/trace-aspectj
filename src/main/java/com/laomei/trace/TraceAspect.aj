package com.laomei.trace;

import org.aspectj.lang.Signature;

/**
 * @author laomei on 2019/1/10 15:55
 */
public final aspect TraceAspect {

    private static final ThreadLocal<String> THREAD_LOCAL = new ThreadLocal<String>() {
        @Override
        protected String initialValue() {
            return null;
        }
    };

    pointcut tracePoint(): @annotation(Trace) && execution(* *(..));

    Object around(): tracePoint() {
        Object result = null;

        boolean rootNode = false;
        String parentId = THREAD_LOCAL.get();
        String id = null;
        if (isEmpty(parentId)) {
            rootNode = true;
            parentId = TraceIdGenerator.tracePrefix();
            id = parentId + "-" + Integer.toString(TraceIdGenerator.getId());
        } else {
            id = parentId + "-" + Integer.toString(TraceIdGenerator.getId());
        }

        THREAD_LOCAL.set(id);
        final long start = System.currentTimeMillis();

        result = proceed();

        final long cost = System.currentTimeMillis() - start;
        final Signature signature = thisEnclosingJoinPointStaticPart.getSignature();
        final String methodName = signature.getName();
        final String clazzName = signature.getDeclaringType().getCanonicalName();
        String trace = id + "|" + clazzName + "|" + methodName + "|" + cost + "ms";
        if (rootNode) {
            THREAD_LOCAL.remove();
        } else {
            THREAD_LOCAL.set(parentId);
        }
        TraceQueue.logger(trace);
        return result;
    }

    private boolean isEmpty(String str) {
        return str == null || "".equals(str);
    }
}
