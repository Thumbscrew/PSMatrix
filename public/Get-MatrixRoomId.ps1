<#
    .Synopsis
    Get the Matrix Room ID for the given Room Alias.

    .Description
    Get the Matrix Room ID for the given Room Alias from _matrix/client/v3/directory/room/{roomAlias}. See https://spec.matrix.org/v1.2/client-server-api/#get_matrixclientv3directoryroomroomalias.

    .Parameter ServerUrl
    URL for the Matrix server to query, for example "https://matrix.example.com".

    .Parameter RoomAlias
    The Matrix Room Alias to retrieve the Room ID for (e.g. '#matrix:matrix.org').

    .Example
    Get-MatrixRoomId -ServerUrl $matrix -RoomAlias "#synapse:matrix.org"
#>
function Get-MatrixRoomId {
    param(
        [Parameter(Mandatory)]
        [string]$ServerUrl,

        [Parameter(Mandatory)]
        [string]$RoomAlias
    )

    $encodedRoomAlias = $RoomAlias.Replace('#', '%23')
    $url = New-MatrixUrl -ServerUrl $ServerUrl -ApiPath "_matrix/client/v3/directory/room/$encodedRoomAlias"
    Write-Debug "URL: $url"

    try {
        $res = Invoke-RestMethod -Uri $url

        $roomId = [PSCustomObject]@{
            RoomId = $res.room_id
            Servers = $res.servers
        }

        return $roomId
    } catch {
        Write-Error $_
    }
}