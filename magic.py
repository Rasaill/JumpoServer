import os
import re
import subprocess

def extract_raw_text(file_path):
    """
    Extract raw text from a file using the 'strings' utility.
    """
    try:
        # Use 'strings' to extract all readable text from the binary file
        result = subprocess.run(['strings', file_path], stdout=subprocess.PIPE, text=True)
        return result.stdout
    except Exception as e:
        print(f"Error using strings on {file_path}: {e}")
        return ""

def extract_credentials(content):
    """
    Extract credentials using regex patterns.
    """
    try:
        username_match = re.search(r"Username\s*:\s*(.+)", content)
        password_match = re.search(r"Password\s*:\s*(.+)", content)

        if username_match and password_match:
            username = username_match.group(1).strip()
            password = password_match.group(1).strip()
            return username, password
        else:
            return None, None
    except Exception as e:
        print(f"Error extracting credentials: {e}")
        return None, None

def process_msg_files(directory):
    for file_name in os.listdir(directory):
        if file_name.endswith('.msg'):
            file_path = os.path.join(directory, file_name)
            raw_content = extract_raw_text(file_path)
            username, password = extract_credentials(raw_content)
            if username and password:
                print(f"File: {file_name}")
                print(f"Username: {username}")
                print(f"Password: {password}")
                print("=" * 30)
            else:
                print(f"Could not find credentials in {file_name}")

# Specify the directory containing .msg files
msg_directory = r"path_to_your_msg_files"
process_msg_files(msg_directory)
