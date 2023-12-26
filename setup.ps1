# Run this if error: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

#Util function
function Write-Start {
	param ($msg)
	Write-Host (">>" +$msg) -ForegroundColor Green
}
function Write-done { Write-Host "DONE" -ForegroundColor Blue; Write-Host }


#Start 
Start-Process -Wait powershell -verb runas -ArgumentList "Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromtBehaviorAdmin -Value 0"

Write-Start -msg "Installing Scoop..."
if (Get-Command scoop -errorAction SilentlyContinue)
{
	Write-Warning "Scoop already installed"
}
else {
	Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
	irm get.scoop.sh | iex
}
Write-Done

Write-Start -msg "Initializing Scoop..."
	scoop install git
	scoop bucket add extras
	scoop update
Write-done

Write-Start -msg "Installing Scoop's packages"
	scoop install googlechrome
	scoop install vscode
	scoop install vcredist-aio
	scoop install firefox
Write-done