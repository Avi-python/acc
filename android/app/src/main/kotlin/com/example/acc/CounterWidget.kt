package com.example.acc

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition
import androidx.core.content.edit
import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.glance.Button
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.action.ActionParameters
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.*
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.text.Text
import androidx.glance.currentState
import android.os.Handler
import android.os.Looper
import androidx.core.net.toUri
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetPlugin

class CounterWidget: GlanceAppWidget() {

   override val stateDefinition : GlanceStateDefinition<*>?
       get() = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            GlanceContent(context, currentState())
        }
    }

    @Composable
    private fun GlanceContent(context: Context, currentState: HomeWidgetGlanceState) {
        val counter = currentState.preferences.getInt("counter", 0)
        Box(modifier = GlanceModifier.background(Color.White).fillMaxSize()) {
            Column (
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .fillMaxHeight()
                    .padding(8.dp)
                    .padding(top = 16.dp),
                verticalAlignment = Alignment.Vertical.CenterVertically,
                horizontalAlignment = Alignment.Horizontal.CenterHorizontally
            ){
                Text(
                    text = counter.toString()
                )
                Row (
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .fillMaxHeight(),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Box (
                        modifier = GlanceModifier
                            .fillMaxWidth()
                            .fillMaxHeight()
                            .defaultWeight()
                            .padding(8.dp),
                    ){
                        Button(
                            text = "4",
                            onClick = actionRunCallback<SubOneActionCallBack>(),
                            modifier = GlanceModifier
                                .fillMaxWidth()
                                .fillMaxHeight()
                        )
                    }
                    Box (
                        modifier = GlanceModifier
                            .fillMaxWidth()
                            .fillMaxHeight()
                            .defaultWeight()
                            .padding(8.dp),
                    ){
                        Button(
                            text = "3",
                            onClick = actionRunCallback<AddHundActionCallBack>(),
                            modifier = GlanceModifier
                                .fillMaxWidth()
                                .fillMaxHeight()
                        )
                    }
                    Box (
                        modifier = GlanceModifier
                            .fillMaxWidth()
                            .fillMaxHeight()
                            .defaultWeight()
                            .padding(8.dp),
                    ){
                        Button(
                            text = "2",
                            onClick = actionRunCallback<AddTenActionCallBack>(),
                            modifier = GlanceModifier
                                .fillMaxWidth()
                                .fillMaxHeight()
                        )
                    }
                    Box (
                        modifier = GlanceModifier
                            .fillMaxWidth()
                            .fillMaxHeight()
                            .defaultWeight()
                            .padding(8.dp),
                    ){
                        Button(
                            text = "1",
                            onClick = actionRunCallback<AddOneActionCallBack>(),
                            modifier = GlanceModifier
                                .fillMaxWidth()
                                .fillMaxHeight()
                        )
                    }
                }
            }
        }
    }

    companion object {
        private var timerHandler: Handler? = null
        private var timerRunnable: Runnable? = null

        fun resetTimer(context: Context, GlancId: GlanceId) {
            timerHandler?.removeCallbacks(timerRunnable!!)

            val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                context,
                "counter://timeout".toUri()
            )

            timerRunnable = Runnable {
                backgroundIntent.send()
            }

            timerHandler = Handler(Looper.getMainLooper())
            timerHandler?.postDelayed(timerRunnable!!, 2000)
        }
    }
}

class SubOneActionCallBack : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val currentCount = prefs.getInt("counter", 0)
        prefs.edit(commit = true) { putInt("counter", currentCount - 1) }

        CounterWidget().update(context, glanceId)
        CounterWidget.resetTimer(context, glanceId)
    }
}
class AddHundActionCallBack : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val currentCount = prefs.getInt("counter", 0)
        prefs.edit(commit = true) { putInt("counter", currentCount + 100) }

        CounterWidget().update(context, glanceId)
        CounterWidget.resetTimer(context, glanceId)
    }
}
class AddTenActionCallBack : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val currentCount = prefs.getInt("counter", 0)
        prefs.edit(commit = true) { putInt("counter", currentCount + 10) }

        CounterWidget().update(context, glanceId)
        CounterWidget.resetTimer(context, glanceId)
    }
}
class AddOneActionCallBack : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val currentCount = prefs.getInt("counter", 0)
        prefs.edit(commit = true) { putInt("counter", currentCount + 1) }

        CounterWidget().update(context, glanceId)
        CounterWidget.resetTimer(context, glanceId)
    }
}


