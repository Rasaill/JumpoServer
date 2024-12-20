import os
import re

def extract_raw_text_from_msg(file_path):
    try:
        with open(file_path, "rb") as f:
            # Read the raw binary content
            content = f.read()

        # Decode to a string using common encodings
        decoded_content = content.decode("utf-8", errors="ignore")

        # Use regex to find the Username and Password lines
        username_match = re.search(r"Username\s*:\s*(.+)", decoded_content)
        password_match = re.search(r"Password\s*:\s*(.+)", decoded_content)

        if username_match and password_match:
            username = username_match.group(1).strip()
            password = password_match.group(1).strip()
            return username, password
        else:
            return None, None
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return None, None

def process_msg_files(directory):
    for file_name in os.listdir(directory):
        if file_name.endswith('.msg'):
            file_path = os.path.join(directory, file_name)
            username, password = extract_raw_text_from_msg(file_path)
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
