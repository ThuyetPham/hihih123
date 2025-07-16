# -*- coding: utf-8 -*-
"""
Base Page Object cho Mobile App
Cung cấp các phương thức cơ bản cho tất cả page objects
"""

import time
import logging
from abc import ABC, abstractmethod
from typing import Optional, Tuple
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from AppiumLibrary import AppiumLibrary

class BasePage(ABC):
    """
    Base Page Object cho Mobile App
    Cung cấp các phương thức cơ bản cho tất cả page objects
    """
    
    def __init__(self, driver=None):
        """
        Khởi tạo Base Page
        
        Args:
            driver: Appium driver instance
        """
        self.driver = driver or BuiltIn().get_library_instance('AppiumLibrary')._current_application()
        self.builtin = BuiltIn()
        self.appium = AppiumLibrary()
        self.logger = logging.getLogger(self.__class__.__name__)
        
        # Timeouts
        self.implicit_timeout = 10
        self.explicit_timeout = 20
        self.page_load_timeout = 30
        
    def wait_for_element(self, locator: str, timeout: int = None) -> bool:
        """
        Chờ element xuất hiện
        
        Args:
            locator: Locator của element
            timeout: Thời gian chờ (giây)
            
        Returns:
            bool: True nếu element xuất hiện, False nếu không
        """
        timeout = timeout or self.explicit_timeout
        try:
            self.appium.wait_until_element_is_visible(locator, timeout)
            return True
        except Exception as e:
            self.logger.warning(f"Element {locator} không xuất hiện sau {timeout}s: {e}")
            return False
    
    def wait_for_element_to_be_clickable(self, locator: str, timeout: int = None) -> bool:
        """
        Chờ element có thể click được
        
        Args:
            locator: Locator của element
            timeout: Thời gian chờ (giây)
            
        Returns:
            bool: True nếu element có thể click, False nếu không
        """
        timeout = timeout or self.explicit_timeout
        try:
            self.appium.wait_until_element_is_enabled(locator, timeout)
            return True
        except Exception as e:
            self.logger.warning(f"Element {locator} không clickable sau {timeout}s: {e}")
            return False
    
    def click_element(self, locator: str, timeout: int = None) -> bool:
        """
        Click vào element
        
        Args:
            locator: Locator của element
            timeout: Thời gian chờ element xuất hiện
            
        Returns:
            bool: True nếu click thành công, False nếu không
        """
        if self.wait_for_element_to_be_clickable(locator, timeout):
            try:
                self.appium.click_element(locator)
                self.logger.info(f"Đã click element: {locator}")
                return True
            except Exception as e:
                self.logger.error(f"Lỗi khi click element {locator}: {e}")
                return False
        return False
    
    def input_text(self, locator: str, text: str, timeout: int = None) -> bool:
        """
        Nhập text vào element
        
        Args:
            locator: Locator của element
            text: Text cần nhập
            timeout: Thời gian chờ element xuất hiện
            
        Returns:
            bool: True nếu nhập thành công, False nếu không
        """
        if self.wait_for_element(locator, timeout):
            try:
                self.appium.input_text(locator, text)
                self.logger.info(f"Đã nhập text '{text}' vào element: {locator}")
                return True
            except Exception as e:
                self.logger.error(f"Lỗi khi nhập text vào element {locator}: {e}")
                return False
        return False
    
    def get_element_text(self, locator: str, timeout: int = None) -> Optional[str]:
        """
        Lấy text của element
        
        Args:
            locator: Locator của element
            timeout: Thời gian chờ element xuất hiện
            
        Returns:
            str: Text của element hoặc None nếu không tìm thấy
        """
        if self.wait_for_element(locator, timeout):
            try:
                text = self.appium.get_text(locator)
                self.logger.info(f"Text của element {locator}: {text}")
                return text
            except Exception as e:
                self.logger.error(f"Lỗi khi lấy text của element {locator}: {e}")
                return None
        return None
    
    def is_element_visible(self, locator: str, timeout: int = None) -> bool:
        """
        Kiểm tra element có hiển thị không
        
        Args:
            locator: Locator của element
            timeout: Thời gian chờ element xuất hiện
            
        Returns:
            bool: True nếu element hiển thị, False nếu không
        """
        return self.wait_for_element(locator, timeout)
    
    def is_element_enabled(self, locator: str, timeout: int = None) -> bool:
        """
        Kiểm tra element có enabled không
        
        Args:
            locator: Locator của element
            timeout: Thời gian chờ element xuất hiện
            
        Returns:
            bool: True nếu element enabled, False nếu không
        """
        return self.wait_for_element_to_be_clickable(locator, timeout)
    
    def swipe(self, start_x: int, start_y: int, end_x: int, end_y: int, duration: int = 1000):
        """
        Swipe từ điểm bắt đầu đến điểm kết thúc
        
        Args:
            start_x: Tọa độ x bắt đầu
            start_y: Tọa độ y bắt đầu
            end_x: Tọa độ x kết thúc
            end_y: Tọa độ y kết thúc
            duration: Thời gian swipe (ms)
        """
        try:
            self.appium.swipe(start_x, start_y, end_x, end_y, duration)
            self.logger.info(f"Đã swipe từ ({start_x}, {start_y}) đến ({end_x}, {end_y})")
        except Exception as e:
            self.logger.error(f"Lỗi khi swipe: {e}")
    
    def swipe_up(self, duration: int = 1000):
        """Swipe lên trên"""
        screen_size = self.get_screen_size()
        start_x = screen_size[0] // 2
        start_y = int(screen_size[1] * 0.8)
        end_x = start_x
        end_y = int(screen_size[1] * 0.2)
        self.swipe(start_x, start_y, end_x, end_y, duration)
    
    def swipe_down(self, duration: int = 1000):
        """Swipe xuống dưới"""
        screen_size = self.get_screen_size()
        start_x = screen_size[0] // 2
        start_y = int(screen_size[1] * 0.2)
        end_x = start_x
        end_y = int(screen_size[1] * 0.8)
        self.swipe(start_x, start_y, end_x, end_y, duration)
    
    def swipe_left(self, duration: int = 1000):
        """Swipe sang trái"""
        screen_size = self.get_screen_size()
        start_x = int(screen_size[0] * 0.8)
        start_y = screen_size[1] // 2
        end_x = int(screen_size[0] * 0.2)
        end_y = start_y
        self.swipe(start_x, start_y, end_x, end_y, duration)
    
    def swipe_right(self, duration: int = 1000):
        """Swipe sang phải"""
        screen_size = self.get_screen_size()
        start_x = int(screen_size[0] * 0.2)
        start_y = screen_size[1] // 2
        end_x = int(screen_size[0] * 0.8)
        end_y = start_y
        self.swipe(start_x, start_y, end_x, end_y, duration)
    
    def get_screen_size(self) -> Tuple[int, int]:
        """
        Lấy kích thước màn hình
        
        Returns:
            Tuple[int, int]: (width, height)
        """
        try:
            size = self.appium.get_window_size()
            return size['width'], size['height']
        except Exception as e:
            self.logger.error(f"Lỗi khi lấy kích thước màn hình: {e}")
            return 1080, 1920  # Default size
    
    def take_screenshot(self, filename: str = None) -> str:
        """
        Chụp screenshot
        
        Args:
            filename: Tên file screenshot
            
        Returns:
            str: Đường dẫn file screenshot
        """
        if not filename:
            timestamp = int(time.time())
            filename = f"screenshot_{timestamp}.png"
        
        try:
            screenshot_path = self.appium.capture_page_screenshot(filename)
            self.logger.info(f"Đã chụp screenshot: {screenshot_path}")
            return screenshot_path
        except Exception as e:
            self.logger.error(f"Lỗi khi chụp screenshot: {e}")
            return ""
    
    def wait_for_page_load(self, timeout: int = None):
        """
        Chờ page load xong
        
        Args:
            timeout: Thời gian chờ (giây)
        """
        timeout = timeout or self.page_load_timeout
        time.sleep(2)  # Chờ cơ bản
        self.logger.info(f"Đã chờ page load {timeout}s")
    
    def go_back(self):
        """Quay lại màn hình trước"""
        try:
            self.appium.go_back()
            self.logger.info("Đã quay lại màn hình trước")
        except Exception as e:
            self.logger.error(f"Lỗi khi quay lại: {e}")
    
    def hide_keyboard(self):
        """Ẩn bàn phím"""
        try:
            self.appium.hide_keyboard()
            self.logger.info("Đã ẩn bàn phím")
        except Exception as e:
            self.logger.error(f"Lỗi khi ẩn bàn phím: {e}")
    
    @abstractmethod
    def is_page_loaded(self) -> bool:
        """
        Kiểm tra page đã load xong chưa
        Phải implement trong các page con
        
        Returns:
            bool: True nếu page đã load, False nếu chưa
        """
        pass
    
    @abstractmethod
    def wait_for_page(self, timeout: int = None) -> bool:
        """
        Chờ page load xong
        Phải implement trong các page con
        
        Args:
            timeout: Thời gian chờ (giây)
            
        Returns:
            bool: True nếu page load thành công, False nếu không
        """
        pass 