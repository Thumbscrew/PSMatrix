# PSMatrix
PowerShell module for interacting with the Matrix API

## Installation

1. Clone repo:

```bash
git clone https://github.com/Thumbscrew/PSMatrix.git
```

2. Import module:

```powershell
Import-Module ./PSMatrix
```

## Getting Started

1. Create a `PSCredential` object:

```powershell
$creds = Get-Credential

PowerShell credential request
Enter your credentials.
User: username
Password for user username: **************
```

2. Get an access token from your Matrix homeserver (this will be required for subsequent authenticated requests):

```powershell
# DeviceDisplayName is optional and will default to "PSMatrix"
$token = New-MatrixAccessToken -ServerUrl "https://example.matrix.com" -Credentials $creds -DeviceDisplayName "PSMatrix"
```

## Examples

### Get a list Matrix rooms you've joined

```powershell
$rooms = Get-MatrixJoinedRooms -ServerUrl "https://matrix.example.com" -AccessToken $token
```

### Get all members of a joined room

```powershell
Get-MatrixJoinedMembers -ServerUrl "https://matrix.example.com" -AccessToken $token -RoomId "!ehXvUhWNASUkSLvAGP:matrix.org"
```

### Log out of your session

```powershell
Remove-MatrixAccessToken -ServerUrl "https://matrix.example.com" -AccessToken $token
```
