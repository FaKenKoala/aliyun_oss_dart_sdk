class LogThreadPoolManager {
  static final int SIZE_CORE_POOL = 1;
  static final int SIZE_MAX_POOL = 1;
  static final int TIME_KEEP_ALIVE = 5000;
  static final int SIZE_WORK_QUEUE = 500;
  static final int PERIOD_TASK_QOS = 1000;
  static final int SIZE_CACHE_QUEUE = 200;
  static LogThreadPoolManager sThreadPoolManager = LogThreadPoolManager();
  //  final Queue<Runnable> mTaskQueue = new LinkedList<Runnable>();
  //  final RejectedExecutionHandler mHandler = new RejectedExecutionHandler() {
  //     @override
  //      void rejectedExecution(Runnable task, ThreadPoolExecutor executor) {
  //         if (mTaskQueue.size() >= SIZE_CACHE_QUEUE) {
  //             mTaskQueue.poll();//remove old
  //         }
  //         mTaskQueue.offer(task);
  //     }
  // };
  //  final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
  //  final ThreadPoolExecutor mThreadPool = new ThreadPoolExecutor(SIZE_CORE_POOL, SIZE_MAX_POOL,
  //         TIME_KEEP_ALIVE, TimeUnit.MILLISECONDS, new ArrayBlockingQueue<Runnable>(SIZE_WORK_QUEUE), new ThreadFactory() {
  //     @override
  //      Thread newThread(Runnable r) {
  //         return new Thread(r, "oss-android-log-thread");
  //     }
  // }, mHandler);
  //  final Runnable mAccessBufferThread = new Runnable() {
  //     @override
  //      void run() {
  //         if (hasMoreAcquire()) {
  //             mThreadPool.execute(mTaskQueue.poll());
  //         }
  //     }
  // };
  //  final ScheduledFuture<?> mTaskHandler = scheduler.scheduleAtFixedRate(mAccessBufferThread, 0,
  //         PERIOD_TASK_QOS, TimeUnit.MILLISECONDS);

  //  LogThreadPoolManager() {
  // }

  //  static LogThreadPoolManager newInstance() {
  //     if (sThreadPoolManager == null) {
  //         sThreadPoolManager = new LogThreadPoolManager();
  //     }
  //     return sThreadPoolManager;
  // }

  //  bool hasMoreAcquire() {
  //     return !mTaskQueue.isEmpty();
  // }

  //  void addExecuteTask(Runnable task) {
  //     if (task != null) {
  //         mThreadPool.execute(task);
  //     }
  // }
}
