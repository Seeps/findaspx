#@Seeps

Write-Host "`nThis script will search for recently created .aspx files owned by the SYSTEM user`nPlease run it with Administrator rights`nAccess denied errors may occur due to the lack of permissions for the user context the script is running under (typically occurs for hidden files/folders)"

$SYSDRIVE = Read-Host -Prompt 'Enter the drive letter (default is C)'

$FindDate=Get-Date -Year 2021 -Month 02 -Day 24

Get-Childitem -Path ${SYSDRIVE}:\ -Include *.aspx -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $FindDate } | Get-Acl | Select-Object Owner,Path | Where-Object Owner -like *system