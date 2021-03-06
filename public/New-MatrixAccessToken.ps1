<#
    .Synopsis
    Login and retrieve an Access token (returned as a SecureString).

    .Description
    Login and retrieve an Access token from _matrix/client/v3/login (returned as a SecureString). See https://spec.matrix.org/v1.2/client-server-api/#post_matrixclientv3login.

    .Parameter ServerUrl
    URL for the Matrix server to log into, for example "https://matrix.example.com".

    .Parameter Credentials
    PSCredentials Object that contains the Matrix Username and Password for the user you wish to log in with.

    .Parameter DeviceDisplayName
    Display name to assign to this Access token.

    .Example
    # Create a PSCredentials Object
    $creds = Get-Credential
    $token = Get-LoginToken -ServerUrl "https://matrix.example.com" -Credentials $creds
#>
function New-MatrixAccessToken {
    param(
        [Parameter(Mandatory)]
        [string]$ServerUrl,

        [Parameter(Mandatory)]
        [PSCredential]$Credentials,

        [Parameter(Mandatory=$false)]
        [string]$DeviceDisplayName="PSMatrix"
    )

    $url = New-MatrixUrl -ServerUrl $ServerUrl -ApiPath "_matrix/client/v3/login"
    $apiMethod = "Post"

    $reqBody = @{
        identifier = @{
            type = "m.id.user"
            user = $Credentials.UserName
        }
        type = "m.login.password"
        password = $Credentials.Password | ConvertFrom-SecureString -AsPlainText
        initial_device_display_name = $DeviceDisplayName
    } | ConvertTo-Json

    $res = Invoke-RestMethod -Uri $url -Method $apiMethod -Body $reqBody

    $token = $res.access_token | ConvertTo-SecureString -AsPlainText

    return $token
}