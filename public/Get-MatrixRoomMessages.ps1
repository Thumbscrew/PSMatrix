function Get-MatrixRoomMessages {
    param(
        [Parameter(Mandatory)]
        [string]$ServerUrl,

        [Parameter(Mandatory)]
        [SecureString]$AccessToken,

        [Parameter(Mandatory)]
        [string]$UserId,

        [Parameter(Mandatory)]
        [string]$RoomId,

        [Parameter(Mandatory = $false)]
        [int]$Limit = 50
    )

    $headers = Get-MatrixAuthHeaders -AccessToken $AccessToken

    try {
        $filterUrl = New-MatrixUrl -ServerUrl $ServerUrl -ApiPath "_matrix/client/v3/user/$UserId/filter"
        $filter = [PSCustomObject]@{
            room = @{
                rooms = @(
                    $RoomId
                )
                timeline = @{
                    limit = $Limit
                    rooms = @(
                        $RoomId
                    )
                    types = @(
                        "m.room.message"
                    )
                }
            }
        } | ConvertTo-Json -Depth 3

        $filterRes = Invoke-RestMethod -Uri $filterUrl -Method "POST" -Headers $headers -Body $filter
    } catch {
        Write-Error $_
        return
    }

    try {
        $filterId = $filterRes.filter_id
        $url = New-MatrixUrl -ServerUrl $ServerUrl `
            -ApiPath ("_matrix/client/v3/sync" `
            + "?filter=$filterId" `
            + "&full_state=true&set_presence=offline")

        Write-Debug "URL: $url"

        $res = Invoke-RestMethod -Uri $url -Headers $headers
    } catch {
        Write-Error $_
        return
    }

    $events = $res.rooms.join.($RoomId).timeline.events

    $formattedEvents = @()

    $events | ForEach-Object {
        $formattedEvent = [PSCustomObject]@{
            EventID = $_.event_id
            Sender = $_.sender
            Body = $_.content.body
            Format = $_.content.format
            FormattedBody = $_.content.formatted_body
            MsgType = $_.content.msgtype
        }
        $formattedEvent.PSObject.TypeNames.Insert(0, 'MatrixMessage')

        $formattedEvents += $formattedEvent
    }

    return $formattedEvents
}