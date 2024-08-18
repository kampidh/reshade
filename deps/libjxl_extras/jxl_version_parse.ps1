param([Parameter(Mandatory = $true)][string]$SolutionDir)

$cmakeinputpath = ($SolutionDir + "deps\libjxl\lib\CMakeLists.txt")
$cmexists = Test-Path $cmakeinputpath

$verinfile = ($SolutionDir + "deps\libjxl\lib\jxl\version.h.in")
$vrexists = Test-Path $verinfile

if (($cmexists -and $vrexists) -and $(Get-Content $cmakeinputpath | Out-String) -match "set\(JPEGXL_MAJOR_VERSION (\d+)\)\s+set\(JPEGXL_MINOR_VERSION (\d+)\)\s+set\(JPEGXL_PATCH_VERSION (\d+)\)") {
	$version = [int]::Parse($matches[1]), [int]::Parse($matches[2]), [int]::Parse($matches[3])

    $verfile = Get-Content $verinfile
    $verfile = $verfile.replace("@JPEGXL_MAJOR_VERSION@", $version[0])
    $verfile = $verfile.replace("@JPEGXL_MINOR_VERSION@", $version[1])
    $verfile = $verfile.replace("@JPEGXL_PATCH_VERSION@", $version[2])

    $outverfile = ($SolutionDir + "deps\libjxl_extras\include\jxl\version.h")

    Out-File -FilePath $outverfile -InputObject $verfile -Encoding ASCII
    echo "libjxl version parsed"
}
