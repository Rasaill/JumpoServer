import os
import extract_msg

def extract_credentials_from_msg(file_path):
    try:
        # Open the .msg file
        msg_file = extract_msg.Message(file_path)
        # Extract the body content
        content = msg_file.body

        # Find the lines containing "Username :" and "Password :"
        username_line = next((line for line in content.splitlines() if "Username :" in line), None)
        password_line = next((line for line in content.splitlines() if "Password :" in line), None)

        if username_line and password_line:
            # Extract the username and password
            username = username_line.split("Username :", 1)[1].strip()
            password = password_line.split("Password :", 1)[1].strip()
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
            username, password = extract_credentials_from_msg(file_path)
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
