#@github.com/Seeps

Write-Host "`nThis script will search for recently created .aspx files owned by the SYSTEM user`nPlease run it with Administrator rights`nAccess denied errors may occur due to the lack of permissions for the user context the script is running under (typically occurs for hidden files/folders)`n`nNOTE: This has not been thoroughly tested; use at your own risk!`n"

$SYSDRIVE = Read-Host -Prompt 'Enter the drive letter (default is C)'

$DATE=Get-Date -Year 2021 -Month 01 -Day 01

New-Item ${SYSDRIVE}:\CIR -type directory

Get-Childitem -Path ${SYSDRIVE}:\ -Include *.aspx, *.asmx, *.php -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $DATE } | Get-Acl | Where-Object Owner -like *system | Select-Object Path -ExpandProperty Access | select Path | Format-Table -AutoSize -Wrap >> ${SYSDRIVE}:\CIR\filepath.txt 
Get-Childitem -Path ${SYSDRIVE}:\ -Include *.aspx, *.asmx, *.php -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $DATE } | Get-Acl | Select-Object Owner,Path | Where-Object Owner -like *system | Copy-Item -Destination ${SYSDRIVE}:\CIR
Compress-Archive ${SYSDRIVE}:\CIR ${SYSDRIVE}:\CIR\zippedCIR.zip
