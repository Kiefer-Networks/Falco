# Falco ProGuard / R8 rules
# SPDX-License-Identifier: GPL-3.0-or-later

# DTOs are covered by the kotlinx-serialization rules below; the explicit
# `-keep class data.dto.**` we used to ship was redundant and prevented R8
# from shrinking unused fields on those classes.
#
# R8 9.x (AGP 9.0+) tightened -keepattributes wildcard semantics: bare
# `*Annotation*` no longer matches RuntimeInvisible* annotations. Enumerate
# every annotation attribute we depend on explicitly so kotlinx-serialization,
# Retrofit, and Hilt all keep their generators' annotations after shrink.
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations, RuntimeVisibleTypeAnnotations
-keepattributes RuntimeInvisibleAnnotations, RuntimeInvisibleParameterAnnotations, RuntimeInvisibleTypeAnnotations
-keepattributes AnnotationDefault, InnerClasses, Signature, Exceptions, EnclosingMethod
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

# Hilt — narrowed from blanket `dagger.hilt.**`; kept only runtime SPI surface.
# Hilt ships its own consumer-rules.pro covering most of dagger.hilt internals;
# we only need to preserve the entry points and the generated `Hilt_*` /
# `*_Factory` classes that the runtime resolves by string. Everything else is
# safe for R8 to obfuscate.
-keep,allowobfuscation class * extends dagger.hilt.EntryPoint
-keep,allowobfuscation class * extends dagger.hilt.android.HiltAndroidApp
-keep,allowobfuscation class * extends dagger.hilt.android.AndroidEntryPoint
-keep class dagger.hilt.internal.GeneratedComponent { *; }
-keep class dagger.hilt.android.internal.managers.** { *; }
-keep class * implements dagger.hilt.internal.GeneratedComponent { *; }
-keep class **_HiltModules { *; }
-keep class **_HiltModules$* { *; }
-keep class **_HiltComponents { *; }
-keep class **_HiltComponents$* { *; }
-keep class **_GeneratedInjector { *; }
-keep class **_Provide*Factory { *; }
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

# Tink — uses reflection on registered key managers + protobuf schemas.
# Tink 1.10+ ships consumer-rules.pro that handles most of this; the
# -dontwarn entries below catch generated protobuf-lite + reflective config.
-dontwarn com.google.crypto.tink.**
-dontwarn com.google.protobuf.**
-keep class com.google.crypto.tink.proto.** { *; }

# androidx.security.crypto — kept here as a transitional dep used only by the
# v1 -> v2 EncryptedSharedPreferences -> Tink/DataStore migration shim. Drop
# in v2.1 once the migration window closes.
-dontwarn androidx.security.crypto.**

# Keep crash-relevant line numbers, hide source filename
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
