#!/usr/bin/env python3.10
# -*- coding: utf-8 -*-
"""
Script kiểm tra Python version và compatibility
"""

import sys
import subprocess
import platform
from pathlib import Path

def check_python_version():
    """Kiểm tra Python version"""
    print("🐍 Python Version Check")
    print("=" * 40)
    
    # Python version
    version = sys.version_info
    print(f"Python Version: {version.major}.{version.minor}.{version.micro}")
    print(f"Platform: {platform.platform()}")
    print(f"Architecture: {platform.architecture()[0]}")
    
    # Kiểm tra version compatibility
    if version.major == 3 and version.minor >= 8:
        print("✅ Python version: COMPATIBLE")
        return True
    else:
        print("❌ Python version: INCOMPATIBLE (Need Python 3.8+)")
        return False

def check_pip():
    """Kiểm tra pip"""
    print("\n📦 Pip Check")
    print("=" * 40)
    
    try:
        result = subprocess.run([sys.executable, '-m', 'pip', '--version'], 
                              capture_output=True, text=True)
        if result.returncode == 0:
            pip_version = result.stdout.strip()
            print(f"✅ Pip: {pip_version}")
            return True
        else:
            print("❌ Pip: NOT AVAILABLE")
            return False
    except Exception as e:
        print(f"❌ Pip: ERROR - {e}")
        return False

def check_virtual_environment():
    """Kiểm tra virtual environment"""
    print("\n🏠 Virtual Environment Check")
    print("=" * 40)
    
    if hasattr(sys, 'real_prefix') or (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix):
        print("✅ Virtual Environment: ACTIVE")
        print(f"   Environment: {sys.prefix}")
        return True
    else:
        print("⚠️  Virtual Environment: NOT ACTIVE")
        print("   Recommendation: Use virtual environment for isolation")
        return False

def check_python_path():
    """Kiểm tra Python path"""
    print("\n📍 Python Path Check")
    print("=" * 40)
    
    print(f"Python Executable: {sys.executable}")
    print(f"Python Path: {sys.path[0]}")
    
    # Kiểm tra các thư mục quan trọng
    important_dirs = [
        Path(sys.executable).parent,
        Path(sys.executable).parent / "Scripts",  # Windows
        Path(sys.executable).parent / "bin",      # Unix
    ]
    
    for dir_path in important_dirs:
        if dir_path.exists():
            print(f"✅ Directory exists: {dir_path}")
        else:
            print(f"⚠️  Directory missing: {dir_path}")

def check_dependencies():
    """Kiểm tra dependencies chính"""
    print("\n📚 Dependencies Check")
    print("=" * 40)
    
    dependencies = [
        'robot',
        'yaml',
        'requests',
        'pandas',
        'selenium',
        'pytest'
    ]
    
    results = []
    for dep in dependencies:
        try:
            __import__(dep)
            print(f"✅ {dep}: INSTALLED")
            results.append(True)
        except ImportError:
            print(f"❌ {dep}: NOT INSTALLED")
            results.append(False)
    
    return all(results)

def check_android_tools():
    """Kiểm tra Android tools"""
    print("\n🤖 Android Tools Check")
    print("=" * 40)
    
    tools = [
        ('adb', 'Android Debug Bridge'),
        ('emulator', 'Android Emulator'),
        ('appium', 'Appium Server')
    ]
    
    results = []
    for tool, description in tools:
        try:
            result = subprocess.run([tool, '--version'], 
                                  capture_output=True, text=True)
            if result.returncode == 0:
                version = result.stdout.strip().split('\n')[0]
                print(f"✅ {description}: {version}")
                results.append(True)
            else:
                print(f"❌ {description}: NOT AVAILABLE")
                results.append(False)
        except FileNotFoundError:
            print(f"❌ {description}: NOT FOUND")
            results.append(False)
    
    return any(results)  # Chỉ cần ít nhất 1 tool

def main():
    """Main function"""
    print("🔧 Mobile Automation Python Environment Check")
    print("=" * 60)
    
    checks = [
        ("Python Version", check_python_version),
        ("Pip", check_pip),
        ("Virtual Environment", check_virtual_environment),
        ("Python Path", check_python_path),
        ("Dependencies", check_dependencies),
        ("Android Tools", check_android_tools)
    ]
    
    results = []
    for name, check_func in checks:
        try:
            result = check_func()
            results.append((name, result))
        except Exception as e:
            print(f"❌ Error in {name}: {e}")
            results.append((name, False))
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 SUMMARY")
    print("=" * 60)
    
    passed = sum(1 for _, result in results if result)
    total = len(results)
    
    for name, result in results:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"{name}: {status}")
    
    print(f"\nOverall: {passed}/{total} checks passed")
    
    if passed >= 4:  # Ít nhất 4/6 checks pass
        print("🎉 Python environment is ready for mobile automation!")
        return True
    else:
        print("⚠️  Some checks failed. Please fix the issues above.")
        return False

if __name__ == "__main__":
    main() 