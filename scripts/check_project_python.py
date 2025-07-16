#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script kiểm tra Python version và cấu hình trong project
"""

import sys
import subprocess
import os
from pathlib import Path

def check_current_python():
    """Kiểm tra Python version hiện tại"""
    print("🐍 Current Python Environment")
    print("=" * 50)
    
    print(f"Python Executable: {sys.executable}")
    print(f"Python Version: {sys.version}")
    print(f"Python Path: {sys.path[0]}")
    
    # Kiểm tra virtual environment
    if hasattr(sys, 'real_prefix') or (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix):
        print("✅ Virtual Environment: ACTIVE")
        print(f"   Environment: {sys.prefix}")
    else:
        print("⚠️  Virtual Environment: NOT ACTIVE")
    
    return sys.version_info

def check_available_python_versions():
    """Kiểm tra các Python versions có sẵn"""
    print("\n🔍 Available Python Versions")
    print("=" * 50)
    
    versions = ['python', 'python3', 'python3.8', 'python3.9', 'python3.10', 'python3.11', 'python3.12']
    available_versions = []
    
    for version in versions:
        try:
            result = subprocess.run([version, '--version'], 
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                version_info = result.stdout.strip()
                print(f"✅ {version}: {version_info}")
                available_versions.append(version)
            else:
                print(f"❌ {version}: NOT FOUND")
        except (FileNotFoundError, subprocess.TimeoutExpired):
            print(f"❌ {version}: NOT FOUND")
    
    return available_versions

def check_pip_versions():
    """Kiểm tra pip versions"""
    print("\n📦 Pip Versions")
    print("=" * 50)
    
    pip_commands = ['pip', 'pip3', 'pip3.10']
    
    for pip_cmd in pip_commands:
        try:
            result = subprocess.run([pip_cmd, '--version'], 
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                pip_version = result.stdout.strip()
                print(f"✅ {pip_cmd}: {pip_version}")
            else:
                print(f"❌ {pip_cmd}: NOT FOUND")
        except (FileNotFoundError, subprocess.TimeoutExpired):
            print(f"❌ {pip_cmd}: NOT FOUND")

def check_robot_framework():
    """Kiểm tra Robot Framework"""
    print("\n🤖 Robot Framework Check")
    print("=" * 50)
    
    try:
        result = subprocess.run(['robot', '--version'], 
                              capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            robot_version = result.stdout.strip()
            print(f"✅ Robot Framework: {robot_version}")
            return True
        else:
            print("❌ Robot Framework: NOT INSTALLED")
            return False
    except FileNotFoundError:
        print("❌ Robot Framework: NOT FOUND")
        return False

def check_project_dependencies():
    """Kiểm tra dependencies của project"""
    print("\n📚 Project Dependencies")
    print("=" * 50)
    
    dependencies = [
        'robot',
        'yaml',
        'requests',
        'pandas',
        'selenium',
        'pytest',
        'appium'
    ]
    
    results = []
    for dep in dependencies:
        try:
            module = __import__(dep)
            if hasattr(module, '__version__'):
                print(f"✅ {dep}: {module.__version__}")
            else:
                print(f"✅ {dep}: INSTALLED")
            results.append(True)
        except ImportError:
            print(f"❌ {dep}: NOT INSTALLED")
            results.append(False)
    
    return results

def check_makefile_python_commands():
    """Kiểm tra Python commands trong Makefile"""
    print("\n🔧 Makefile Python Commands")
    print("=" * 50)
    
    makefile_path = Path("Makefile")
    if makefile_path.exists():
        with open(makefile_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        python_commands = []
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if 'python' in line and not line.strip().startswith('#'):
                python_commands.append(f"Line {i+1}: {line.strip()}")
        
        if python_commands:
            print("Python commands found in Makefile:")
            for cmd in python_commands:
                print(f"  {cmd}")
        else:
            print("No Python commands found in Makefile")
    else:
        print("❌ Makefile not found")

def check_script_shebangs():
    """Kiểm tra shebang lines trong scripts"""
    print("\n📜 Script Shebang Lines")
    print("=" * 50)
    
    scripts_dir = Path("scripts")
    if scripts_dir.exists():
        for script_file in scripts_dir.glob("*.py"):
            try:
                with open(script_file, 'r', encoding='utf-8') as f:
                    first_line = f.readline().strip()
                    if first_line.startswith('#!'):
                        print(f"✅ {script_file.name}: {first_line}")
                    else:
                        print(f"⚠️  {script_file.name}: No shebang line")
            except Exception as e:
                print(f"❌ {script_file.name}: Error reading file - {e}")
    else:
        print("❌ Scripts directory not found")

def main():
    """Main function"""
    print("🔧 Project Python Environment Analysis")
    print("=" * 60)
    
    # Kiểm tra Python hiện tại
    current_version = check_current_python()
    
    # Kiểm tra các Python versions có sẵn
    available_versions = check_available_python_versions()
    
    # Kiểm tra pip
    check_pip_versions()
    
    # Kiểm tra Robot Framework
    robot_ok = check_robot_framework()
    
    # Kiểm tra dependencies
    deps_results = check_project_dependencies()
    
    # Kiểm tra Makefile
    check_makefile_python_commands()
    
    # Kiểm tra script shebangs
    check_script_shebangs()
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 SUMMARY")
    print("=" * 60)
    
    print(f"Current Python: {current_version.major}.{current_version.minor}.{current_version.micro}")
    print(f"Available Python versions: {len(available_versions)}")
    print(f"Robot Framework: {'✅ OK' if robot_ok else '❌ NOT FOUND'}")
    print(f"Dependencies installed: {sum(deps_results)}/{len(deps_results)}")
    
    # Recommendations
    print("\n💡 RECOMMENDATIONS")
    print("=" * 60)
    
    if current_version.major == 3 and current_version.minor >= 8:
        print("✅ Python version is compatible")
    else:
        print("❌ Python version is too old. Need Python 3.8+")
    
    if 'python3.10' in available_versions:
        print("✅ Python 3.10 is available")
    else:
        print("⚠️  Python 3.10 not found. Consider installing it.")
    
    if robot_ok:
        print("✅ Robot Framework is ready")
    else:
        print("❌ Install Robot Framework: pip install robotframework")
    
    if sum(deps_results) == len(deps_results):
        print("✅ All dependencies are installed")
    else:
        print("⚠️  Some dependencies are missing. Run: pip install -r requirements.txt")

if __name__ == "__main__":
    main() 