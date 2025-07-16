# Mobile App Automation Testing Project

## Tổng quan
Project automation test cho mobile app sử dụng Robot Framework, Python và Gherkin với cấu trúc chuyên nghiệp, dễ maintain và mở rộng.

## Công nghệ sử dụng
- **Robot Framework**: Framework chính cho automation testing
- **Python**: Ngôn ngữ lập trình
- **Appium**: Mobile automation framework
- **Gherkin**: BDD (Behavior Driven Development)
- **Pytest**: Unit testing
- **Allure**: Báo cáo test

## Cấu trúc project
```
mobile-automation/
├── config/                 # Cấu hình
├── resources/              # Resources Robot Framework
├── testcases/             # Test cases
├── pageobjects/           # Page Object Model
├── keywords/              # Custom keywords
├── data/                  # Test data
├── reports/               # Báo cáo test
├── logs/                  # Log files
├── screenshots/           # Screenshots
├── requirements.txt       # Python dependencies
├── robot.yaml            # Robot Framework config
└── README.md
```

## Cài đặt và chạy

### Yêu cầu hệ thống
- Python 3.8+
- Node.js (cho Appium)
- Android SDK hoặc Xcode (cho iOS)

### Cài đặt dependencies
```bash
pip install -r requirements.txt
npm install -g appium
```

### Chạy test
```bash
# Chạy tất cả test
robot testcases/

# Chạy test với tags cụ thể
robot --include smoke testcases/

# Chạy test với parallel
robot --processes 4 testcases/

# Chạy test với report chi tiết
robot --outputdir reports/ --listener allure_robotframework testcases/
```

## Cấu hình
- `config/config.yaml`: Cấu hình chung
- `config/devices.yaml`: Cấu hình thiết bị
- `config/environments.yaml`: Cấu hình môi trường

## Báo cáo
- Allure reports: `reports/allure-results/`
- Robot reports: `reports/`

## Best Practices
- Sử dụng Page Object Model
- Tách biệt test data và test logic
- Sử dụng Gherkin cho BDD
- Logging chi tiết
- Screenshot khi test fail
- Parallel execution
- CI/CD integration

## Contributing
1. Fork project
2. Tạo feature branch
3. Commit changes
4. Push to branch
5. Tạo Pull Request 