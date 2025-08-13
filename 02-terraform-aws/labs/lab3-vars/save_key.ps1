# PowerShell script לשמירת Private Key
# הרץ את הסקריפט הזה אחרי ש-Terraform מסיים ליצור את המשאבים

Write-Host "🔑 שמירת Private Key לקובץ..." -ForegroundColor Green

# קבלת ה-output של Private Key מ-Terraform
$private_key = terraform output -raw private_key

if ($private_key) {
    # שמירת ה-Key לקובץ .pem
    $key_file = "demo-keypair.pem"
    $private_key | Out-File -FilePath $key_file -Encoding ASCII
    
    # הגדרת הרשאות מתאימות לקובץ (חשוב ל-SSH)
    icacls $key_file /inheritance:r
    icacls $key_file /grant:r "$env:USERNAME:(R)"
    
    Write-Host "✅ Private Key נשמר בהצלחה לקובץ: $key_file" -ForegroundColor Green
    Write-Host "📁 הקובץ נמצא בתיקייה הנוכחית" -ForegroundColor Yellow
    Write-Host "🔐 השתמש בקובץ זה לחיבור SSH לשרת" -ForegroundColor Cyan
} else {
    Write-Host "❌ לא ניתן לקבל את ה-Private Key מ-Terraform" -ForegroundColor Red
    Write-Host "ודא ש-Terraform רץ בהצלחה ויש output של private_key" -ForegroundColor Yellow
}
