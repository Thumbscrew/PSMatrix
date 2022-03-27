<#
    .Synopsis
    Invalidate the provided Access token.

    .Description
    Invalidate the provided Access token. See https://spec.matrix.org/v1.2/client-server-api/#post_matrixclientv3logout.

    .Parameter ServerUrl
    URL for the Matrix server to log into, for example "https://matrix.example.com".

    .Parameter AccessToken
    The Access token to invalidate.

    .Example
    Remove-MatrixAccessToken -ServerUrl "https://matrix.example.com" -AccessToken $token
#>

function Remove-MatrixAccessToken {
    param(
        [Parameter(Mandatory)]
        [string]$ServerUrl,

        [Parameter(Mandatory)]
        [SecureString]$AccessToken
    )

    $url = New-MatrixUrl -ServerUrl $ServerUrl -ApiPath "_matrix/client/v3/logout"
    $apiMethod = "Post"

    $headers = @{
        Authorization="Bearer " + ($AccessToken | ConvertFrom-SecureString -AsPlainText)
    }

    Try {
        Invoke-RestMethod -Uri $url -Method $apiMethod -Headers $headers
        return $true
    }
    Catch {
        Write-Error $_
        return $false
    }
}