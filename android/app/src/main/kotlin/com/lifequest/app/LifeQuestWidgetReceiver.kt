package com.lifequest.app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class LifeQuestWidgetReceiver : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                
                // Get data from Flutter through HomeWidget
                val characterName = widgetData.getString("characterName", "용사")
                val characterLevel = widgetData.getInt("characterLevel", 1)
                val characterHp = widgetData.getInt("characterHp", 100)
                
                // Update UI elements
                setTextViewText(R.id.tv_widget_title, "$characterName (Lv.$characterLevel)")
                setTextViewText(R.id.tv_widget_hp, "HP: $characterHp")
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
