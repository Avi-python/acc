package com.example.acc

import HomeWidgetGlanceWidgetReceiver

class CounterWidgetReceiver : HomeWidgetGlanceWidgetReceiver<CounterWidget>() {
    override val glanceAppWidget: CounterWidget
        get() = CounterWidget()
}