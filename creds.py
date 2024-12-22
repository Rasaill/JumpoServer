from ldap3 import Server, Connection, ALL, NTLM
import getpass

def validate_credentials():
    # Prompt for domain, username, and password
    domain = input("Enter your domain (e.g., DOMAIN): ")
    username = input(f"Enter your username ({domain}\\username): ")
    password = getpass.getpass("Enter your password: ")
    
    # Construct the full username (DOMAIN\username)
    user = f"{domain}\\{username}"
    
    # Define the LDAP server (you can replace this with your domain controller)
    server_address = input("Enter your domain controller address (e.g., ldap://dc.example.com): ")
    server = Server(server_address, get_info=ALL)

    try:
        # Attempt to bind with the provided credentials
        conn = Connection(server, user=user, password=password, authentication=NTLM)
        if conn.bind():
            print("Credentials are valid.")
            conn.unbind()
        else:
            print("Invalid credentials or authentication failed.")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    validate_credentials()
