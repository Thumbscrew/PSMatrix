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