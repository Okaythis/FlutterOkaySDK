package com.okaythis.okaythis_flutter_plugin.psatheme

import android.content.Context
import android.graphics.Color
import com.okaythis.okaythis_flutter_plugin.R
import com.protectoria.psa.dex.common.ui.PageTheme

class BaseTheme(context: Context) {

    val DEFAULT_PAGE_THEME: PageTheme = PageTheme()

    init {
        context.let {
            DEFAULT_PAGE_THEME.apply {
//                actionBarBackgroundColor = it.getColor(R.color.primaryDarkColor)
//                actionBarTextColor = it.getColor(R.color.primaryTextColor)
//                screenBackgroundColor = it.getColor(R.color.primaryColor)
//                buttonBackgroundColor = it.getColor(R.color.secondaryColor)
//                buttonTextColor = it.getColor(R.color.secondaryTextColor)
//
//                pinNumberButtonTextColor = it.getColor(R.color.secondaryTextColor)
//                pinNumberButtonBackgroundColor = it.getColor(R.color.secondaryLightColor)
//                pinRemoveButtonBackgroundColor = it.getColor(R.color.secondaryLightColor)
//                pinRemoveButtonTextColor = it.getColor(R.color.secondaryTextColor)
//                pinTitleTextColor = it.getColor(R.color.primaryTextColor)
//                pinValueTextColor = it.getColor(R.color.primaryTextColor)
//
//                titleTextColor = it.getColor(R.color.primaryTextColor)
//                questionMarkColor = it.getColor(R.color.primaryLightColor)
//                transactionTypeTextColor = it.getColor(R.color.primaryTextColor)
//
//                authInfoBackgroundColor = it.getColor(R.color.transaction_info_background)
//                infoSectionTitleColor = it.getColor(R.color.secondaryLightColor)
//                infoSectionValueColor = it.getColor(R.color.secondaryTextColor)
//                fromTextColor = it.getColor(R.color.secondaryTextColor)
//                messageTextColor = it.getColor(R.color.secondaryTextColor)
//
                confirmButtonBackgroundColor = Color.BLUE
                confirmButtonTextColor = Color.RED
                cancelButtonBackgroundColor = Color.GREEN
                cancelButtonTextColor = Color.argb(1, 222, 245,10)
                authConfirmationButtonBackgroundColor = Color.argb(1, 225, 255, 255)

//                authConfirmationButtonBackgroundColor = it.getColor(R.color.secondaryColor)
//                authConfirmationButtonTextColor = it.getColor(R.color.secondaryTextColor)
//                authCancellationButtonBackgroundColor = it.getColor(R.color.primaryColor)
//                authCancellationButtonTextColor = it.getColor(R.color.primaryTextColor)
//
//                nameTextColor = it.getColor(R.color.secondaryTextColor)
//
//                buttonBackgroundColor = it.getColor(R.color.primaryLightColor)
//                buttonTextColor = it.getColor(R.color.primaryTextColor)
//                inputTextColor = it.getColor(R.color.secondaryTextColor)
                inputSelectionColor = Color.GREEN
                inputErrorColor = Color.RED
                inputDefaultColor = Color.GRAY
            }
        }

    }
}