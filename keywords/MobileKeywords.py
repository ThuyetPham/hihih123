# -*- coding: utf-8 -*-
"""
Mobile Keywords cho Robot Framework
Cung cấp các keywords cho mobile automation testing
"""

import time
import logging
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from AppiumLibrary import AppiumLibrary

class MobileKeywords:
    """
    Mobile Keywords cho Robot Framework
    Cung cấp các keywords cho mobile automation testing
    """
    
    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'
    
    def __init__(self):
        """Khởi tạo Mobile Keywords"""
        self.builtin = BuiltIn()
        self.appium = AppiumLibrary()
        self.logger = logging.getLogger(self.__class__.__name__)
        
        # Timeouts
        self.implicit_timeout = 10
        self.explicit_timeout = 20
        self.page_load_timeout = 30
    
    def start_mobile_application(self, platform="android", device_name=None, app_path=None):
        """
        Khởi động ứng dụng mobile
        
        Args:
            platform: Platform (android/ios)
            device_name: Tên thiết bị
            app_path: Đường dẫn file app
        """
        try:
            logger.info(f"Khởi động ứng dụng mobile trên {platform}")
            
            if platform.lower() == "android":
                capabilities = {
                    "platformName": "Android",
                    "automationName": "UiAutomator2",
                    "deviceName": device_name or "Android Emulator",
                    "platformVersion": "11.0",
                    "app": app_path or "${EXECDIR}/apps/sample-app.apk",
                    "noReset": False,
                    "fullReset": True
                }
            else:
                capabilities = {
                    "platformName": "iOS",
                    "automationName": "XCUITest",
                    "deviceName": device_name or "iPhone Simulator",
                    "platformVersion": "15.0",
                    "app": app_path or "${EXECDIR}/apps/sample-app.app",
                    "noReset": False,
                    "fullReset": True
                }
            
            self.appium.open_application("http://127.0.0.1:4723/wd/hub", **capabilities)
            logger.info("Ứng dụng mobile đã được khởi động thành công")
            
        except Exception as e:
            logger.error(f"Lỗi khi khởi động ứng dụng mobile: {e}")
            raise
    
    def close_mobile_application(self):
        """Đóng ứng dụng mobile"""
        try:
            self.appium.close_application()
            logger.info("Đã đóng ứng dụng mobile")
        except Exception as e:
            logger.error(f"Lỗi khi đóng ứng dụng mobile: {e}")
            raise
    
    def tap_element(self, locator, duration=100):
        """
        Tap vào element
        
        Args:
            locator: Locator của element
            duration: Thời gian tap (ms)
        """
        try:
            self.appium.tap(locator, duration)
            logger.info(f"Đã tap element: {locator}")
        except Exception as e:
            logger.error(f"Lỗi khi tap element {locator}: {e}")
            raise
    
    def long_press_element(self, locator, duration=2000):
        """
        Long press element
        
        Args:
            locator: Locator của element
            duration: Thời gian press (ms)
        """
        try:
            self.appium.long_press(locator, duration)
            logger.info(f"Đã long press element: {locator}")
        except Exception as e:
            logger.error(f"Lỗi khi long press element {locator}: {e}")
            raise
    
    def swipe_screen(self, start_x, start_y, end_x, end_y, duration=1000):
        """
        Swipe màn hình
        
        Args:
            start_x: Tọa độ x bắt đầu
            start_y: Tọa độ y bắt đầu
            end_x: Tọa độ x kết thúc
            end_y: Tọa độ y kết thúc
            duration: Thời gian swipe (ms)
        """
        try:
            self.appium.swipe(start_x, start_y, end_x, end_y, duration)
            logger.info(f"Đã swipe từ ({start_x}, {start_y}) đến ({end_x}, {end_y})")
        except Exception as e:
            logger.error(f"Lỗi khi swipe: {e}")
            raise
    
    def swipe_up(self, duration=1000):
        """Swipe lên trên"""
        try:
            size = self.appium.get_window_size()
            start_x = size['width'] // 2
            start_y = int(size['height'] * 0.8)
            end_x = start_x
            end_y = int(size['height'] * 0.2)
            self.swipe_screen(start_x, start_y, end_x, end_y, duration)
        except Exception as e:
            logger.error(f"Lỗi khi swipe up: {e}")
            raise
    
    def swipe_down(self, duration=1000):
        """Swipe xuống dưới"""
        try:
            size = self.appium.get_window_size()
            start_x = size['width'] // 2
            start_y = int(size['height'] * 0.2)
            end_x = start_x
            end_y = int(size['height'] * 0.8)
            self.swipe_screen(start_x, start_y, end_x, end_y, duration)
        except Exception as e:
            logger.error(f"Lỗi khi swipe down: {e}")
            raise
    
    def swipe_left(self, duration=1000):
        """Swipe sang trái"""
        try:
            size = self.appium.get_window_size()
            start_x = int(size['width'] * 0.8)
            start_y = size['height'] // 2
            end_x = int(size['width'] * 0.2)
            end_y = start_y
            self.swipe_screen(start_x, start_y, end_x, end_y, duration)
        except Exception as e:
            logger.error(f"Lỗi khi swipe left: {e}")
            raise
    
    def swipe_right(self, duration=1000):
        """Swipe sang phải"""
        try:
            size = self.appium.get_window_size()
            start_x = int(size['width'] * 0.2)
            start_y = size['height'] // 2
            end_x = int(size['width'] * 0.8)
            end_y = start_y
            self.swipe_screen(start_x, start_y, end_x, end_y, duration)
        except Exception as e:
            logger.error(f"Lỗi khi swipe right: {e}")
            raise
    
    def wait_for_element_visible(self, locator, timeout=None):
        """
        Chờ element xuất hiện
        
        Args:
            locator: Locator của element
            timeout: Thời gian chờ (giây)
        """
        timeout = timeout or self.explicit_timeout
        try:
            self.appium.wait_until_element_is_visible(locator, timeout)
            logger.info(f"Element {locator} đã xuất hiện")
        except Exception as e:
            logger.error(f"Element {locator} không xuất hiện sau {timeout}s: {e}")
            raise
    
    def wait_for_element_enabled(self, locator, timeout=None):
        """
        Chờ element enabled
        
        Args:
            locator: Locator của element
            timeout: Thời gian chờ (giây)
        """
        timeout = timeout or self.explicit_timeout
        try:
            self.appium.wait_until_element_is_enabled(locator, timeout)
            logger.info(f"Element {locator} đã enabled")
        except Exception as e:
            logger.error(f"Element {locator} không enabled sau {timeout}s: {e}")
            raise
    
    def wait_for_element_not_visible(self, locator, timeout=None):
        """
        Chờ element biến mất
        
        Args:
            locator: Locator của element
            timeout: Thời gian chờ (giây)
        """
        timeout = timeout or self.explicit_timeout
        try:
            self.appium.wait_until_element_is_not_visible(locator, timeout)
            logger.info(f"Element {locator} đã biến mất")
        except Exception as e:
            logger.error(f"Element {locator} không biến mất sau {timeout}s: {e}")
            raise
    
    def element_should_be_visible(self, locator):
        """
        Kiểm tra element có hiển thị không
        
        Args:
            locator: Locator của element
        """
        try:
            self.appium.element_should_be_visible(locator)
            logger.info(f"Element {locator} đang hiển thị")
        except Exception as e:
            logger.error(f"Element {locator} không hiển thị: {e}")
            raise
    
    def element_should_not_be_visible(self, locator):
        """
        Kiểm tra element không hiển thị
        
        Args:
            locator: Locator của element
        """
        try:
            self.appium.element_should_not_be_visible(locator)
            logger.info(f"Element {locator} không hiển thị")
        except Exception as e:
            logger.error(f"Element {locator} vẫn hiển thị: {e}")
            raise
    
    def element_should_be_enabled(self, locator):
        """
        Kiểm tra element có enabled không
        
        Args:
            locator: Locator của element
        """
        try:
            self.appium.element_should_be_enabled(locator)
            logger.info(f"Element {locator} đang enabled")
        except Exception as e:
            logger.error(f"Element {locator} không enabled: {e}")
            raise
    
    def element_should_be_disabled(self, locator):
        """
        Kiểm tra element có disabled không
        
        Args:
            locator: Locator của element
        """
        try:
            self.appium.element_should_be_disabled(locator)
            logger.info(f"Element {locator} đang disabled")
        except Exception as e:
            logger.error(f"Element {locator} không disabled: {e}")
            raise
    
    def get_element_text(self, locator):
        """
        Lấy text của element
        
        Args:
            locator: Locator của element
            
        Returns:
            str: Text của element
        """
        try:
            text = self.appium.get_text(locator)
            logger.info(f"Text của element {locator}: {text}")
            return text
        except Exception as e:
            logger.error(f"Lỗi khi lấy text của element {locator}: {e}")
            raise
    
    def element_text_should_be(self, locator, expected_text):
        """
        Kiểm tra text của element
        
        Args:
            locator: Locator của element
            expected_text: Text mong đợi
        """
        try:
            actual_text = self.get_element_text(locator)
            if actual_text != expected_text:
                raise AssertionError(f"Text không khớp. Mong đợi: {expected_text}, Thực tế: {actual_text}")
            logger.info(f"Text của element {locator} khớp với mong đợi: {expected_text}")
        except Exception as e:
            logger.error(f"Lỗi khi kiểm tra text: {e}")
            raise
    
    def element_text_should_contain(self, locator, expected_text):
        """
        Kiểm tra text của element có chứa text mong đợi
        
        Args:
            locator: Locator của element
            expected_text: Text mong đợi
        """
        try:
            actual_text = self.get_element_text(locator)
            if expected_text not in actual_text:
                raise AssertionError(f"Text không chứa '{expected_text}'. Text thực tế: {actual_text}")
            logger.info(f"Text của element {locator} chứa: {expected_text}")
        except Exception as e:
            logger.error(f"Lỗi khi kiểm tra text: {e}")
            raise
    
    def hide_keyboard(self):
        """Ẩn bàn phím"""
        try:
            self.appium.hide_keyboard()
            logger.info("Đã ẩn bàn phím")
        except Exception as e:
            logger.error(f"Lỗi khi ẩn bàn phím: {e}")
            raise
    
    def go_back(self):
        """Quay lại màn hình trước"""
        try:
            self.appium.go_back()
            logger.info("Đã quay lại màn hình trước")
        except Exception as e:
            logger.error(f"Lỗi khi quay lại: {e}")
            raise
    
    def take_screenshot(self, filename=None):
        """
        Chụp screenshot
        
        Args:
            filename: Tên file screenshot
            
        Returns:
            str: Đường dẫn file screenshot
        """
        try:
            if not filename:
                timestamp = int(time.time())
                filename = f"screenshot_{timestamp}.png"
            
            screenshot_path = self.appium.capture_page_screenshot(filename)
            logger.info(f"Đã chụp screenshot: {screenshot_path}")
            return screenshot_path
        except Exception as e:
            logger.error(f"Lỗi khi chụp screenshot: {e}")
            raise
    
    def wait_for_page_load(self, timeout=None):
        """
        Chờ page load xong
        
        Args:
            timeout: Thời gian chờ (giây)
        """
        timeout = timeout or self.page_load_timeout
        time.sleep(2)  # Chờ cơ bản
        logger.info(f"Đã chờ page load {timeout}s")
    
    def scroll_to_element(self, locator):
        """
        Scroll đến element
        
        Args:
            locator: Locator của element
        """
        try:
            self.appium.scroll_to_element(locator)
            logger.info(f"Đã scroll đến element: {locator}")
        except Exception as e:
            logger.error(f"Lỗi khi scroll đến element {locator}: {e}")
            raise
    
    def scroll_to_text(self, text):
        """
        Scroll đến text
        
        Args:
            text: Text cần tìm
        """
        try:
            self.appium.scroll_to_text(text)
            logger.info(f"Đã scroll đến text: {text}")
        except Exception as e:
            logger.error(f"Lỗi khi scroll đến text {text}: {e}")
            raise 