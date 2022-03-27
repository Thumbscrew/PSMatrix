function Get-MatrixAuthHeaders {
    param(
        [Parameter(Mandatory)]
        [SecureString]$AccessToken
    )

    return @{
        Authorization="Bearer " + ($AccessToken | ConvertFrom-SecureString -AsPlainText)
    }
}