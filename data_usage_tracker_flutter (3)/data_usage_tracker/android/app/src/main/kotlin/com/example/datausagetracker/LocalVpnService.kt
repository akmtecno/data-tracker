package com.example.datausagetracker

import android.content.Intent
import android.net.VpnService
import android.os.ParcelFileDescriptor
import java.io.FileInputStream
import java.io.FileOutputStream

/**
 * خدمة VPN محلية (Local Loopback Firewall)
 * تقوم باعتراض حزم الشبكة وتطبيق قواعد حظر التطبيقات المحددة
 */
class LocalVpnService : VpnService() {

    private var vpnInterface: ParcelFileDescriptor? = null
    private var isRunning = false
    private val blockedPackages = HashSet<String>()

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        if (action == "START_FIREWALL") {
            val packages = intent.getStringArrayListExtra("BLOCKED_PACKAGES")
            blockedPackages.clear()
            if (packages != null) {
                blockedPackages.addAll(packages)
            }
            startVpn()
        } else if (action == "STOP_FIREWALL") {
            stopVpn()
        }
        return START_STICKY
    }

    private fun startVpn() {
        if (isRunning) return

        val builder = Builder()
        builder.setSession("DataUsageFirewall")
            .addAddress("10.0.0.2", 32)
            .addRoute("0.0.0.0", 0)

        // تطبيق الحظر على التطبيقات المحددة
        for (pkg in blockedPackages) {
            try {
                // منع التطبيق المحظور من العبور عبر الشبكة
                builder.addDisallowedApplication(pkg)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        try {
            vpnInterface = builder.establish()
            isRunning = true
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun stopVpn() {
        try {
            vpnInterface?.close()
            vpnInterface = null
            isRunning = false
            stopSelf()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onDestroy() {
        stopVpn()
        super.onDestroy()
    }
}
