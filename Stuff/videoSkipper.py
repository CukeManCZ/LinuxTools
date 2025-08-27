from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

# --- Brave + Selenium setup ---
options = webdriver.ChromeOptions()
options.add_argument("--start-maximized")
options.add_argument("--user-data-dir=/home/traskos/.config/BraveSoftware/Brave-Browser/Default")
options.add_experimental_option("excludeSwitches", ["enable-automation"])
options.add_argument("--disable-site-isolation-trials")
options.add_argument("--disable-web-security")
options.add_argument("--ignore-certificate-errors")
options.binary_location = "/snap/brave/537/opt/brave.com/brave/brave-browser"
options.add_experimental_option("useAutomationExtension", False)

driver = webdriver.Chrome(options=options)

# --- URL to watch ---
driver.get("https://9animetv.to/watch/naruto-677?ep=12353")

# --- Wait for main video container to load ---
try:
    WebDriverWait(driver, 20).until(
        EC.presence_of_element_located((By.ID, "player"))  # adjust selector if needed
    )
except:
    print("Video player not detected. Continuing anyway...")

# Optional: simulate a click to trigger dynamic JS elements
driver.find_element(By.TAG_NAME, "body").click()
time.sleep(3)  # give JS a moment to render skip buttons

# --- Global state ---
start_time = time.time()
skip_intro_clicked_once = False

# --- Helper functions ---
def find_and_click_skip(button_id, timeout=5):
    """Recursively search all iframes and click the button if found."""
    def search_frames(frames):
        for frame in frames:
            driver.switch_to.frame(frame)
            try:
                btn = WebDriverWait(driver, timeout).until(
                    EC.element_to_be_clickable((By.ID, button_id))
                )
                driver.execute_script("arguments[0].scrollIntoView(true);", btn)
                driver.execute_script("arguments[0].click();", btn)
                driver.switch_to.default_content()
                print(f"Clicked {button_id} button")
                return True
            except:
                nested_frames = driver.find_elements(By.TAG_NAME, "iframe")
                if nested_frames and search_frames(nested_frames):
                    return True
            driver.switch_to.default_content()
        return False

    frames = driver.find_elements(By.TAG_NAME, "iframe")
    if search_frames(frames):
        return True

    try:
        btn = WebDriverWait(driver, timeout).until(
            EC.element_to_be_clickable((By.ID, button_id))
        )
        driver.execute_script("arguments[0].scrollIntoView(true);", btn)
        driver.execute_script("arguments[0].click();", btn)
        print(f"Clicked {button_id} button outside iframe")
        return True
    except:
        return False

def click_next_episode(timeout=5):
    try:
        next_btn = WebDriverWait(driver, timeout).until(
            EC.element_to_be_clickable((By.CSS_SELECTOR, "a.btn.btn-sm.btn-next"))
        )
        driver.execute_script("arguments[0].scrollIntoView(true);", next_btn)
        driver.execute_script("arguments[0].click();", next_btn)
        print("Clicked Next button")
        return True
    except:
        print("Next button not found")
        return False

# --- Main loop ---
try:
    while True:
        driver.switch_to.default_content()

        # Skip intro first
        if find_and_click_skip("skip-intro"):
            skip_intro_clicked_once = True

        elapsed = time.time() - start_time

        # After skipping intro and 30 sec, try skip outro + next
        if skip_intro_clicked_once and elapsed > 30:
            if find_and_click_skip("skip-outro"):
                if click_next_episode():
                    time.sleep(5)  # wait for next episode to load
                    start_time = time.time()
                    skip_intro_clicked_once = False
                    continue

        time.sleep(0.5)  # small sleep for smoother loop

except KeyboardInterrupt:
    print("Stopping script...")

finally:
    driver.quit()

