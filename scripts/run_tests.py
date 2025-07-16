#!/usr/bin/env python3.10
# -*- coding: utf-8 -*-
"""
Script chạy tests cho Mobile Automation Project
Cung cấp nhiều tùy chọn để chạy tests
"""

import os
import sys
import argparse
import subprocess
import json
import yaml
from pathlib import Path
from datetime import datetime

class TestRunner:
    """Class để chạy tests với nhiều tùy chọn"""
    
    def __init__(self):
        """Khởi tạo TestRunner"""
        self.project_root = Path(__file__).parent.parent
        self.test_dir = self.project_root / "testcases"
        self.reports_dir = self.project_root / "reports"
        self.logs_dir = self.project_root / "logs"
        
        # Tạo thư mục nếu chưa tồn tại
        self.reports_dir.mkdir(exist_ok=True)
        self.logs_dir.mkdir(exist_ok=True)
    
    def run_tests(self, args):
        """
        Chạy tests với các tham số
        
        Args:
            args: Arguments từ command line
        """
        try:
            # Xây dựng command
            command = self._build_command(args)
            
            print(f"Chạy command: {' '.join(command)}")
            
            # Chạy command
            result = subprocess.run(command, capture_output=True, text=True)
            
            # In output
            if result.stdout:
                print("STDOUT:")
                print(result.stdout)
            
            if result.stderr:
                print("STDERR:")
                print(result.stderr)
            
            # Kiểm tra kết quả
            if result.returncode == 0:
                print("✅ Tests chạy thành công!")
            else:
                print("❌ Tests chạy thất bại!")
                sys.exit(1)
                
        except Exception as e:
            print(f"❌ Lỗi khi chạy tests: {e}")
            sys.exit(1)
    
    def _build_command(self, args):
        """
        Xây dựng command để chạy tests
        
        Args:
            args: Arguments từ command line
            
        Returns:
            list: Command để chạy
        """
        command = ["robot"]
        
        # Output directory
        command.extend(["--outputdir", str(self.reports_dir)])
        
        # Log và report files
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        command.extend([
            "--log", f"robot_log_{timestamp}.html",
            "--report", f"robot_report_{timestamp}.html",
            "--xunit", f"robot_xunit_{timestamp}.xml"
        ])
        
        # Include tags
        if args.include:
            command.extend(["--include", args.include])
        
        # Exclude tags
        if args.exclude:
            command.extend(["--exclude", args.exclude])
        
        # Processes (parallel)
        if args.processes:
            command.extend(["--processes", str(args.processes)])
        
        # Variables
        if args.variables:
            for var in args.variables:
                command.extend(["--variable", var])
        
        # Variable files
        if args.variablefiles:
            for varfile in args.variablefiles:
                command.extend(["--variablefile", varfile])
        
        # Listener
        if args.listener:
            command.extend(["--listener", args.listener])
        
        # Randomize
        if args.randomize:
            command.extend(["--randomize", args.randomize])
        
        # Dry run
        if args.dryrun:
            command.append("--dryrun")
        
        # Test files/directories
        if args.test_files:
            command.extend(args.test_files)
        else:
            command.append(str(self.test_dir))
        
        return command
    
    def run_smoke_tests(self):
        """Chạy smoke tests"""
        print("🔥 Chạy Smoke Tests...")
        args = argparse.Namespace(
            include="smoke",
            exclude=None,
            processes=2,
            variables=[],
            variablefiles=[],
            listener=None,
            randomize=None,
            dryrun=False,
            test_files=[]
        )
        self.run_tests(args)
    
    def run_regression_tests(self):
        """Chạy regression tests"""
        print("🔄 Chạy Regression Tests...")
        args = argparse.Namespace(
            include="regression",
            exclude=None,
            processes=4,
            variables=[],
            variablefiles=[],
            listener=None,
            randomize=None,
            dryrun=False,
            test_files=[]
        )
        self.run_tests(args)
    
    def run_all_tests(self):
        """Chạy tất cả tests"""
        print("🚀 Chạy Tất Cả Tests...")
        args = argparse.Namespace(
            include=None,
            exclude=None,
            processes=4,
            variables=[],
            variablefiles=[],
            listener=None,
            randomize=None,
            dryrun=False,
            test_files=[]
        )
        self.run_tests(args)
    
    def run_specific_tests(self, test_files):
        """Chạy tests cụ thể"""
        print(f"🎯 Chạy Tests Cụ Thể: {test_files}")
        args = argparse.Namespace(
            include=None,
            exclude=None,
            processes=2,
            variables=[],
            variablefiles=[],
            listener=None,
            randomize=None,
            dryrun=False,
            test_files=test_files
        )
        self.run_tests(args)
    
    def generate_allure_report(self):
        """Tạo Allure report"""
        try:
            print("📊 Tạo Allure Report...")
            
            allure_results_dir = self.reports_dir / "allure-results"
            allure_report_dir = self.reports_dir / "allure-report"
            
            # Tạo Allure report
            command = [
                "allure", "generate",
                str(allure_results_dir),
                "-o", str(allure_report_dir),
                "--clean"
            ]
            
            result = subprocess.run(command, capture_output=True, text=True)
            
            if result.returncode == 0:
                print("✅ Allure report đã được tạo thành công!")
                print(f"📁 Report location: {allure_report_dir}")
            else:
                print("❌ Lỗi khi tạo Allure report:")
                print(result.stderr)
                
        except Exception as e:
            print(f"❌ Lỗi khi tạo Allure report: {e}")
    
    def open_allure_report(self):
        """Mở Allure report"""
        try:
            print("🌐 Mở Allure Report...")
            
            allure_report_dir = self.reports_dir / "allure-report"
            
            if allure_report_dir.exists():
                command = ["allure", "open", str(allure_report_dir)]
                subprocess.Popen(command)
                print("✅ Allure report đã được mở!")
            else:
                print("❌ Allure report chưa được tạo. Chạy generate_allure_report() trước.")
                
        except Exception as e:
            print(f"❌ Lỗi khi mở Allure report: {e}")

def main():
    """Main function"""
    parser = argparse.ArgumentParser(description="Mobile Automation Test Runner")
    
    # Test selection
    parser.add_argument("--smoke", action="store_true", help="Chạy smoke tests")
    parser.add_argument("--regression", action="store_true", help="Chạy regression tests")
    parser.add_argument("--all", action="store_true", help="Chạy tất cả tests")
    parser.add_argument("--files", nargs="+", help="Chạy tests cụ thể")
    
    # Test configuration
    parser.add_argument("--include", help="Include tags")
    parser.add_argument("--exclude", help="Exclude tags")
    parser.add_argument("--processes", type=int, help="Số processes để chạy parallel")
    parser.add_argument("--variables", nargs="+", help="Variables")
    parser.add_argument("--variablefiles", nargs="+", help="Variable files")
    parser.add_argument("--listener", help="Listener")
    parser.add_argument("--randomize", help="Randomize tests")
    parser.add_argument("--dryrun", action="store_true", help="Dry run")
    
    # Report
    parser.add_argument("--allure-generate", action="store_true", help="Tạo Allure report")
    parser.add_argument("--allure-open", action="store_true", help="Mở Allure report")
    
    args = parser.parse_args()
    
    runner = TestRunner()
    
    # Chạy tests
    if args.smoke:
        runner.run_smoke_tests()
    elif args.regression:
        runner.run_regression_tests()
    elif args.all:
        runner.run_all_tests()
    elif args.files:
        runner.run_specific_tests(args.files)
    else:
        # Chạy với arguments tùy chỉnh
        runner.run_tests(args)
    
    # Tạo Allure report
    if args.allure_generate:
        runner.generate_allure_report()
    
    # Mở Allure report
    if args.allure_open:
        runner.open_allure_report()

if __name__ == "__main__":
    main() 