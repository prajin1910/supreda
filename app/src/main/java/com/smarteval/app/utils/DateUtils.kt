package com.smarteval.app.utils

import java.text.SimpleDateFormat
import java.util.*

object DateUtils {
    
    private val dateTimeFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())
    private val displayDateFormat = SimpleDateFormat("MMM dd, yyyy", Locale.getDefault())
    private val displayTimeFormat = SimpleDateFormat("HH:mm", Locale.getDefault())
    private val displayDateTimeFormat = SimpleDateFormat("MMM dd, yyyy HH:mm", Locale.getDefault())
    
    fun formatDateTime(dateTimeString: String): String {
        return try {
            val date = dateTimeFormat.parse(dateTimeString)
            date?.let { displayDateTimeFormat.format(it) } ?: dateTimeString
        } catch (e: Exception) {
            dateTimeString
        }
    }
    
    fun formatDate(dateTimeString: String): String {
        return try {
            val date = dateTimeFormat.parse(dateTimeString)
            date?.let { displayDateFormat.format(it) } ?: dateTimeString
        } catch (e: Exception) {
            dateTimeString
        }
    }
    
    fun formatTime(dateTimeString: String): String {
        return try {
            val date = dateTimeFormat.parse(dateTimeString)
            date?.let { displayTimeFormat.format(it) } ?: dateTimeString
        } catch (e: Exception) {
            dateTimeString
        }
    }
    
    fun getCurrentDateTime(): String {
        return dateTimeFormat.format(Date())
    }
    
    fun isOverdue(endDateTime: String): Boolean {
        return try {
            val endDate = dateTimeFormat.parse(endDateTime)
            endDate?.let { it.before(Date()) } ?: false
        } catch (e: Exception) {
            false
        }
    }
    
    fun getTimeRemaining(endDateTime: String): String {
        return try {
            val endDate = dateTimeFormat.parse(endDateTime)
            endDate?.let {
                val now = Date()
                val diff = it.time - now.time
                
                if (diff <= 0) return "Overdue"
                
                val days = diff / (1000 * 60 * 60 * 24)
                val hours = (diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)
                val minutes = (diff % (1000 * 60 * 60)) / (1000 * 60)
                
                when {
                    days > 0 -> "${days}d ${hours}h remaining"
                    hours > 0 -> "${hours}h ${minutes}m remaining"
                    minutes > 0 -> "${minutes}m remaining"
                    else -> "Due now"
                }
            } ?: "Unknown"
        } catch (e: Exception) {
            "Unknown"
        }
    }
}