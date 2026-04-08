# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }

# In-App Purchase
-keep class com.android.billingclient.** { *; }

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }

# Flame (game engine uses reflection for some components)
-keep class dev.flameengine.** { *; }

# Suppress warnings for missing classes in optional dependencies
-dontwarn com.google.errorprone.**
-dontwarn org.codehaus.mojo.**
