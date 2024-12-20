import os
import re
import win32com.client

def extract_credentials_from_msg(file_path):
    try:
        # Initialize Outlook Application
        outlook = win32com.client.Dispatch("Outlook.Application").GetNamespace("MAPI")
        # Open the .msg file
        msg = outlook.OpenSharedItem(file_path)
        # Access the HTML body
        html_content = msg.HTMLBody

        if html_content:
            # Extract everything after "Password :" until a logical boundary (e.g., <br>, newline)
            match = re.search(r"Password\s*:\s*(.+?)(<br|<div|<p|[\r\n])", html_content, re.IGNORECASE)
            if match:
                # Group 1 contains the full password
                password = match.group(1).strip()
                # Decode any HTML entities (e.g., &amp; -> &)
                password = re.sub(r"&lt;", "<", password)  # Handle '<'
                password = re.sub(r"&gt;", ">", password)  # Handle '>'
                password = re.sub(r"&amp;", "&", password)  # Handle '&'
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
