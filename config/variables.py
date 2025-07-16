# -*- coding: utf-8 -*-
"""
Variables cho Robot Framework
Định nghĩa các biến toàn cục cho project
"""

import os
import yaml
from pathlib import Path

# Đường dẫn gốc của project
PROJECT_ROOT = Path(__file__).parent.parent
CONFIG_FILE = PROJECT_ROOT / "config" / "config.yaml"

# Load cấu hình từ file YAML
def load_config():
    """Load cấu hình từ file YAML"""
    with open(CONFIG_FILE, 'r', encoding='utf-8') as file:
        return yaml.safe_load(file)

config = load_config()

# ============================================================================
# APP CONFIGURATION
# ============================================================================

# Appium Server
APPIUM_HOST = config['appium']['host']
APPIUM_PORT = config['appium']['port']
APPIUM_PATH = config['appium']['path']
APPIUM_TIMEOUT = config['appium']['timeout']

# Android Configuration
ANDROID_PLATFORM_NAME = config['app']['android']['platformName']
ANDROID_AUTOMATION_NAME = config['app']['android']['automationName']
ANDROID_DEVICE_NAME = config['app']['android']['deviceName']
ANDROID_PLATFORM_VERSION = config['app']['android']['platformVersion']
ANDROID_APP_PATH = config['app']['android']['app']
ANDROID_NO_RESET = config['app']['android']['noReset']
ANDROID_FULL_RESET = config['app']['android']['fullReset']

# iOS Configuration
IOS_PLATFORM_NAME = config['app']['ios']['platformName']
IOS_AUTOMATION_NAME = config['app']['ios']['automationName']
IOS_DEVICE_NAME = config['app']['ios']['deviceName']
IOS_PLATFORM_VERSION = config['app']['ios']['platformVersion']
IOS_APP_PATH = config['app']['ios']['app']
IOS_NO_RESET = config['app']['ios']['noReset']
IOS_FULL_RESET = config['app']['ios']['fullReset']

# ============================================================================
# TEST CONFIGURATION
# ============================================================================

# Timeouts
IMPLICIT_TIMEOUT = config['test']['timeout']['implicit']
EXPLICIT_TIMEOUT = config['test']['timeout']['explicit']
PAGE_LOAD_TIMEOUT = config['test']['timeout']['pageLoad']

# Retry Configuration
MAX_RETRY_ATTEMPTS = config['test']['retry']['max_attempts']
RETRY_DELAY = config['test']['retry']['delay']

# Screenshot Configuration
SCREENSHOT_ON_FAILURE = config['test']['screenshot']['on_failure']
SCREENSHOT_ON_SUCCESS = config['test']['screenshot']['on_success']
SCREENSHOT_DIRECTORY = config['test']['screenshot']['directory']

# Video Configuration
RECORD_VIDEO = config['test']['video']['record']
VIDEO_DIRECTORY = config['test']['video']['directory']

# ============================================================================
# ENVIRONMENT CONFIGURATION
# ============================================================================

# Lấy environment từ biến môi trường hoặc mặc định là 'dev'
ENVIRONMENT = os.getenv('ENVIRONMENT', 'dev')

# Environment specific variables
ENV_CONFIG = config['environments'][ENVIRONMENT]
BASE_URL = ENV_CONFIG['base_url']
TEST_USERNAME = ENV_CONFIG['username']
TEST_PASSWORD = ENV_CONFIG['password']

# ============================================================================
# REPORTING CONFIGURATION
# ============================================================================

# Allure Configuration
ALLURE_ENABLED = config['reporting']['allure']['enabled']
ALLURE_RESULTS_DIR = config['reporting']['allure']['results_dir']
ALLURE_REPORT_DIR = config['reporting']['allure']['report_dir']

# Robot Framework Configuration
ROBOT_ENABLED = config['reporting']['robot']['enabled']
ROBOT_OUTPUT_DIR = config['reporting']['robot']['output_dir']

# Email Configuration
EMAIL_ENABLED = config['reporting']['email']['enabled']
SMTP_SERVER = config['reporting']['email']['smtp_server']
SMTP_PORT = config['reporting']['email']['smtp_port']
SENDER_EMAIL = config['reporting']['email']['sender_email']
SENDER_PASSWORD = config['reporting']['email']['sender_password']

# ============================================================================
# LOGGING CONFIGURATION
# ============================================================================

LOG_LEVEL = config['logging']['level']
LOG_FORMAT = config['logging']['format']
LOG_FILE = config['logging']['file']
LOG_MAX_SIZE = config['logging']['max_size']
LOG_BACKUP_COUNT = config['logging']['backup_count']

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

# Directories
REPORTS_DIR = PROJECT_ROOT / "reports"
LOGS_DIR = PROJECT_ROOT / "logs"
SCREENSHOTS_DIR = PROJECT_ROOT / "screenshots"
VIDEOS_DIR = PROJECT_ROOT / "videos"
DATA_DIR = PROJECT_ROOT / "data"
APPS_DIR = PROJECT_ROOT / "apps"

# Tạo thư mục nếu chưa tồn tại
for directory in [REPORTS_DIR, LOGS_DIR, SCREENSHOTS_DIR, VIDEOS_DIR, DATA_DIR, APPS_DIR]:
    directory.mkdir(exist_ok=True)

# ============================================================================
# TEST DATA PATHS
# ============================================================================

TEST_DATA_FILE = DATA_DIR / "test_data.json"
USER_DATA_FILE = DATA_DIR / "user_data.yaml"
API_DATA_FILE = DATA_DIR / "api_data.yaml"

# ============================================================================
# BROWSER CONFIGURATION (cho web testing nếu cần)
# ============================================================================

BROWSER_NAME = "chrome"
BROWSER_HEADLESS = False
BROWSER_WINDOW_SIZE = "1920x1080"

# ============================================================================
# API CONFIGURATION
# ============================================================================

API_BASE_URL = BASE_URL
API_TIMEOUT = 30
API_RETRY_COUNT = 3

# ============================================================================
# MOBILE SPECIFIC VARIABLES
# ============================================================================

# Swipe Configuration
SWIPE_DURATION = 1000
SWIPE_PERCENT = 0.8

# Tap Configuration
TAP_DURATION = 100

# Wait Configuration
WAIT_FOR_ELEMENT_TIMEOUT = 10
WAIT_FOR_PAGE_LOAD_TIMEOUT = 30

# ============================================================================
# CUSTOM VARIABLES
# ============================================================================

# Test Tags
SMOKE_TAG = "smoke"
REGRESSION_TAG = "regression"
SANITY_TAG = "sanity"
CRITICAL_TAG = "critical"

# Test Priorities
PRIORITY_HIGH = "high"
PRIORITY_MEDIUM = "medium"
PRIORITY_LOW = "low"

# Test Categories
CATEGORY_LOGIN = "login"
CATEGORY_REGISTRATION = "registration"
CATEGORY_NAVIGATION = "navigation"
CATEGORY_PAYMENT = "payment" 