package com.okaythis.okaythis_flutter_plugin.storage

import android.content.Context
import android.content.SharedPreferences
import com.itransition.protectoria.psa_multitenant.data.SpaStorage

class SpaStorageImp(context: Context): SpaStorage {

    private val prefStorage: SharedPreferences =
            context.getSharedPreferences(PREFERENCE_KEY, Context.MODE_PRIVATE)


    override fun getPubPssBase64(): String? {
        return prefStorage.getString(PUB_PSS_B64, "")
    }

    override fun putAppPNS(p0: String?) {
        with(prefStorage.edit()) {
            putString(APP_PNS, p0)
            commit()
        }
    }

    override fun putPubPssBase64(p0: String?) {
        with(prefStorage.edit()) {
            putString(PUB_PSS_B64, p0)
            commit()
        }
    }

    override fun getAppPNS(): String? {
        return prefStorage.getString(APP_PNS, "")
    }

    override fun getEnrollmentId(): String? {
        return prefStorage.getString(ENROLLMENT_ID, "")
    }

    override fun putInstallationId(p0: String?) {
        with(prefStorage.edit()) {
            putString(INSTALLATION_ID, p0)
            commit()
        }
    }

    override fun putExternalId(p0: String?) {
        with(prefStorage.edit()) {
            putString(EXTERNAL_ID, p0)
            commit()
        }
    }

    override fun putEnrollmentId(p0: String?) {
        with(prefStorage.edit()) {
            putString(ENROLLMENT_ID, p0)
            commit()
        }
    }

    override fun getInstallationId(): String? {
        return prefStorage.getString(INSTALLATION_ID, "")
    }

    override fun getExternalId(): String? {
        return prefStorage.getString(EXTERNAL_ID, "")
    }

    companion object {
        const val PREFERENCE_KEY = "firebase_instance_id"
        const val APP_PNS = "app_pns"
        const val EXTERNAL_ID = "external_id"
        const val PUB_PSS_B64 = "pub_pss_b64"
        const val ENROLLMENT_ID = "enrollment_id"
        const val INSTALLATION_ID = "installation_id"
    }
}