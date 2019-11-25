package com.okaythis.okaythis_flutter_plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.fasterxml.jackson.databind.ObjectMapper
import com.itransition.protectoria.psa_multitenant.data.SpaStorage
import com.itransition.protectoria.psa_multitenant.protocol.scenarios.linking.LinkingScenarioListener
import com.itransition.protectoria.psa_multitenant.protocol.scenarios.unlinking.UnlinkingScenarioListener
import com.itransition.protectoria.psa_multitenant.restapi.GatewayRestServer
import com.itransition.protectoria.psa_multitenant.state.ApplicationState
import com.okaythis.okaythis_flutter_plugin.logger.OkaySdkExceptionLogger
import com.okaythis.okaythis_flutter_plugin.storage.SpaStorageImp
import com.protectoria.psa.PsaManager
import com.protectoria.psa.api.PsaConstants
import com.protectoria.psa.api.converters.PsaIntentUtils
import com.protectoria.psa.api.entities.SpaAuthorizationData
import com.protectoria.psa.api.entities.SpaEnrollData
import com.protectoria.psa.dex.common.data.enums.PsaType
import com.protectoria.psa.dex.common.data.json.PsaGsonFactory
import com.protectoria.psa.dex.common.ui.PageTheme
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.PluginRegistry



class OkaythisFlutterPlugin(val activity: Activity, val context: Context) : MethodCallHandler, PluginRegistry.ActivityResultListener {

    private val spaStorage = SpaStorageImp(context)

    fun initPsa(pssEndpoint: String): String {
        val psaManager = PsaManager.init(this.context, OkaySdkExceptionLogger())
        psaManager.setPssAddress(pssEndpoint)
        GatewayRestServer.init(PsaGsonFactory().create(), "$pssEndpoint/gateway/")
        return "PSS endpoint set successfully"
    }

    fun linkTenant(linkingCode: String, spaStorage: SpaStorage, linkingScenarioListener: LinkingScenarioListener) {
        val psaManager = PsaManager.getInstance()
        psaManager.linkTenant(linkingCode, spaStorage, linkingScenarioListener)
    }

    fun startEnrollmentActivity(spaEnrollData: SpaEnrollData) {
        PsaManager.startEnrollmentActivity(this.activity, spaEnrollData)
    }

    fun startAuthorizationActivity(spaAuthorizationData: SpaAuthorizationData) {
        PsaManager.startAuthorizationActivity(this.activity, spaAuthorizationData)
    }

    fun requestRequiredPermissions(): Array<String> {
        return  PsaManager.getRequiredPermissions()
    }

    fun unLinkTenant(tenantId: Int, spaStorage: SpaStorage, unlinkingScenarioListener: UnlinkingScenarioListener) {
        val psaManager = PsaManager.getInstance()
        psaManager.unlinkTenant(tenantId.toLong(), spaStorage, unlinkingScenarioListener)
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "initPsa" -> {
                val pssEndpoint = call.arguments
                initPsa(pssEndpoint.toString()!!).let {
                    Log.d("argument: ", "$it")
                    result.success(it)
                }
            }

            "unLinkTenant" -> {
                val tenantId: Int? = call.argument("tenantId")
                val unlinkingScenarioListener: UnlinkingScenarioListener = object: UnlinkingScenarioListener {
                    override fun onUnlinkingFailed(p0: ApplicationState) {
                        // Notify user linking failed
                        channel.invokeMethod("onUnLinkingHandler", false)
                        Toast.makeText(context, "unlinking not Successful", Toast.LENGTH_SHORT).show()
                        result.success(false)
                    }

                    override fun onUnlinkingCompletedSuccessful() {
                        // Notify user the call was successfull
                        channel.invokeMethod("unOnLinkingHandler", true)
                        Toast.makeText(context, "unlinking Successful", Toast.LENGTH_SHORT).show()
                        result.success(true)
                    }

                }
                unLinkTenant(tenantId!!.toInt(), spaStorage, unlinkingScenarioListener)
            }
            "linkTenant" -> {
                val linkingCode: String? = call.argument("linkingCode")
                val linkingScenarioListener: LinkingScenarioListener? = object: LinkingScenarioListener {
                    override fun onLinkingFailed(p0: ApplicationState?) {
                      // Notify user linking failed
                        channel.invokeMethod("onLinkingHandler", false)
                        Toast.makeText(context, "Linking not Successful: ${p0.toString()}", Toast.LENGTH_SHORT).show()
                        result.success(false)
                    }

                    override fun onLinkingCompletedSuccessful(p0: Long, p1: String?) {
                        // Notify user the call was successfull
                        channel.invokeMethod("onLinkingHandler", true)
                        Toast.makeText(context, "Linking Successful", Toast.LENGTH_SHORT).show()
                        result.success(true)
                    }
                }
                linkTenant(linkingCode!!, spaStorage!!, linkingScenarioListener!!)
            }
            "startEnrollment" -> {

                val appPns: String? = call.argument("appPns")
                val pubPss: String? = call.argument("pubPss")
                val installationId: String? = call.argument("installationId")

                spaStorage.putAppPNS(appPns!!)
                spaStorage.putPubPssBase64(pubPss!!)
                spaStorage.putInstallationId(installationId!!)
                startEnrollmentActivity(SpaEnrollData(appPns,pubPss, installationId, null, PsaType.OKAY))
                result.success(null)
            }
            "startAuthorization" -> {
                val sessionId: Integer? = call.argument("sessionId")
                val appPns: String? = call.argument("appPns")
                val pageTheme: Map<String, Any>? = call.argument("pageTheme")
                var baseTheme = mapTheme(pageTheme!!)
                startAuthorizationActivity(SpaAuthorizationData(sessionId!!.toLong(), appPns, baseTheme, PsaType.OKAY))
                result.success(null)
            }
            "requestRequiredPermissions" -> {
                requestRequiredPermissions().let {
                    result.success(it.toList())
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == PsaConstants.ACTIVITY_REQUEST_CODE_PSA_ENROLL) {
            if (resultCode == AppCompatActivity.RESULT_OK) {
                //We should save data from Enrollment result, for future usage
                data?.run {
                    val resultData = PsaIntentUtils.enrollResultFromIntent(this)
                    resultData.let {
                        spaStorage.putEnrollmentId(it.enrollmentId)
                        spaStorage.putExternalId(it.externalId)
                    }
                    channel.invokeMethod("onEnrollmentHandler", true)
                    Toast.makeText(context,   "Successfully got this externalId " + resultData.externalId, Toast.LENGTH_SHORT).show()
                }
            } else {
                channel.invokeMethod("onEnrollmentHandler", false)
                Toast.makeText(context, "Error Retrieving intent after enrollment:-  errorCode: $resultCode", Toast.LENGTH_SHORT).show()

            }
            return true
        }

        if (requestCode == PsaConstants.ACTIVITY_REQUEST_CODE_PSA_AUTHORIZATION) {
            if (resultCode == AppCompatActivity.RESULT_OK) {
                channel.invokeMethod("onAuthorizationHandler", true)
                Toast.makeText(context, "Authorization granted", Toast.LENGTH_SHORT).show()
            } else {
                channel.invokeMethod("onAuthorizationHandler", false)
                Toast.makeText(context, "Authorization not granted", Toast.LENGTH_SHORT).show()
            }
            return true
        }
        return false
    }

    private fun mapTheme(map: Map<*,*>): PageTheme {
        val mapper = ObjectMapper()
        return mapper.convertValue(parseThemeValues(map), PageTheme::class.java)
    }

    private fun parseThemeValues(map: Map<*, *>): HashMap<Any?, Any?> {
        val hm = HashMap<Any?, Any?>()
        val m: MutableMap<Any?, Any?> = map.toMutableMap()
        val iterator: Iterable<Map.Entry<Any?, Any?>> = m.asIterable()
        for (entry in iterator) {
            hm[entry.key] = Color.parseColor(entry.value as String)
        }
        return hm
    }

    companion object {
        private lateinit var channel: MethodChannel

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            channel = MethodChannel(registrar.messenger(), "okaythis_flutter_plugin")
            val okayFlutterPlugin = OkaythisFlutterPlugin(registrar.activity(), registrar.context())
            registrar.addActivityResultListener(okayFlutterPlugin)
            channel.setMethodCallHandler(okayFlutterPlugin)
        }
    }
}




