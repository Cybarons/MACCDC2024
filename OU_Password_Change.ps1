get-aduser -filter * -searchbase "OU Distinguished Name" -Properties * | Select-Object Name | Export-Csv C:\Users\Administrator\Desktop\Users.csv
$User = Get-Content -Path C:\Users\Administrator\Desktop\AD_Info\Users.csv | Select-Object -Skip 2 | ForEach-Object {$_ -replace '"',''}
$Pass = Get-Content -Path C:\Users\Administrator\Desktop\AD_Info\Password.csv #Password.txt name would be replace with a the name of the file where we store randomly generated passwords
Out-File C:\Users\Administrator\Desktop\AD_Info\Output.csv
foreach ($line in $User){
$New_Pass = Get-Random -InputObject($Pass)
$Username = $line
Set-ADAccountPassword -Identity $line -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $New_Pass -Force)
echo("Username: `t"+$Username+"`rPassword:`t"+$New_Pass+"`n")
echo("Username: `t"+$Username+"`rPassword:`t"+$New_Pass+"`n") | Out-File -Append C:\Users\Administrator\Desktop\AD_Info\Output.csv
}