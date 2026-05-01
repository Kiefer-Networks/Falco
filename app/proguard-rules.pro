# Falco ProGuard / R8 rules
# SPDX-License-Identifier: GPL-3.0-or-later

# DTOs are covered by the kotlinx-serialization rules below; the explicit
# `-keep class data.dto.**` we used to ship was redundant and prevented R8
# from shrinking unused fields on those classes.
-keepattributes *Annotation*, InnerClasses, Signature, Exceptions, EnclosingMethod
-keepclassmembers class **$Companion { *; }

# kotlinx.serialization
-keepclassmembers class **$$serializer { *; }
-keepclasseswithmembers class * {
    @kotlinx.serialization.Serializable <methods>;
}
-if @kotlinx.serialization.Serializable class **
-keepclassmembers class <1> {
    static <1>$Companion Companion;
}
-if @kotlinx.serialization.Serializable class ** { static **$Companion Companion; }
-keepclassmembers class <2>$Companion {
    kotlinx.serialization.KSerializer serializer(...);
}

# Retrofit
-keepattributes Signature, Exceptions
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation
-dontwarn retrofit2.**
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**

# MinIO / S3 SDK
# MinIO uses Simple-XML annotations on its message DTOs and reflects on them
# (constructors + annotated fields) for request/response (de)serialization.
# Names may be obfuscated; the annotated members must remain.
-keep,allowobfuscation class io.minio.messages.** { *; }
-keepclassmembers class io.minio.messages.** {
    <init>(...);
}
# Simple-XML reflects on annotated fields/methods to (de)serialize.
-keep class org.simpleframework.xml.** { *; }
-dontwarn io.minio.**
-dontwarn org.bouncycastle.**
-dontwarn org.simpleframework.xml.**
-dontwarn javax.xml.stream.**
-dontwarn com.fasterxml.jackson.**

# Hilt
# Kept conservatively: Hilt generates components/entry points reflected on at
# runtime by the Hilt entry-point lookup and Dagger SPI. The library ships a
# consumer-rules.pro, but the generated `Hilt_*` wrappers in app code aren't
# covered there in all setups. Leaving broad until verified against a release
# build.
-keep class dagger.hilt.** { *; }
-keep class * extends dagger.hilt.android.internal.managers.ViewComponentManager$FragmentContextWrapper { *; }

# Strip log calls in release
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
    public static int e(...);
    public static int wtf(...);
    public static int println(...);
}

# Keep crash-relevant line numbers, hide source filename
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
