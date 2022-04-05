function Remove-MatrixRoomMessage {
    param (
        [Parameter(Mandatory)]
        [string]
        $ServerUrl,

        [Parameter(Mandatory)]
        [SecureString]
        $AccessToken,

        [Parameter(Mandatory)]
        [string]
        $RoomId,

        [Parameter(Mandatory)]
        [MatrixMessage]
        $Message,

        [Parameter(Mandatory=$false)]
        [string]
        $Reason
    )

    $eventId = $Message.EventID
    $txnId = New-Guid
    $url = New-MatrixUrl -ServerUrl $ServerUrl -ApiPath "_matrix/client/v3/rooms/$RoomId/redact/$eventId/$txnId"
    Write-Debug "URL: $url"
    $method = "Put"
    $headers = Get-MatrixAuthHeaders -AccessToken $AccessToken
    $body = @{
        reason = $Reason
    } | ConvertTo-Json

    try {
        return Invoke-RestMethod -Uri $url -Method $method -Headers $headers -Body $body
    } catch {
        Write-Error $_
    }
}