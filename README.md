# shellcollector

HAFNIUM campaign: https://www.microsoft.com/security/blog/2021/03/02/hafnium-targeting-exchange-servers/
<p>CVE-2021-26855</p>
<p>CVE-2021-26857<p>
<p>CVE-2021-27065<p>
<p>CVE-2021-26858<p>

This is a PowerShell script that will locate potential web shells created by the SYSTEM user from 1/1/2021 onwards.

Simply clone or download `shellcollector.ps1` and execute in PowerShell with admin privileges.

The script will copy and archive detected files in `%SYSTEMDRIVE%\CIR` along with the original file paths of each file collected.
