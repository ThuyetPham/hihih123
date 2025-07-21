@echo off
REM ========================================
REM Robot Framework Test Runner
REM ========================================

echo Starting Robot Framework Tests...
echo.

REM Kiểm tra Python và Robot Framework
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python not found!
    pause
    exit /b 1
)

robot --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Robot Framework not found!
    pause
    exit /b 1
)

REM Tạo thư mục output nếu chưa có
if not exist "reports" mkdir reports

REM Chạy tests với timestamp
set TIMESTAMP=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%

echo Running tests with timestamp: %TIMESTAMP%
echo.

REM Chạy tests
robot -T -d reports -i thuyet123 testcases

REM Kiểm tra kết quả
if errorlevel 1 (
    echo.
    echo Tests FAILED!
    echo Check reports in reports/ directory
) else (
    echo.
    echo Tests PASSED!
)

echo.
echo Press any key to open reports...
pause >nul

REM Mở report nếu có
if exist "reports\report.html" (
    start reports\report.html
)

echo Done! 