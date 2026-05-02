// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.foundation.ExperimentalFoundationApi::class)
package de.kiefer_networks.falco.ui.screens.s3

import android.content.ContentValues
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.provider.OpenableColumns
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.InsertDriveFile
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Folder
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.UploadFile
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExtendedFloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.AlertDialog
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.api.S3Client
import de.kiefer_networks.falco.data.s3.UploadService
import de.kiefer_networks.falco.ui.components.dialog.TypeToConfirmDeleteDialog
import java.io.File
import java.io.FileOutputStream
import java.io.OutputStream
import java.text.DateFormat
import java.util.Date

@Composable
fun ObjectBrowserScreen(
    onBack: () -> Unit,
    onNavigateToPrefix: (bucket: String, prefix: String) -> Unit,
    viewModel: ObjectBrowserViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    val event by viewModel.events.collectAsState()
    val context = LocalContext.current

    var menuOpenForKey by rememberSaveable { mutableStateOf<String?>(null) }
    var shareDialogKey by rememberSaveable { mutableStateOf<String?>(null) }
    var shareDialogUrl by rememberSaveable { mutableStateOf<String?>(null) }
    var deleteConfirmKey by rememberSaveable { mutableStateOf<String?>(null) }

    // Multi-select state. Stored as a SnapshotStateList for cheap reads inside
    // each row Composable (set membership read; hash-based contains).
    val selected = remember { mutableStateListOf<String>() }
    var multiDeleteOpen by rememberSaveable { mutableStateOf(false) }

    // Copy / Move: picking destinations.
    var copySourceKey by rememberSaveable { mutableStateOf<String?>(null) }
    var moveSourceKey by rememberSaveable { mutableStateOf<String?>(null) }

    // Info sheet state.
    var infoOpenForKey by rememberSaveable { mutableStateOf<String?>(null) }
    var infoStat by remember { mutableStateOf<ObjectStat?>(null) }
    var infoError by remember { mutableStateOf<String?>(null) }

    val openDocLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.OpenDocument(),
    ) { uri: Uri? ->
        if (uri != null) {
            val resolver = context.contentResolver
            val displayName = resolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)?.use { c ->
                if (c.moveToFirst()) c.getString(0) else null
            } ?: uri.lastPathSegment?.substringAfterLast('/')
            val fileName = displayName ?: "upload"
            val key = if (viewModel.prefix.isBlank()) fileName else "${viewModel.prefix.trimEnd('/')}/$fileName"
            val mime = resolver.getType(uri) ?: "application/octet-stream"

            val intent = Intent(context, UploadService::class.java).apply {
                putExtra(UploadService.EXTRA_BUCKET, viewModel.bucket)
                putExtra(UploadService.EXTRA_KEY, key)
                putExtra(UploadService.EXTRA_SOURCE_URI, uri)
                putExtra(UploadService.EXTRA_MIME, mime)
            }
            ContextCompat.startForegroundService(context, intent)
        }
    }

    LaunchedEffect(event) {
        when (val e = event) {
            is ObjectBrowserEvent.ShareLinkReady -> {
                if (e.key == shareDialogKey) shareDialogUrl = e.url
            }
            is ObjectBrowserEvent.ShareLinkFailed -> {
                Toast.makeText(context, context.getString(R.string.error) + ": " + e.message, Toast.LENGTH_LONG).show()
                shareDialogKey = null
                shareDialogUrl = null
            }
            is ObjectBrowserEvent.DeleteSucceeded -> { /* refreshed by VM */ }
            is ObjectBrowserEvent.DeleteFailed ->
                Toast.makeText(context, context.getString(R.string.error) + ": " + e.message, Toast.LENGTH_LONG).show()
            is ObjectBrowserEvent.DownloadSucceeded ->
                Toast.makeText(context, context.getString(R.string.s3_download_saved), Toast.LENGTH_LONG).show()
            is ObjectBrowserEvent.DownloadFailed ->
                Toast.makeText(context, context.getString(R.string.error) + ": " + e.message, Toast.LENGTH_LONG).show()
            is ObjectBrowserEvent.MultiDeleteSucceeded -> {
                Toast.makeText(
                    context,
                    context.getString(R.string.s3_multi_delete_succeeded, e.count),
                    Toast.LENGTH_LONG,
                ).show()
                selected.clear()
                multiDeleteOpen = false
            }
            is ObjectBrowserEvent.MultiDeleteFailed -> {
                Toast.makeText(
                    context,
                    context.getString(R.string.s3_multi_delete_failed) + ": " + e.message,
                    Toast.LENGTH_LONG,
                ).show()
                multiDeleteOpen = false
            }
            is ObjectBrowserEvent.CopySucceeded -> {
                Toast.makeText(context, context.getString(R.string.s3_copy_succeeded), Toast.LENGTH_SHORT).show()
                copySourceKey = null
            }
            is ObjectBrowserEvent.CopyFailed -> {
                Toast.makeText(
                    context,
                    context.getString(R.string.s3_copy_failed) + ": " + e.message,
                    Toast.LENGTH_LONG,
                ).show()
            }
            is ObjectBrowserEvent.MoveSucceeded -> {
                Toast.makeText(context, context.getString(R.string.s3_move_succeeded), Toast.LENGTH_SHORT).show()
                moveSourceKey = null
            }
            is ObjectBrowserEvent.MoveFailed -> {
                Toast.makeText(
                    context,
                    context.getString(R.string.s3_move_failed) + ": " + e.message,
                    Toast.LENGTH_LONG,
                ).show()
            }
            is ObjectBrowserEvent.StatLoaded -> {
                if (e.stat.key == infoOpenForKey) {
                    infoStat = e.stat
                    infoError = null
                }
            }
            is ObjectBrowserEvent.StatFailed -> {
                infoError = e.message
            }
            null -> Unit
        }
        if (event != null) viewModel.consumeEvent()
    }

    val inSelectionMode = selected.isNotEmpty()

    Box(Modifier.fillMaxSize()) {
        Column(Modifier.fillMaxSize()) {
            if (inSelectionMode) {
                SelectionAppBar(
                    count = selected.size,
                    onClear = { selected.clear() },
                    onDelete = { multiDeleteOpen = true },
                )
            } else {
                Row(
                    Modifier.fillMaxWidth().padding(horizontal = 8.dp, vertical = 8.dp),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                    }
                    Column(Modifier.padding(start = 4.dp)) {
                        Text(
                            text = viewModel.bucket,
                            style = MaterialTheme.typography.titleMedium,
                            maxLines = 1,
                            overflow = TextOverflow.Ellipsis,
                        )
                        if (viewModel.prefix.isNotBlank()) {
                            Text(
                                text = "/" + viewModel.prefix.trimEnd('/'),
                                style = MaterialTheme.typography.bodySmall,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis,
                            )
                        }
                    }
                }
            }

            when {
                state.loading -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    CircularProgressIndicator()
                }
                state.error != null -> Box(
                    Modifier.fillMaxSize().padding(24.dp),
                    contentAlignment = Alignment.Center,
                ) { Text(state.error!!) }
                state.objects.isEmpty() -> Box(
                    Modifier.fillMaxSize().padding(24.dp),
                    contentAlignment = Alignment.Center,
                ) { Text(stringResource(R.string.empty_list)) }
                else -> LazyColumn(Modifier.fillMaxSize().padding(horizontal = 12.dp)) {
                    items(state.objects, key = { it.key }) { obj ->
                        if (obj.isDir) {
                            DirRow(
                                obj = obj,
                                parentPrefix = viewModel.prefix,
                                onClick = {
                                    if (inSelectionMode) {
                                        // Directories aren't selectable — tap navigates as usual.
                                        // We swallow long-press on dirs too via DirRow not exposing it.
                                    }
                                    onNavigateToPrefix(viewModel.bucket, obj.key)
                                },
                            )
                        } else {
                            val isSelected = selected.contains(obj.key)
                            FileRow(
                                obj = obj,
                                parentPrefix = viewModel.prefix,
                                selected = isSelected,
                                inSelectionMode = inSelectionMode,
                                menuExpanded = menuOpenForKey == obj.key,
                                onTap = {
                                    if (inSelectionMode) {
                                        if (isSelected) selected.remove(obj.key) else selected.add(obj.key)
                                    }
                                },
                                onLongPress = {
                                    if (!isSelected) selected.add(obj.key)
                                },
                                onMenuToggle = {
                                    menuOpenForKey = if (menuOpenForKey == obj.key) null else obj.key
                                },
                                onShare = {
                                    menuOpenForKey = null
                                    shareDialogKey = obj.key
                                    shareDialogUrl = null
                                },
                                onDownload = {
                                    menuOpenForKey = null
                                    val fileName = obj.key.substringAfterLast('/')
                                    val mime = guessMime(fileName)
                                    val out = openDownloadStream(context, fileName, mime)
                                    if (out != null) {
                                        viewModel.download(obj.key, out)
                                    } else {
                                        Toast.makeText(
                                            context,
                                            context.getString(R.string.error),
                                            Toast.LENGTH_LONG,
                                        ).show()
                                    }
                                },
                                onDelete = {
                                    menuOpenForKey = null
                                    deleteConfirmKey = obj.key
                                },
                                onCopy = {
                                    menuOpenForKey = null
                                    copySourceKey = obj.key
                                },
                                onMove = {
                                    menuOpenForKey = null
                                    moveSourceKey = obj.key
                                },
                                onInfo = {
                                    menuOpenForKey = null
                                    infoOpenForKey = obj.key
                                    infoStat = null
                                    infoError = null
                                    viewModel.loadStat(obj.key)
                                },
                            )
                        }
                    }
                }
            }
        }

        if (!inSelectionMode) {
            ExtendedFloatingActionButton(
                onClick = { openDocLauncher.launch(arrayOf("*/*")) },
                icon = { Icon(Icons.Filled.UploadFile, contentDescription = null) },
                text = { Text(stringResource(R.string.s3_upload)) },
                modifier = Modifier.align(Alignment.BottomEnd).padding(24.dp),
            )
        }
    }

    val keyForDialog = shareDialogKey
    if (keyForDialog != null) {
        ShareLinkDialog(
            objectKey = keyForDialog,
            generatedUrl = shareDialogUrl,
            onConfirmTtl = { hours -> viewModel.share(keyForDialog, hours) },
            onDismiss = {
                shareDialogKey = null
                shareDialogUrl = null
            },
        )
    }

    val deleteKey = deleteConfirmKey
    if (deleteKey != null) {
        AlertDialog(
            onDismissRequest = { deleteConfirmKey = null },
            title = { Text(stringResource(R.string.s3_delete_confirm_title)) },
            text = {
                Text(stringResource(R.string.s3_delete_confirm_msg, deleteKey.substringAfterLast('/')))
            },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.delete(deleteKey)
                    deleteConfirmKey = null
                }) { Text(stringResource(R.string.delete)) }
            },
            dismissButton = {
                TextButton(onClick = { deleteConfirmKey = null }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
    }

    if (multiDeleteOpen) {
        val count = selected.size
        // The confirm phrase is fixed and contains the live count; the dialog
        // uses it both as the warning copy reference and as the text the user
        // must type verbatim.
        val phrase = stringResource(R.string.s3_multi_delete_confirm_phrase, count)
        TypeToConfirmDeleteDialog(
            title = stringResource(R.string.s3_multi_delete_title, count),
            warning = stringResource(R.string.s3_multi_delete_warning, count),
            confirmName = phrase,
            confirmButtonLabel = stringResource(R.string.delete),
            onConfirm = {
                viewModel.deleteMany(selected.toList())
            },
            onDismiss = { multiDeleteOpen = false },
        )
    }

    copySourceKey?.let { src ->
        CopyMoveDialog(
            titleRes = R.string.s3_copy_dest_title,
            confirmLabelRes = R.string.s3_action_copy,
            sourceBucket = viewModel.bucket,
            sourceKey = src,
            onDismiss = { copySourceKey = null },
            onConfirm = { dstBucket, dstKey ->
                viewModel.copyTo(src, dstBucket, dstKey)
            },
        )
    }

    moveSourceKey?.let { src ->
        CopyMoveDialog(
            titleRes = R.string.s3_move_dest_title,
            confirmLabelRes = R.string.s3_action_move,
            sourceBucket = viewModel.bucket,
            sourceKey = src,
            onDismiss = { moveSourceKey = null },
            onConfirm = { dstBucket, dstKey ->
                viewModel.moveTo(src, dstBucket, dstKey)
            },
        )
    }

    infoOpenForKey?.let { key ->
        ObjectInfoSheet(
            objectKey = key,
            stat = infoStat?.takeIf { it.key == key },
            error = infoError,
            onDismiss = {
                infoOpenForKey = null
                infoStat = null
                infoError = null
            },
        )
    }
}

@Composable
private fun SelectionAppBar(count: Int, onClear: () -> Unit, onDelete: () -> Unit) {
    Row(
        Modifier
            .fillMaxWidth()
            .background(MaterialTheme.colorScheme.surfaceVariant)
            .padding(horizontal = 8.dp, vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        IconButton(onClick = onClear) {
            Icon(Icons.Filled.Close, contentDescription = stringResource(R.string.s3_action_clear_selection))
        }
        Text(
            text = stringResource(R.string.s3_select_mode_title, count),
            style = MaterialTheme.typography.titleMedium,
            modifier = Modifier.weight(1f).padding(start = 4.dp),
        )
        IconButton(onClick = onDelete) {
            Icon(
                Icons.Filled.Delete,
                contentDescription = stringResource(R.string.s3_action_delete_selected),
                tint = MaterialTheme.colorScheme.error,
            )
        }
    }
}

@Composable
private fun DirRow(
    obj: S3Client.S3ObjectMeta,
    parentPrefix: String,
    onClick: () -> Unit,
) {
    val displayName = displayName(obj.key, parentPrefix).ifEmpty { obj.key }
    Card(
        Modifier.fillMaxWidth().padding(vertical = 4.dp).clickable(onClick = onClick),
    ) {
        Row(
            Modifier.padding(12.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Icon(Icons.Filled.Folder, contentDescription = null)
            Text(
                text = displayName.trimEnd('/'),
                style = MaterialTheme.typography.titleMedium,
                modifier = Modifier.padding(start = 12.dp),
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
            )
        }
    }
}

@Composable
private fun FileRow(
    obj: S3Client.S3ObjectMeta,
    parentPrefix: String,
    selected: Boolean,
    inSelectionMode: Boolean,
    menuExpanded: Boolean,
    onTap: () -> Unit,
    onLongPress: () -> Unit,
    onMenuToggle: () -> Unit,
    onShare: () -> Unit,
    onDownload: () -> Unit,
    onDelete: () -> Unit,
    onCopy: () -> Unit,
    onMove: () -> Unit,
    onInfo: () -> Unit,
) {
    val displayName = displayName(obj.key, parentPrefix).ifEmpty { obj.key }
    val rowModifier = Modifier
        .fillMaxWidth()
        .padding(vertical = 4.dp)
        .combinedClickable(
            onClick = onTap,
            onLongClick = onLongPress,
        )
    val cardColors = if (selected) {
        androidx.compose.material3.CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.secondaryContainer,
        )
    } else {
        androidx.compose.material3.CardDefaults.cardColors()
    }
    Card(modifier = rowModifier, colors = cardColors) {
        Row(
            Modifier.padding(12.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Icon(Icons.AutoMirrored.Filled.InsertDriveFile, contentDescription = null)
            Column(
                Modifier.padding(start = 12.dp).weight(1f),
            ) {
                Text(
                    text = displayName,
                    style = MaterialTheme.typography.titleSmall,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
                val secondary = buildString {
                    append(humanSize(obj.size))
                    obj.lastModified?.let {
                        append(" • ")
                        append(formatLastModified(it))
                    }
                }
                Text(text = secondary, style = MaterialTheme.typography.bodySmall)
            }
            // The overflow menu is hidden in selection mode to keep the row's
            // tap surface unambiguous (toggle vs. open menu).
            if (!inSelectionMode) {
                Box {
                    IconButton(onClick = onMenuToggle) {
                        Icon(Icons.Filled.MoreVert, contentDescription = null)
                    }
                    DropdownMenu(expanded = menuExpanded, onDismissRequest = onMenuToggle) {
                        DropdownMenuItem(
                            text = { Text(stringResource(R.string.s3_action_info)) },
                            onClick = onInfo,
                        )
                        DropdownMenuItem(
                            text = { Text(stringResource(R.string.s3_share_link)) },
                            onClick = onShare,
                        )
                        DropdownMenuItem(
                            text = { Text(stringResource(R.string.s3_download)) },
                            onClick = onDownload,
                        )
                        DropdownMenuItem(
                            text = { Text(stringResource(R.string.s3_action_copy_to)) },
                            onClick = onCopy,
                        )
                        DropdownMenuItem(
                            text = { Text(stringResource(R.string.s3_action_move_to)) },
                            onClick = onMove,
                        )
                        DropdownMenuItem(
                            text = { Text(stringResource(R.string.delete)) },
                            onClick = onDelete,
                        )
                    }
                }
            }
        }
    }
}

private fun displayName(key: String, parentPrefix: String): String {
    val stripped = if (parentPrefix.isNotEmpty() && key.startsWith(parentPrefix)) {
        key.removePrefix(parentPrefix)
    } else {
        key
    }
    return stripped.trimEnd('/').substringAfterLast('/')
}

private fun humanSize(bytes: Long): String {
    if (bytes < 1024) return "$bytes B"
    val kb = bytes / 1024.0
    if (kb < 1024) return String.format("%.1f KB", kb)
    val mb = kb / 1024.0
    if (mb < 1024) return String.format("%.1f MB", mb)
    val gb = mb / 1024.0
    return String.format("%.2f GB", gb)
}

private fun formatLastModified(raw: String): String {
    // MinIO returns a ZonedDateTime#toString() — we just trim noise for the
    // overview row; if the fancy format fails, fall back to the raw value.
    return runCatching {
        val instant = java.time.OffsetDateTime.parse(raw).toInstant()
        DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.SHORT).format(Date.from(instant))
    }.getOrDefault(raw)
}

private fun guessMime(name: String): String =
    java.net.URLConnection.guessContentTypeFromName(name) ?: "application/octet-stream"

/**
 * Opens an [OutputStream] backed by the public Downloads collection. On Q+
 * we use [MediaStore]; on older APIs we fall back to the legacy Downloads
 * directory (no extra permission needed for app-private data within the
 * shared dir on those versions, which Android still allows via FileOutputStream
 * because we're writing to the user-visible Downloads folder using the
 * pre-scoped-storage path).
 */
private fun openDownloadStream(
    context: android.content.Context,
    name: String,
    mime: String,
): OutputStream? {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        val resolver = context.contentResolver
        val values = ContentValues().apply {
            put(MediaStore.Downloads.DISPLAY_NAME, name)
            put(MediaStore.Downloads.MIME_TYPE, mime)
            put(MediaStore.Downloads.IS_PENDING, 1)
        }
        val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values) ?: return null
        val out = resolver.openOutputStream(uri) ?: return null
        // Wrap so we clear IS_PENDING once the stream closes.
        object : OutputStream() {
            override fun write(b: Int) = out.write(b)
            override fun write(b: ByteArray) = out.write(b)
            override fun write(b: ByteArray, off: Int, len: Int) = out.write(b, off, len)
            override fun flush() = out.flush()
            override fun close() {
                out.close()
                val update = ContentValues().apply { put(MediaStore.Downloads.IS_PENDING, 0) }
                resolver.update(uri, update, null, null)
            }
        }
    } else {
        @Suppress("DEPRECATION")
        val dir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        if (!dir.exists()) dir.mkdirs()
        FileOutputStream(File(dir, name))
    }
}
