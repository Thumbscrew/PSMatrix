<#
    .Synopsis
    Redact a Matrix message in a given Room ID.

    .Description
    Redact a Matrix message in a given Room ID from _matrix/client/v3/rooms/{roomId}/redact/{eventId}/{txnId}. See https://spec.matrix.org/v1.2/client-server-api/#put_matrixclientv3roomsroomidredacteventidtxnid.

    .Parameter ServerUrl
    URL for the Matrix server to log into, for example "https://matrix.example.com".

    .Parameter AccessToken
    A SecureString containing the Matrix access token.

    .Parameter RoomId
    The Matrix room ID to redact the message from.

    .Parameter Message
    The MatrixMessage object that contains the Event ID to redact.

    .Parameter Reason
    The reason to provide for the redaction (optional).

    .Example
    Remove-MatrixRoomMessage -ServerUrl $server -AccessToken $token -RoomId "!ehXvUhWNASUkSLvAGP:matrix.org" -Message $message -Reason "Redacted by PSMatrix"
#>
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