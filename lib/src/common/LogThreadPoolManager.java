package com.alibaba.sdk.android.oss.common;

import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.Executors;
import java.util.concurrent.RejectedExecutionHandler;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * Created by jingdan on 2017/9/5.
 * ThreadPool For Log
 */

 class LogThreadPoolManager {
     static final int SIZE_CORE_POOL = 1;
     static final int SIZE_MAX_POOL = 1;
     static final int TIME_KEEP_ALIVE = 5000;
     static final int SIZE_WORK_QUEUE = 500;
     static final int PERIOD_TASK_QOS = 1000;
     static final int SIZE_CACHE_QUEUE = 200;
     static LogThreadPoolManager sThreadPoolManager = new LogThreadPoolManager();
     final Queue<Runnable> mTaskQueue = new LinkedList<Runnable>();
     final RejectedExecutionHandler mHandler = new RejectedExecutionHandler() {
        @Override
         void rejectedExecution(Runnable task, ThreadPoolExecutor executor) {
            if (mTaskQueue.size() >= SIZE_CACHE_QUEUE) {
                mTaskQueue.poll();//remove old
            }
            mTaskQueue.offer(task);
        }
    };
     final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
     final ThreadPoolExecutor mThreadPool = new ThreadPoolExecutor(SIZE_CORE_POOL, SIZE_MAX_POOL,
            TIME_KEEP_ALIVE, TimeUnit.MILLISECONDS, new ArrayBlockingQueue<Runnable>(SIZE_WORK_QUEUE), new ThreadFactory() {
        @Override
         Thread newThread(Runnable r) {
            return new Thread(r, "oss-android-log-thread");
        }
    }, mHandler);
     final Runnable mAccessBufferThread = new Runnable() {
        @Override
         void run() {
            if (hasMoreAcquire()) {
                mThreadPool.execute(mTaskQueue.poll());
            }
        }
    };
     final ScheduledFuture<?> mTaskHandler = scheduler.scheduleAtFixedRate(mAccessBufferThread, 0,
            PERIOD_TASK_QOS, TimeUnit.MILLISECONDS);

     LogThreadPoolManager() {
    }

     static LogThreadPoolManager newInstance() {
        if (sThreadPoolManager == null) {
            sThreadPoolManager = new LogThreadPoolManager();
        }
        return sThreadPoolManager;
    }

     bool hasMoreAcquire() {
        return !mTaskQueue.isEmpty();
    }

     void addExecuteTask(Runnable task) {
        if (task != null) {
            mThreadPool.execute(task);
        }
    }
}
