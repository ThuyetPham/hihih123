# Mobile Automation Project Makefile
# Cung cấp các lệnh tiện ích để quản lý project

.PHONY: help install setup test smoke regression all clean report allure

# Default target
help:
	@echo "Mobile Automation Project - Available Commands:"
	@echo ""
	@echo "Setup & Installation:"
	@echo "  install     - Cài đặt dependencies"
	@echo "  setup       - Thiết lập môi trường"
	@echo ""
	@echo "Testing:"
	@echo "  test        - Chạy tất cả tests"
	@echo "  smoke       - Chạy smoke tests"
	@echo "  regression  - Chạy regression tests"
	@echo "  parallel    - Chạy tests với parallel execution"
	@echo ""
	@echo "Reporting:"
	@echo "  report      - Tạo Robot Framework report"
	@echo "  allure      - Tạo Allure report"
	@echo "  open-allure - Mở Allure report"
	@echo ""
	@echo "Maintenance:"
	@echo "  clean       - Xóa files tạm thời"
	@echo "  lint        - Chạy linting"
	@echo "  format      - Format code"
	@echo ""

# Installation
install:
	@echo "Installing dependencies..."
	python3.10 -m pip install -r requirements.txt
	npm install -g appium
	@echo "✅ Dependencies installed successfully!"

setup:
	@echo "Setting up environment..."
	mkdir -p reports logs screenshots videos data apps
	@echo "✅ Environment setup completed!"

# Testing
test:
	@echo "Running all tests..."
	python3.10 scripts/run_tests.py --all

smoke:
	@echo "Running smoke tests..."
	python3.10 scripts/run_tests.py --smoke

regression:
	@echo "Running regression tests..."
	python3.10 scripts/run_tests.py --regression

parallel:
	@echo "Running tests in parallel..."
	python3.10 scripts/run_tests.py --all --processes 4

# Platform specific tests
test-android:
	@echo "Running Android tests..."
	python3.10 scripts/run_tests.py --all --include "android"

test-ios:
	@echo "Running iOS tests..."
	python3.10 scripts/run_tests.py --all --include "ios"

# Specific test files
test-login:
	@echo "Running login tests..."
	python3.10 scripts/run_tests.py --files testcases/LoginTest.robot

# Reporting
report:
	@echo "Generating Robot Framework report..."
	robot --outputdir reports testcases/

allure:
	@echo "Generating Allure report..."
	python3.10 scripts/run_tests.py --allure-generate

open-allure:
	@echo "Opening Allure report..."
	python3.10 scripts/run_tests.py --allure-open

# Code quality
lint:
	@echo "Running linting..."
	python3.10 -m flake8 .
	python3.10 -m black --check .
	python3.10 -m isort --check-only .
	python3.10 -m mypy . --ignore-missing-imports

format:
	@echo "Formatting code..."
	python3.10 -m black .
	python3.10 -m isort .

# Maintenance
clean:
	@echo "Cleaning temporary files..."
	rm -rf __pycache__/
	rm -rf .pytest_cache/
	rm -rf reports/
	rm -rf logs/
	rm -rf screenshots/
	rm -rf videos/
	rm -rf allure-results/
	rm -rf allure-report/
	find . -name "*.pyc" -delete
	find . -name "*.log" -delete
	@echo "✅ Cleanup completed!"

# Development
dev-setup:
	@echo "Setting up development environment..."
	pip install -r requirements.txt
	pip install flake8 black isort mypy
	npm install -g appium
	mkdir -p reports logs screenshots videos data apps
	@echo "✅ Development environment setup completed!"

# CI/CD helpers
ci-test:
	@echo "Running CI tests..."
	python scripts/run_tests.py --all --processes 4
	python scripts/run_tests.py --allure-generate

ci-report:
	@echo "Generating CI reports..."
	python scripts/run_tests.py --allure-generate

# Docker helpers (if using Docker)
docker-build:
	@echo "Building Docker image..."
	docker build -t mobile-automation .

docker-run:
	@echo "Running tests in Docker..."
	docker run --rm mobile-automation

# Helpers
check-appium:
	@echo "Checking Appium installation..."
	appium --version

check-android:
	@echo "Checking Android SDK..."
	adb devices

check-ios:
	@echo "Checking iOS Simulator..."
	xcrun simctl list devices

check-env:
	@echo "Checking environment..."
	python3.10 scripts/check_environment.py check

setup-env:
	@echo "Setting up environment..."
	python3.10 scripts/check_environment.py setup

start-emulator:
	@echo "Starting emulator..."
	@read -p "Enter AVD name: " avd_name; \
	python3.10 scripts/check_environment.py start-emulator $$avd_name

start-appium:
	@echo "Starting Appium server..."
	python3.10 scripts/check_environment.py start-appium

test-simple:
	@echo "Running simple test on emulator..."
	python3.10 -m robot --outputdir reports testcases/SimpleTest.robot

check-python:
	@echo "Checking Python environment..."
	python3.10 scripts/check_python.py

# Documentation
docs:
	@echo "Generating documentation..."
	python -m pydoc -w .
	@echo "✅ Documentation generated!"

# Security
security-scan:
	@echo "Running security scan..."
	bandit -r . -f json -o bandit-report.json
	safety check --json --output safety-report.json
	@echo "✅ Security scan completed!"

# Performance
performance-test:
	@echo "Running performance tests..."
	python scripts/run_tests.py --all --processes 8
	@echo "✅ Performance tests completed!"

# Backup
backup:
	@echo "Creating backup..."
	tar -czf backup-$(shell date +%Y%m%d_%H%M%S).tar.gz \
		--exclude=reports \
		--exclude=logs \
		--exclude=screenshots \
		--exclude=videos \
		--exclude=__pycache__ \
		--exclude=.git \
		.
	@echo "✅ Backup created!"

# Restore
restore:
	@echo "Restoring from backup..."
	@read -p "Enter backup file name: " backup_file; \
	tar -xzf $$backup_file
	@echo "✅ Restore completed!"

# Environment variables
export-env:
	@echo "Setting environment variables..."
	export ENVIRONMENT=dev
	export PLATFORM=android
	@echo "✅ Environment variables set!"

# Quick start
quick-start: install setup
	@echo "Quick start completed!"
	@echo "Next steps:"
	@echo "1. Start Appium server: appium"
	@echo "2. Run tests: make smoke"
	@echo "3. View reports: make report"

# Default target
.DEFAULT_GOAL := help 