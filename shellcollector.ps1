#@github.com/Seeps

Write-Host "`nThis script will search for recently created .aspx files owned by the SYSTEM user`nPlease run it with Administrator rights`nAccess denied errors may occur due to the lack of permissions for the user context the script is running under (typically occurs for hidden files/folders)`n`nNOTE: This has not been thoroughly tested; use at your own risk!`n"

$SYSDRIVE = Read-Host -Prompt 'Enter the drive letter (default is C)'

$DATE=Get-Date -Year 2021 -Month 01 -Day 01

$HOSTNAME=(Get-WmiObject Win32_ComputerSystem).Name

$DOMAIN=(Get-WmiObject Win32_ComputerSystem).Domain

New-Item ${SYSDRIVE}:\CIR -type directory

Copy-Item -Path "${SYSDRIVE}:\Windows\System32\winevt\Logs\System.evtx" -Destination ${SYSDRIVE}:\CIR
Copy-Item -Path "${SYSDRIVE}:\Windows\System32\winevt\Logs\Application.evtx" -Destination ${SYSDRIVE}:\CIR
Copy-Item -Path "${SYSDRIVE}:\Windows\System32\winevt\Logs\Microsoft-Windows-Windows Defender%4Operational.evtx" -Destination ${SYSDRIVE}:\CIR
Copy-Item -Path "${SYSDRIVE}:\Windows\System32\winevt\Logs\Microsoft-Windows-TaskScheduler%4Operational.evtx" -Destination ${SYSDRIVE}:\CIR
Copy-Item -Path "${SYSDRIVE}:\Windows\System32\winevt\Logs\Windows PowerShell.evtx" -Destination ${SYSDRIVE}:\CIR
Copy-Item -Path "${SYSDRIVE}:\Windows\System32\winevt\Logs\Microsoft-Windows-PowerShell%4Operational.evtx" -Destination ${SYSDRIVE}:\CIR
Copy-Item -Path "${SYSDRIVE}:\Windows\System32\winevt\Logs\MSExchange Management.evtx" -Destination ${SYSDRIVE}:\CIR

Select-String -Path "$env:PROGRAMFILES\Microsoft\Exchange Server\V15\Logging\ECP\Server\*.log" -Pattern 'Set-.+VirtualDirectory' | Copy-Item -Destination ${SYSDRIVE}:\CIR

Get-Childitem -Path ${SYSDRIVE}:\ -Include *.aspx, *.asmx, *.php -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $DATE } | Get-Acl | Select-Object Owner,Path | Where-Object Owner -like *system | Copy-Item -Destination ${SYSDRIVE}:\CIR
Get-ChildItem -Path "${SYSDRIVE}:\CIR" -Recurse -Force -File -Exclude hashes.txt, *.evtx, *.log | 
    Get-FileHash | 
    Sort-Object -Property 'Path' |
    Export-Csv -Path "${SYSDRIVE}:\CIR\hashes.txt" -NoTypeInformation
Compress-Archive ${SYSDRIVE}:\CIR ${SYSDRIVE}:\CIR\${HOSTNAME}_${DOMAIN}_SC.zip
