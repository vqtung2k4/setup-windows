# Run this if error: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

#Util function
function Write-Start {
	param ($msg)
	Write-Host (">>" +$msg) -ForegroundColor Green
}
function Write-done { Write-Host "DONE" -ForegroundColor Blue; Write-Host }


#Start 

# Admin Access
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
	scoop install winrar
Write-done

Write-Start -msg "Configuring VSCode"
	code --install-extension ritwickdey.LiveServer
Write-done

Write-Start -msg "Enable Virtualization"
Start-Process -Wait powershell 0verb runas -ArgumentList @"
	echo y | Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All"@
Write-done

Write-Start -msg "Installing WSL..."
If(!(wsl -l -v)) {
	wsl --install
	wsl --update
	wsl --install --no-launch --web-download -d Ubuntu
}
Else {
	Write-Warning "WSL installed"
}
Write-done