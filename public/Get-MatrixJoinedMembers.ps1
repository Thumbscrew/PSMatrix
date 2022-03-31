<#
    .Synopsis
    Get all joined members for a given Room ID.

    .Description
    Get all joined members for a given Room ID from _matrix/client/v3/rooms/{roomId}/joined_members. See https://spec.matrix.org/v1.2/client-server-api/#get_matrixclientv3roomsroomidjoined_members.

    .Parameter ServerUrl
    URL for the Matrix server to log into, for example "https://matrix.example.com".

    .Parameter AccessToken
    A SecureString containing the Matrix access token.

    .Parameter RoomId
    The Matrix room ID to retrieve joined members for.

    .Example
    Get-MatrixJoinedMembers -ServerUrl $server -AccessToken $token -RoomId "!ehXvUhWNASUkSLvAGP:matrix.org"
#>
function Get-MatrixJoinedMembers {
    param(
        [Parameter(Mandatory)]
        [string]$ServerUrl,

        [Parameter(Mandatory)]
        [SecureString]$AccessToken,

        [Parameter(Mandatory)]
        [string]$RoomId
    )

    $url = New-MatrixUrl -ServerUrl $ServerUrl -ApiPath "_matrix/client/v3/rooms/$RoomId/joined_members"
    Write-Debug "URL: $url"
    $headers = Get-MatrixAuthHeaders -AccessToken $AccessToken

    try {
        $res = Invoke-RestMethod -Uri $url -Headers $headers
        $joinedObject = $res.joined
        $members = @()

        $joinedObject.PSObject.Properties | ForEach-Object {
            $member = [PSCustomObject]@{
                MatrixId = $_.Name
                DisplayName = $_.Value.display_name
                AvatarUrl = $_.Value.avatar_url
            }

            $members += $member
        }

        return $members
    } catch {
        Write-Error $_
    }
}