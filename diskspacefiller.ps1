# Infinite loop to fill disk space
while ($true) {
    # Generate a unique filename using a random number
    $fileName = "$(Get-Random).txt"
    
    # Create a 1GB file instantly
    fsutil file createnew $fileName 1gb
    
    Write-Host "Created $fileName (1GB added)" -ForegroundColor Yellow
}
