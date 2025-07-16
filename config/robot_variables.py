# -*- coding: utf-8 -*-
"""
Robot Framework Variables
Load từ config.yaml và export cho Robot Framework
"""

import yaml
from pathlib import Path

# Load config
config_file = Path(__file__).parent / "config.yaml"
with open(config_file, 'r', encoding='utf-8') as file:
    config = yaml.safe_load(file)

# Export variables cho Robot Framework
ANDROID_APP_PATH = config['app']['android']['app']
ANDROID_DEVICE_NAME = config['app']['android']['deviceName']
ANDROID_PLATFORM_NAME = config['app']['android']['platformName']
ANDROID_AUTOMATION_NAME = config['app']['android']['automationName']
ANDROID_PLATFORM_VERSION = config['app']['android']['platformVersion']
ANDROID_APP_PACKAGE = config['app']['android']['appPackage']
ANDROID_APP_ACTIVITY = config['app']['android']['appActivity']

# Appium config
APPIUM_HOST = config['appium']['host']
APPIUM_PORT = config['appium']['port'] 