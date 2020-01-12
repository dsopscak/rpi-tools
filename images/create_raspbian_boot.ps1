# create_raspbian_boot.ps1
#
# A command line windows utility for creating raspbian boot images with
# ssh enabled. Must run from an admin powershell console:
#
#   create_raspbian_boot.ps1 -ifile <image file> -device <drive letter> [-wpa <wpa_supplicant.conf>]
#
# Get CommandLineDiskImager from
#
#   https://github.com/davidferguson/CommandLineDiskImager/releases/download/0.0.0.2/CommandLineDiskImager.zip
#
# Get image files from, for example, one of
#
#   https://downloads.raspberrypi.org/raspbian_full_latest
#   https://downloads.raspberrypi.org/raspbian_latest
#   https://downloads.raspberrypi.org/raspbian_lite_latest

param (
  [Parameter(Mandatory=$true)][string]$ifile,
  [Parameter(Mandatory=$true)][string]$device,
  [string]$wpa
)

C:\CommandLineDiskImager\CommandLineDiskImager.exe $ifile $device
sleep 5
echo "" >>"${device}:\ssh"
if ($PSBoundParameters.ContainsKey('wpa')) {
    copy $wpa "${device}:\wpa_supplicant.conf"
}
sleep 2
$driveEject = New-Object -comObject Shell.Application
$driveEject.Namespace(17).ParseName("${device}:").InvokeVerb("Eject")
