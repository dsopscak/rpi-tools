# create_raspbian_boot.ps1
#
# A command line windows utility for creating raspbian boot images with
# ssh enabled. Must run from an admin powershell console:
#
#   create_raspbian_boot.ps1 -ifile <image file> -device <drive letter> [-wpa <wpa_supplicant.conf> -usr <userconf.txt>]
#
# https://www.raspberrypi.com/documentation/computers/configuration.html#setting-up-a-headless-raspberry-pi
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
#
#   The above are "classic". Newer stuff:
#   https://downloads.raspberrypi.org/raspios_lite_arm64
#   https://downloads.raspberrypi.org/raspios_arm64/

param (
  [Parameter(Mandatory=$true)][string]$ifile,
  [Parameter(Mandatory=$true)][string]$device,
  [string]$wpa,
  [string]$usr
)

C:\CommandLineDiskImager\CommandLineDiskImager.exe $ifile $device
sleep 10
if ($PSBoundParameters.ContainsKey('wpa')) {
    echo "" "copy $wpa '${device}:\wpa_supplicant.conf'"
    copy $wpa "${device}:\wpa_supplicant.conf"
}
if ($PSBoundParameters.ContainsKey('usr')) {
  echo "" "copy $usr '${device}:\userconf.txt'"
  copy $usr "${device}:\userconf.txt"
}
echo "" >>"${device}:\ssh"
sleep 5
$driveEject = New-Object -comObject Shell.Application
$driveEject.Namespace(17).ParseName("${device}:").InvokeVerb("Eject")
