package com.example.vsb;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.VpnService;
import android.os.ParcelFileDescriptor;
import android.util.Log;

import java.net.InetAddress;
import java.net.UnknownHostException;

import machine.M;

public class MyVpnService extends VpnService {
    private static final String ADDRESS = "10.0.0.2";
    private static final String DNS = "1.1.1.1";

    private ParcelFileDescriptor tun;

    private String dialConfStr;

    private M m;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String dialConfStr = intent.getStringExtra("dialConfStr");
        Log.w("vs: dialConfStr", dialConfStr);
        this.dialConfStr = dialConfStr;

        // onStartCommand 在 onCreate 后运行, 此时m已经被初始化.

        try {
            m.hotLoadListenUrl("tun://" + tun.getFd(), 1);
        } catch (Exception e) {
            Log.w("vs start Exception", e.toString());
        }

        try {
            m.hotLoadDialConfStr(dialConfStr);
        } catch (Exception e) {
            Log.w("vs start Exception", e.toString());
        }

        Log.w("vs", "start()");

        m.start();
        m.easyPrintState();

        return START_STICKY;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        Log.w("vs", "create MyVpnService");

        if (tun == null) {
            Log.w("vs", "create tun");
            try {
                Builder builder = new Builder()
                        .addAddress(ADDRESS, 24)
                        .addRoute("0.0.0.0", 0)
                        .addDnsServer(DNS)
                        .addDisallowedApplication(this.getApplication().getPackageName());
                tun = builder.establish();
            } catch (PackageManager.NameNotFoundException e) {
                throw new RuntimeException(e);
            }
        }

        m = new M();

        Log.w("vs", "will start()");

    }

    @Override
    public void onDestroy() {
        super.onDestroy();

        Log.w("vs destory", "");
        m.stop();
    }

}
