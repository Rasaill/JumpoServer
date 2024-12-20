import os
import re
import win32com.client
from bs4 import BeautifulSoup  # Install using 'pip install beautifulsoup4'

def extract_credentials_from_msg(file_path):
    try:
        # Initialize Outlook Application
        outlook = win32com.client.Dispatch("Outlook.Application").GetNamespace("MAPI")
        # Open the .msg file
        msg = outlook.OpenSharedItem(file_path)
        # Access the HTML body
        html_content = msg.HTMLBody

        if html_content:
            # Parse HTML with BeautifulSoup
            soup = BeautifulSoup(html_content, 'html.parser')

            # Find the exact HTML containing "Password :"
            password_element = soup.find(string=re.compile(r"Password\s*:"))
            if password_element:
                # Get the full password text, including following siblings
                password_line = password_element.parent.get_text(strip=True)

                # Extract the password using regex
                password_match = re.search(r"Password\s*:\s*(.+)", password_line)
                if password_match:
                    password = password_match.group(1).strip()
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
