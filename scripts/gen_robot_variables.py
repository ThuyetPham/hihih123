import yaml
from pathlib import Path

CONFIG_PATH = Path(__file__).parent.parent / 'config' / 'config.yaml'
OUTPUT_PATH = Path(__file__).parent.parent / 'config' / 'robot_variables.txt'

with open(CONFIG_PATH, 'r', encoding='utf-8') as f:
    config = yaml.safe_load(f)

android = config['app']['android']

variables = [
    f'${{ANDROID_APP_PATH}}    {android["app"]}',
    f'${{ANDROID_DEVICE_NAME}}    {android["deviceName"]}',
    f'${{ANDROID_PLATFORM_NAME}}    {android["platformName"]}',
    f'${{ANDROID_AUTOMATION_NAME}}    {android["automationName"]}',
    f'${{ANDROID_PLATFORM_VERSION}}    {android["platformVersion"]}',
]

with open(OUTPUT_PATH, 'w', encoding='utf-8') as f:
    f.write('*** Variables ***\n')
    for var in variables:
        f.write(var + '\n')

print(f'Đã sinh file biến Robot Framework: {OUTPUT_PATH}') 