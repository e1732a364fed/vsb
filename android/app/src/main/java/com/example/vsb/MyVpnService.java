package com.example.vsb;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.VpnService;
import android.os.ParcelFileDescriptor;
import android.util.Log;

import java.net.InetAddress;
import java.net.UnknownHostException;

import machine.M;
import android.content.BroadcastReceiver;
import android.content.IntentFilter;
import android.content.Context;

public class MyVpnService extends VpnService {
    private static final String ADDRESS = "10.0.0.2";
    private static final String DNS = "1.1.1.1";

    private ParcelFileDescriptor tun;

    private String dialConfStr;

    private M m;

    BroadcastReceiver broadcastReceiver;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String dialConfStr = intent.getStringExtra("dialConfStr");
        // Log.w("vs: dialConfStr", dialConfStr);
        this.dialConfStr = dialConfStr;

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

        Log.w("vs", "create MyVpnService");

        m = new M();

        Log.w("vs", "will start()");

        // onStartCommand 在 onCreate 后运行, 此时m已经被初始化.

        try {
            m.hotLoadListenUrl("tun://" + tun.getFd(), 1);
        } catch (Exception e) {
            Log.w("vs start Exception", e.toString());
            stopSelf();
            return START_NOT_STICKY;
        }

        try {
            m.hotLoadDialConfStr(dialConfStr);
        } catch (Exception e) {
            Log.w("vs start Exception", e.toString());
            stopSelf();
            return START_NOT_STICKY;
        }

        Log.w("vs", "start()");

        m.start();
        m.easyPrintState();

        broadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();
                Log.w("vs got msg", "");

                if (action.equals("ffffffffffffffffffffffff")) {

                    Log.w("vs got fmsg", "");

                    int arg1 = intent.getIntExtra("isdown", 0);
                    if (arg1 == 1) {
                        Log.w("vs msg let us stop", "");

                        // 这里发现，直接调用stopSelf毫无效果, 外部调用stopService也毫无效果
                        // 必须接受消息，然后手动关闭tun, 之后再调用stopSelf

                        myCloseSelf2();
                    }
                }

            }
        };
        IntentFilter ift = new IntentFilter();
        ift.addAction("ffffffffffffffffffffffff");
        registerReceiver(broadcastReceiver, ift);

        return START_STICKY;
    }

    // @Override
    // public void onCreate() {
    // super.onCreate();

    // }

    void myCloseSelf2() {
        Log.w("vs myCloseSelf2", "");

        myCloseSelf();
        stopSelf(); // 如果不调用 stopSelf, 就算关闭了tun, onDestroy 也不会被调用
    }

    void myCloseSelf() {
        Log.w("vs myCloseSelf", "");

        // 我们的vs也会试图在 m.Stop内部关闭tun, 但如果让它关闭的话, 会报错

        // fdsan: attempted to close file descriptor 158, expected to be unowned,
        // actually owned by ParcelFileDescriptor 0x9e3582d

        // 所以我们要先在这里主动关闭tun.

        if (tun != null) {
            try {
                tun.close();
            } catch (Exception e) {
                Log.w("vs myCloseSelf Exception", e.toString());
                return;
            }
            tun = null;
        }

        if (m != null) {
            m.stop();

        }

    }

    @Override
    public void onDestroy() {

        // 调用 stopSelf 后, onDestroy会被调用

        Log.w("vs destory", "");

        if (broadcastReceiver != null) {
            unregisterReceiver(broadcastReceiver);

        }

        super.onDestroy();
    }

    @Override
    public void onRevoke() {

        Log.w("vs onRevoke", "");

        super.onRevoke();

    }

}
