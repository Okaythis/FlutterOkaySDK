package com.okaythis.okaythis_flutter_plugin.logger

import android.util.Log
import com.protectoria.psa.dex.common.utils.logger.ExceptionLogger
import java.lang.Exception

class OkaySdkExceptionLogger: ExceptionLogger  {

    private val TAG = "EXCEPTION_LOGGER"
    override fun setUserIdentificator(p0: String?) {
       Log.d(TAG, "$p0")
    }

    override fun exception(p0: String?, p1: Exception?) {
       Log.d(TAG, "$p0")
    }
}