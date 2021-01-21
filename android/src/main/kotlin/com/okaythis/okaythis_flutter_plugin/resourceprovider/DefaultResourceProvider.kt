package com.okaythis.okaythis_flutter_plugin.resourceprovider

import android.content.Context
import android.text.SpannableStringBuilder
import com.protectoria.psa.dex.common.data.dto.gui_data.OperationType
import com.protectoria.psa.dex.common.data.dto.gui_data.TransactionInfo
import com.protectoria.psa.dex.common.ui.ResourceProvider

class DefaultResourceProvider(private val context: Context): ResourceProvider {

    override fun provideTextForBiometricPromtCancelButton(): String {
        return "Cancel"
    }

    override fun provideTextForEnrollmentDescription(): String {
        return "Please wait.."
    }

    override fun provideScreenshotsNotificationIconId(): Int {
        return 1
    }

    override fun provideTextForFee(): String {
        return "Fee"
    }

    override fun provideScreenshotsChannelName(): String {
        return "securescreenshotchannel"
    }

    override fun provideTextForTransactionDetails(p0: TransactionInfo?): SpannableStringBuilder {
        return SpannableStringBuilder("Details")
    }

    override fun provideTextForBiometricPromtSubTitle(): String {
        return "Biometric Authorisation"
    }

    override fun provideTextForRecipient(): String {
        return "Recipient"
    }

    override fun provideTextForEnrollmentTitle(): String {
        return "Customer enrollment in progress."
    }

    override fun provideTextForConfirmButton(): String {
        return "Confirm"
    }

    override fun provideTextForBiometricPromtDescription(): String {
        return "Please comfirm transaction with biometrics"
    }

    override fun provideScreenshotsNotificationText(): String {
        return "Screenshot notification"
    }

    override fun provideTextForAuthScreenTitle(p0: TransactionInfo?): String? {
        return "Do you authorise this transaction?"
    }

    override fun provideTextForBiometricPromtTitle(): String {
        return "Do you authorize this transaction?"
    }

    override fun provideTextForConfirmBiometricButton(): String {
        return "Authorise with biometric"
    }

    override fun provideTextForPaymentDetailsButton(): String {
        return "View payment details"
    }

    override fun provideTextForAuthorizationProgressView(): String {
        return "Processing..."
    }

    fun getString(stringRes: Int): String {
        return context.getString(stringRes);
    }
}
