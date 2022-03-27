function Get-MatrixJoinedRooms {
    param(
        [Parameter(Mandatory)]
        [string]$ServerUrl,

        [Parameter(Mandatory)]
        [SecureString]$AccessToken
    )

    try {
        $url = New-MatrixUrl -ServerUrl $ServerUrl -ApiPath "_matrix/client/v3/joined_rooms"
    }
    catch {
        Write-Error $Error[0]
        return
    }

    $headers = Get-MatrixAuthHeaders -AccessToken $AccessToken

    $res = Invoke-RestMethod -Uri $url -Headers $headers
    $rooms = @()

    foreach($roomId in $res.joined_rooms) {
        $roomAliasUrl = New-MatrixUrl -ServerUrl $ServerUrl -ApiPath "_matrix/client/v3/rooms/$roomId/state/m.room.canonical_alias"
        $mainAlias = $null
        $altAliases = @()

        Write-Debug "Retrieving aliases for room ID $roomId via request $roomAliasUrl"

        try {
            $aliasRes = Invoke-RestMethod -Uri $roomAliasUrl -Headers $headers
            $mainAlias = $aliasRes.alias
            $altAliases = $aliasRes.alt_aliases
            if($null -eq $altAliases) {
                $altAliases = @()
            }
        }
        catch {
            # Write-Warning $Error[0]
        }

        $room = [PSCustomObject]@{
            RoomID = $roomId
            MainAlias = $mainAlias
            AltAliases = $altAliases
        }

        $rooms += $room
    }

    return $rooms
}