function Join-MatrixRoom {
    param(
        [Parameter(Mandatory)]
        [string]$ServerUrl,

        [Parameter(Mandatory)]
        [SecureString]$AccessToken,

        [Parameter(Mandatory)]
        [string]$RoomAliasOrId
    )

    $url = New-MatrixUrl -ServerUrl $ServerUrl -ApiPath "_matrix/client/v3/join/$RoomAliasOrId?server_name=techlore.net"
    $headers = Get-MatrixAuthHeaders -AccessToken $AccessToken
    $method = "POST"
    
    try {
        $res = Invoke-RestMethod -Uri $url -Headers $headers -Method $method
        return $res
    } catch {
        Write-Error $_
    }
}