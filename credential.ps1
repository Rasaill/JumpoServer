# Prompt for domain credentials
$Username = Read-Host "Enter your domain username (e.g., DOMAIN\username)"
$Password = Read-Host "Enter your password" -AsSecureString

# Attempt to validate the credentials
try {
    # Create a credential object
    $Credential = New-Object System.Management.Automation.PSCredential ($Username, $Password)
    
    # Use a simple LDAP query to check authentication
    $Domain = $Username.Split('\')[0]
    $Searcher = New-Object DirectoryServices.DirectorySearcher
    $Searcher.SearchRoot = New-Object DirectoryServices.DirectoryEntry("LDAP://$Domain", $Username, $Password)
    $Searcher.Filter = "(objectClass=User)"
    $Searcher.SizeLimit = 1
    $Searcher.FindOne() | Out-Null

    Write-Host "Credentials are valid." -ForegroundColor Green
} catch {
    Write-Host "Invalid credentials or authentication failed." -ForegroundColor Red
}
