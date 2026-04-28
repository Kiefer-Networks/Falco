// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.nav

object Routes {
    const val WELCOME = "welcome"
    const val ACCOUNTS = "accounts"
    const val ACCOUNT_NEW = "account_new"
    const val CLOUD = "cloud"
    const val ROBOT = "robot"
    const val ROBOT_SERVER_DETAIL = "robot/server/{number}"
    const val ROBOT_STORAGE_BOX_DETAIL = "robot/storagebox/{id}"
    const val DNS = "dns"
    const val DNS_ZONE_DETAIL = "dns/zone/{id}"
    const val S3 = "s3"
    const val S3_BROWSER = "s3/browser?bucket={bucket}&prefix={prefix}"
    const val SETTINGS = "settings"

    fun robotServerDetail(number: Long) = "robot/server/$number"
    fun robotStorageBoxDetail(id: Long) = "robot/storagebox/$id"
    fun dnsZoneDetail(id: String) = "dns/zone/$id"
    fun s3Browser(bucket: String, prefix: String = ""): String {
        val encodedBucket = java.net.URLEncoder.encode(bucket, "UTF-8")
        val encodedPrefix = java.net.URLEncoder.encode(prefix, "UTF-8")
        return "s3/browser?bucket=$encodedBucket&prefix=$encodedPrefix"
    }

    const val CLOUD_STORAGE_BOX_DETAIL = "cloud/storagebox/{id}"
    fun cloudStorageBoxDetail(id: Long) = "cloud/storagebox/$id"

    const val PROJECTS = "cloud/projects"
    const val PROJECT_NEW = "cloud/projects/new"
    const val PROJECT_EDIT = "cloud/projects/edit/{projectId}"
    fun projectEdit(projectId: String) = "cloud/projects/edit/$projectId"

    const val ARG_SERVER_NUMBER = "number"
    const val ARG_STORAGE_BOX_ID = "id"
    const val ARG_ZONE_ID = "id"
    const val ARG_BUCKET = "bucket"
    const val ARG_PREFIX = "prefix"
    const val ARG_PROJECT_ID = "projectId"
}
