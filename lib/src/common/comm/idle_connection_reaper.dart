
/// A daemon thread used to periodically check connection pools for idle
/// connections.
  class IdleConnectionReaper extends Thread {
     static final int REAP_INTERVAL_MILLISECONDS = 5 * 1000;
     static final ArrayList<HttpClientConnectionManager> connectionManagers = [];

     static IdleConnectionReaper instance;

     static long idleConnectionTime = 60 * 1000;

     volatile bool shuttingDown;

     IdleConnectionReaper() {
        super("idle_connection_reaper");
        setDaemon(true);
    }

     static bool registerConnectionManager(HttpClientConnectionManager connectionManager) {
        if (instance == null) {
            instance = new IdleConnectionReaper();
            instance.start();
        }
        return connectionManagers.add(connectionManager);
    }

     static  bool removeConnectionManager(HttpClientConnectionManager connectionManager) {
        bool b = connectionManagers.remove(connectionManager);
        if (connectionManagers.isEmpty())
            shutdown();
        return b;
    }

     void markShuttingDown() {
        shuttingDown = true;
    }

    @override
     void run() {
        while (true) {
            if (shuttingDown) {
                getLog().debug("Shutting down reaper thread.");
                return;
            }

            try {
                Thread.sleep(REAP_INTERVAL_MILLISECONDS);
            } catch (InterruptedException e) {
            }

            try {
                List<HttpClientConnectionManager> connectionManagers = null;
                 (IdleConnectionReaper.class) {
                    connectionManagers = (List<HttpClientConnectionManager>) IdleConnectionReaper.connectionManagers
                            .clone();
                }
                for (HttpClientConnectionManager connectionManager : connectionManagers) {
                    try {
                        connectionManager.closeExpiredConnections();
                        connectionManager.closeIdleConnections(idleConnectionTime, TimeUnit.MILLISECONDS);
                    } catch (Exception ex) {
                        getLog().warn("Unable to close idle connections", ex);
                    }
                }
            } catch (Throwable t) {
                getLog().debug("Reaper thread: ", t);
            }
        }
    }

     static  bool shutdown() {
        if (instance != null) {
            instance.markShuttingDown();
            instance.interrupt();
            connectionManagers.clear();
            instance = null;
            return true;
        }
        return false;
    }

     static  int size() {
        return connectionManagers.size();
    }

     static  void setIdleConnectionTime(long idletime) {
        idleConnectionTime = idletime;
    }

}
