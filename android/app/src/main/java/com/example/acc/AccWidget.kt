package com.example.acc

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
/**
 * Implementation of App Widget functionality.
 */
private const val ACTION_WIDGET_INC = "com.example.acc.action.INCREMENT"
class AccWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.acc_widget).apply {
                val title = widgetData.getInt("counter", 0).toString();
                setTextViewText(R.id.appwidget_text, title);

                val intent = Intent(context, AccWidget::class.java);
                intent.action = ACTION_WIDGET_INC;

                val pendingIntent = PendingIntent.getBroadcast(
                    context,
                    0, // A request code
                    intent,
                    // Use FLAG_IMMUTABLE for security and FLAG_UPDATE_CURRENT to ensure the intent is fresh.
                    PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
                )

                // 3. Set the click listener on the button to fire the broadcast.
                // Replace R.id.widget_button_refresh with your actual button ID in the XML layout.
                setOnClickPendingIntent(R.id.button2, pendingIntent)

            }

            appWidgetManager.updateAppWidget(appWidgetId, views);
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        // Check if the received broadcast is our custom action
        if (intent.action == ACTION_WIDGET_INC) {
            // --- HANDLE THE BUTTON CLICK IN THE BACKGROUND ---
            println("Widget refresh button clicked!")

            val widgetData = HomeWidgetPlugin.getData(context)
            var counter = widgetData.getInt("counter", 0)

            // Increment the counter
            counter++
            val editor = widgetData.edit()
            editor.putInt("counter", counter)
            editor.apply()

            // Trigger an update for the widget to redraw it
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisAppWidget = android.content.ComponentName(context, AccWidget::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(thisAppWidget)
            onUpdate(context, appWidgetManager, appWidgetIds)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val widgetText = context.getString(R.string.appwidget_text)
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.acc_widget)
    views.setTextViewText(R.id.appwidget_text, widgetText)

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}