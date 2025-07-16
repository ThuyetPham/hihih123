#!/usr/bin/env python3.10
# -*- coding: utf-8 -*-
"""
Script kiểm tra môi trường cho Mobile Automation
Kiểm tra các dependencies và thiết bị trước khi chạy tests
"""

import os
import sys
import subprocess
import json
import yaml
from pathlib import Path

class EnvironmentChecker:
    """Class kiểm tra môi trường"""
    
    def __init__(self):
        """Khởi tạo EnvironmentChecker"""
        self.project_root = Path(__file__).parent.parent
        self.config_file = self.project_root / "config" / "config.yaml"
        
    def check_python_dependencies(self):
        """Kiểm tra Python dependencies"""
        print("🔍 Kiểm tra Python dependencies...")
        
        try:
            import robot
            print("✅ Robot Framework: OK")
        except ImportError:
            print("❌ Robot Framework: NOT INSTALLED")
            return False
            
        try:
            import yaml
            print("✅ PyYAML: OK")
        except ImportError:
            print("❌ PyYAML: NOT INSTALLED")
            return False
            
        try:
            import requests
            print("✅ Requests: OK")
        except ImportError:
            print("❌ Requests: NOT INSTALLED")
            return False
            
        try:
            import pandas
            print("✅ Pandas: OK")
        except ImportError:
            print("❌ Pandas: NOT INSTALLED")
            return False
            
        return True
    
    def check_appium(self):
        """Kiểm tra Appium"""
        print("\n🔍 Kiểm tra Appium...")
        
        try:
            result = subprocess.run(['appium', '--version'], 
                                  capture_output=True, text=True)
            if result.returncode == 0:
                version = result.stdout.strip()
                print(f"✅ Appium: {version}")
                return True
            else:
                print("❌ Appium: NOT INSTALLED")
                return False
        except FileNotFoundError:
            print("❌ Appium: NOT FOUND")
            return False
    
    def check_android_sdk(self):
        """Kiểm tra Android SDK"""
        print("\n🔍 Kiểm tra Android SDK...")
        
        try:
            result = subprocess.run(['adb', 'version'], 
                                  capture_output=True, text=True)
            if result.returncode == 0:
                version = result.stdout.split('\n')[0]
                print(f"✅ ADB: {version}")
                return True
            else:
                print("❌ ADB: NOT INSTALLED")
                return False
        except FileNotFoundError:
            print("❌ ADB: NOT FOUND")
            return False
    
    def check_emulator(self):
        """Kiểm tra emulator"""
        print("\n🔍 Kiểm tra Android Emulator...")
        
        try:
            result = subprocess.run(['emulator', '-list-avds'], 
                                  capture_output=True, text=True)
            if result.returncode == 0:
                avds = result.stdout.strip().split('\n')
                if avds and avds[0]:
                    print("✅ Android Emulator AVDs:")
                    for avd in avds:
                        if avd:
                            print(f"   - {avd}")
                    return True
                else:
                    print("❌ No Android Virtual Devices found")
                    return False
            else:
                print("❌ Emulator: NOT INSTALLED")
                return False
        except FileNotFoundError:
            print("❌ Emulator: NOT FOUND")
            return False
    
    def check_connected_devices(self):
        """Kiểm tra thiết bị đã kết nối"""
        print("\n🔍 Kiểm tra thiết bị đã kết nối...")
        
        try:
            result = subprocess.run(['adb', 'devices'], 
                                  capture_output=True, text=True)
            if result.returncode == 0:
                lines = result.stdout.strip().split('\n')[1:]
                devices = []
                for line in lines:
                    if line.strip() and '\t' in line:
                        device_id, status = line.split('\t')
                        devices.append((device_id, status))
                
                if devices:
                    print("✅ Connected devices:")
                    for device_id, status in devices:
                        print(f"   - {device_id} ({status})")
                    return True
                else:
                    print("❌ No devices connected")
                    return False
            else:
                print("❌ Cannot check devices")
                return False
        except FileNotFoundError:
            print("❌ ADB not found")
            return False
    
    def check_appium_server(self):
        """Kiểm tra Appium server"""
        print("\n🔍 Kiểm tra Appium server...")
        
        try:
            import requests
            response = requests.get('http://127.0.0.1:4723/status', timeout=5)
            if response.status_code == 200:
                print("✅ Appium server: RUNNING")
                return True
            else:
                print("❌ Appium server: NOT RESPONDING")
                return False
        except requests.exceptions.RequestException:
            print("❌ Appium server: NOT RUNNING")
            return False
    
    def check_config_files(self):
        """Kiểm tra config files"""
        print("\n🔍 Kiểm tra config files...")
        
        config_files = [
            "config/config.yaml",
            "config/variables.py",
            "requirements.txt",
            "robot.yaml"
        ]
        
        all_exist = True
        for file_path in config_files:
            full_path = self.project_root / file_path
            if full_path.exists():
                print(f"✅ {file_path}: EXISTS")
            else:
                print(f"❌ {file_path}: MISSING")
                all_exist = False
        
        return all_exist
    
    def check_test_files(self):
        """Kiểm tra test files"""
        print("\n🔍 Kiểm tra test files...")
        
        test_files = [
            "testcases/LoginTest.robot",
            "testcases/SimpleTest.robot",
            "keywords/MobileKeywords.py",
            "keywords/LoginKeywords.py",
            "pageobjects/BasePage.py",
            "pageobjects/LoginPage.py"
        ]
        
        all_exist = True
        for file_path in test_files:
            full_path = self.project_root / file_path
            if full_path.exists():
                print(f"✅ {file_path}: EXISTS")
            else:
                print(f"❌ {file_path}: MISSING")
                all_exist = False
        
        return all_exist
    
    def start_emulator(self, avd_name):
        """Khởi động emulator"""
        print(f"\n🚀 Khởi động emulator: {avd_name}")
        
        try:
            # Khởi động emulator trong background
            subprocess.Popen(['emulator', '-avd', avd_name, '-no-snapshot-load'])
            print("✅ Emulator đang khởi động...")
            print("⏳ Vui lòng chờ 30-60 giây để emulator khởi động hoàn toàn")
            return True
        except FileNotFoundError:
            print("❌ Emulator command not found")
            return False
    
    def start_appium_server(self):
        """Khởi động Appium server"""
        print("\n🚀 Khởi động Appium server...")
        
        try:
            # Khởi động Appium trong background
            subprocess.Popen(['appium', '--log', 'appium.log'])
            print("✅ Appium server đang khởi động...")
            print("⏳ Vui lòng chờ 10-15 giây để server khởi động")
            return True
        except FileNotFoundError:
            print("❌ Appium command not found")
            return False
    
    def run_environment_check(self):
        """Chạy kiểm tra môi trường đầy đủ"""
        print("🔧 Mobile Automation Environment Check")
        print("=" * 50)
        
        checks = [
            ("Python Dependencies", self.check_python_dependencies),
            ("Appium", self.check_appium),
            ("Android SDK", self.check_android_sdk),
            ("Emulator", self.check_emulator),
            ("Connected Devices", self.check_connected_devices),
            ("Config Files", self.check_config_files),
            ("Test Files", self.check_test_files)
        ]
        
        results = []
        for name, check_func in checks:
            try:
                result = check_func()
                results.append((name, result))
            except Exception as e:
                print(f"❌ Error checking {name}: {e}")
                results.append((name, False))
        
        # Summary
        print("\n" + "=" * 50)
        print("📊 SUMMARY")
        print("=" * 50)
        
        passed = sum(1 for _, result in results if result)
        total = len(results)
        
        for name, result in results:
            status = "✅ PASS" if result else "❌ FAIL"
            print(f"{name}: {status}")
        
        print(f"\nOverall: {passed}/{total} checks passed")
        
        if passed == total:
            print("🎉 Environment is ready for testing!")
            return True
        else:
            print("⚠️  Some checks failed. Please fix the issues above.")
            return False
    
    def setup_environment(self):
        """Thiết lập môi trường"""
        print("\n🔧 Setting up environment...")
        
        # Tạo thư mục cần thiết
        directories = ['reports', 'logs', 'screenshots', 'videos', 'data', 'apps']
        for directory in directories:
            dir_path = self.project_root / directory
            dir_path.mkdir(exist_ok=True)
            print(f"✅ Created directory: {directory}")
        
        # Cài đặt dependencies
        try:
            subprocess.run([sys.executable, '-m', 'pip', 'install', '-r', 'requirements.txt'], 
                         check=True, capture_output=True)
            print("✅ Dependencies installed")
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to install dependencies: {e}")
            return False
        
        return True

def main():
    """Main function"""
    checker = EnvironmentChecker()
    
    if len(sys.argv) > 1:
        command = sys.argv[1]
        
        if command == "check":
            checker.run_environment_check()
        elif command == "setup":
            checker.setup_environment()
        elif command == "start-emulator":
            if len(sys.argv) > 2:
                avd_name = sys.argv[2]
                checker.start_emulator(avd_name)
            else:
                print("Usage: python check_environment.py start-emulator <AVD_NAME>")
        elif command == "start-appium":
            checker.start_appium_server()
        else:
            print("Unknown command. Available commands: check, setup, start-emulator, start-appium")
    else:
        # Default: run full check
        checker.run_environment_check()

if __name__ == "__main__":
    main() 