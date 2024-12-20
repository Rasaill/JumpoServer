import os
import re
import win32com.client
from bs4 import BeautifulSoup  # Install using 'pip install beautifulsoup4'

def extract_password_from_html(html_content):
    try:
        # Parse HTML using BeautifulSoup
        soup = BeautifulSoup(html_content, 'html.parser')

        # Find the element containing "Password :"
        password_element = soup.find(string=re.compile(r"Password\s*:"))
        if password_element:
            # Look for siblings or next elements after "Password :"
            parent = password_element.parent
            password_text = ""

            # Extract all text following "Password :"
            for sibling in parent.find_all_next(string=True):
                password_text += sibling.strip()
                # Stop if we hit a break or tag boundary
                if sibling.parent.name in ['br', 'p', 'div']:
                    break

            # Clean up the password text
            password_text = re.sub(r"^Password\s*:\s*", "", password_text).strip()
            return password_text
    except Exception as e:
        print(f"Error parsing HTML content: {e}")
    return None

def extract_credentials_from_msg(file_path):
    try:
        # Initialize Outlook Application
        outlook = win32com.client.Dispatch("Outlook.Application").GetNamespace("MAPI")
        # Open the .msg file
        msg = outlook.OpenSharedItem(file_path)
        # Access the HTML body
        html_content = msg.HTMLBody
        if html_content:
            # Extract the password from HTML
            password = extract_password_from_html(html_content)
            return password
        return None
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return None

def process_msg_files(directory):
    for file_name in os.listdir(directory):
        if file_name.endswith('.msg'):
            file_path = os.path.join(directory, file_name)
            password = extract_credentials_from_msg(file_path)
            if password:
                print(f"File: {file_name}")
                print(f"Password: {password}")
                print("=" * 30)
            else:
                print(f"Could not find password in {file_name}")

# Specify the directory containing .msg files
msg_directory = r"path_to_your_msg_files"
process_msg_files(msg_directory)
