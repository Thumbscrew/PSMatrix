function New-MatrixUrl {
    param(
        [Parameter(Mandatory)]
        [string]$ServerUrl,

        [Parameter(Mandatory)]
        [string]$ApiPath
    )

    return $ServerUrl.Trim("/") + "/" + $ApiPath
}