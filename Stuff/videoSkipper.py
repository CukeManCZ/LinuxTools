from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
 
options = webdriver.FirefoxOptions()
options.add_argument("--start-maximized")
driver = webdriver.Firefox(options=options)
 
driver.get("https://9animetv.to/watch/naruto-677?ep=12353")
 
start_time = time.time()
skip_intro_clicked_once = False
 
def try_click_skip_intro(iframes):
    for iframe in iframes:
        driver.switch_to.frame(iframe)
        try:
            skip_intro_btn = WebDriverWait(driver, 0.5).until(
                EC.element_to_be_clickable((By.ID, "skip-intro"))
            )
            driver.execute_script("arguments[0].click();", skip_intro_btn)
            print("Clicked Skip Intro button inside iframe")
            driver.switch_to.default_content()
            return True
        except:
            driver.switch_to.default_content()
            continue
 
    # Outside iframe
    try:
        skip_intro_btn = WebDriverWait(driver, 0.5).until(
            EC.element_to_be_clickable((By.ID, "skip-intro"))
        )
        driver.execute_script("arguments[0].click();", skip_intro_btn)
        print("Clicked Skip Intro button outside iframe")
        return True
    except:
        return False
 
def try_click_skip_outro(iframes):
    for iframe in iframes:
        driver.switch_to.frame(iframe)
        try:
            skip_outro_btn = WebDriverWait(driver, 0.5).until(
                EC.element_to_be_clickable((By.ID, "skip-outro"))
            )
            driver.execute_script("arguments[0].click();", skip_outro_btn)
            print("Clicked Skip Outro button inside iframe")
            driver.switch_to.default_content()
            return True
        except:
            driver.switch_to.default_content()
            continue
 
    # Outside iframe
    try:
        skip_outro_btn = WebDriverWait(driver, 0.5).until(
            EC.element_to_be_clickable((By.ID, "skip-outro"))
        )
        driver.execute_script("arguments[0].click();", skip_outro_btn)
        print("Clicked Skip Outro button outside iframe")
        return True
    except:
        return False
 
def try_click_next():
    try:
        next_btn = WebDriverWait(driver, 1).until(
            EC.element_to_be_clickable((By.CSS_SELECTOR, "a.btn.btn-sm.btn-next"))
        )
        driver.execute_script("arguments[0].click();", next_btn)
        print("Clicked Next button after Skip Outro")
        return True
    except:
        print("Next button not found after Skip Outro")
        return False
 
 
try:
    while True:
        driver.switch_to.default_content()
        iframes = driver.find_elements(By.TAG_NAME, "iframe")
 
        # Try skip intro first
        if try_click_skip_intro(iframes):
            skip_intro_clicked_once = True
 
        elapsed = time.time() - start_time
 
        # After skipping intro once and after 30 sec, try skip outro + next
        if skip_intro_clicked_once and elapsed > 30:
            if try_click_skip_outro(iframes):
                if try_click_next():
                    time.sleep(2)  # short wait for next episode to load
                    start_time = time.time()
                    skip_intro_clicked_once = False
                    continue
 
        time.sleep(0.2)  # smaller sleep for faster loop
 
except KeyboardInterrupt:
    print("Stopping script...")
 
finally:
    driver.quit()