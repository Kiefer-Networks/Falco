// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.di

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.PreferenceDataStoreFactory
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.preferencesDataStoreFile
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Qualifier
import javax.inject.Singleton

/** Plain non-secret account/UI metadata (account ids, active id, theme). */
@Qualifier
@Retention(AnnotationRetention.BINARY)
annotation class AccountPrefs

/** Per-field ciphertext (base64-Tink-AEAD). Kept on a separate file so the index
 *  store cannot accidentally page in encrypted blobs and vice versa. */
@Qualifier
@Retention(AnnotationRetention.BINARY)
annotation class CredentialsPrefs

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    @AccountPrefs
    fun provideAccountPrefsDataStore(@ApplicationContext context: Context): DataStore<Preferences> =
        PreferenceDataStoreFactory.create(
            produceFile = { context.preferencesDataStoreFile("falco_account_prefs") },
        )

    @Provides
    @Singleton
    @CredentialsPrefs
    fun provideCredentialsDataStore(@ApplicationContext context: Context): DataStore<Preferences> =
        PreferenceDataStoreFactory.create(
            produceFile = { context.preferencesDataStoreFile("falco_credentials_v2") },
        )
}
