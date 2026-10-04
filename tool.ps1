# استدعاء مكتبات الواجهة الرسومية
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ==========================================
# إعدادات الألوان (الثيم الليلي العصري)
# ==========================================
$BgColor      = [System.Drawing.Color]::FromArgb(30, 30, 46)   # لون الخلفية الداكن
$TabColor     = [System.Drawing.Color]::FromArgb(40, 40, 60)   # لون التبويبات
$AccentColor  = [System.Drawing.Color]::FromArgb(60, 60, 85)   # لون الأزرار
$HoverColor   = [System.Drawing.Color]::FromArgb(90, 90, 120)  # لون الأزرار عند تمرير الماوس
$TextColor    = [System.Drawing.Color]::White                  # لون النص الفاتح

# دالة مساعدة لتطبيق الثيم على الأزرار
function Set-ModernButton ($btn) {
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 0
    $btn.BackColor = $AccentColor
    $btn.ForeColor = $TextColor
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    
    # تأثير مرور الماوس
    $btn.Add_MouseEnter({ $this.BackColor = $HoverColor })
    $btn.Add_MouseLeave({ $this.BackColor = $AccentColor })
}

# ==========================================
# 1. مكتبة البرامج 
# ==========================================
$ProgramsLibrary = @(
    @{ Name = "متصفح Google Chrome"; ID = "Google.Chrome" }
    @{ Name = "متصفح Firefox"; ID = "Mozilla.Firefox" }
    @{ Name = "مشغل VLC"; ID = "VideoLAN.VLC" }
    @{ Name = "برنامج 7-Zip"; ID = "7zip.7zip" }
    @{ Name = "برنامج WinRAR"; ID = "RARLab.WinRAR" }
    @{ Name = "محرر VS Code"; ID = "Microsoft.VisualStudioCode" }
    @{ Name = "برنامج Telegram"; ID = "Telegram.TelegramDesktop" }
)

# ==========================================
# إعدادات النافذة الرئيسية
# ==========================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "مكتبة النظام الشاملة - الإصدار المتقدم"
$form.Size = New-Object System.Drawing.Size(650, 520)
$form.StartPosition = "CenterScreen"
$form.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
$form.RightToLeftLayout = $true
$form.BackColor = $BgColor
$form.ForeColor = $TextColor
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

# ==========================================
# إعدادات شريط التبويبات (برمجة الألوان للتابات)
# ==========================================
$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Dock = 'Fill'
$tabs.DrawMode = [System.Windows.Forms.TabDrawMode]::OwnerDrawFixed
$tabs.SizeMode = [System.Windows.Forms.TabSizeMode]::Fixed
$tabs.ItemSize = New-Object System.Drawing.Size(145, 35)

$tabs.Add_DrawItem({
    param($sender, $e)
    $g = $e.Graphics
    $tabRect = $e.Bounds
    $font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush($TabColor)
    $textBrush = New-Object System.Drawing.SolidBrush($TextColor)
    
    if ($e.State -match "Selected") {
        $brush.Color = $AccentColor
    }
    
    $g.FillRectangle($brush, $tabRect)
    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    $text = $sender.TabPages[$e.Index].Text
    $g.DrawString($text, $font, $textBrush, $tabRect, $format)
})

# ==========================================
# التبويب الأول: مكتبة البرامج
# ==========================================
$tabPrograms = New-Object System.Windows.Forms.TabPage
$tabPrograms.Text = "البرامج الأساسية"
$tabPrograms.BackColor = $BgColor

$checkedListBoxPrograms = New-Object System.Windows.Forms.CheckedListBox
$checkedListBoxPrograms.Location = New-Object System.Drawing.Point(20, 20)
$checkedListBoxPrograms.Size = New-Object System.Drawing.Size(580, 300)
$checkedListBoxPrograms.CheckOnClick = $true
$checkedListBoxPrograms.BackColor = $TabColor
$checkedListBoxPrograms.ForeColor = $TextColor
$checkedListBoxPrograms.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$checkedListBoxPrograms.Font = New-Object System.Drawing.Font("Segoe UI", 11)

foreach ($prog in $ProgramsLibrary) {
    [void]$checkedListBoxPrograms.Items.Add($prog.Name)
}

$btnInstallSelected = New-Object System.Windows.Forms.Button
$btnInstallSelected.Text = "تثبيت البرامج المحددة صامتاً"
$btnInstallSelected.Location = New-Object System.Drawing.Point(20, 340)
$btnInstallSelected.Size = New-Object System.Drawing.Size(580, 50)
Set-ModernButton $btnInstallSelected
$btnInstallSelected.BackColor = [System.Drawing.Color]::FromArgb(46, 139, 87) # لون أخضر للتميز

$btnInstallSelected.Add_Click({
    $btnInstallSelected.Text = "جاري التثبيت... يرجى الانتظار"
    $btnInstallSelected.Enabled = $false
    
    foreach ($item in $checkedListBoxPrograms.CheckedItems) {
        $progID = ($ProgramsLibrary | Where-Object { $_.Name -eq $item }).ID
        Start-Process winget -ArgumentList "install --id $progID --exact --silent --accept-package-agreements --accept-source-agreements" -Wait -WindowStyle Hidden
    }
    
    [System.Windows.Forms.MessageBox]::Show("تم الانتهاء من تثبيت البرامج المحددة!", "نجاح", 0, [System.Windows.Forms.MessageBoxIcon]::Information)
    $btnInstallSelected.Text = "تثبيت البرامج المحددة صامتاً"
    $btnInstallSelected.Enabled = $true
})

$tabPrograms.Controls.Add($checkedListBoxPrograms)
$tabPrograms.Controls.Add($btnInstallSelected)
$tabs.Controls.Add($tabPrograms)

# ==========================================
# التبويب الثاني: الثيمات والتحسينات
# ==========================================
$tabTweaks = New-Object System.Windows.Forms.TabPage
$tabTweaks.Text = "تخصيص النظام"
$tabTweaks.BackColor = $BgColor

$btnDarkTheme = New-Object System.Windows.Forms.Button
$btnDarkTheme.Text = "تفعيل الوضع الليلي للويندوز"
$btnDarkTheme.Location = New-Object System.Drawing.Point(30, 40)
$btnDarkTheme.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnDarkTheme
$btnDarkTheme.Add_Click({
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -ErrorAction SilentlyContinue
    [System.Windows.Forms.MessageBox]::Show("تم تفعيل الوضع الليلي.", "تم بنجاح")
})

$btnShowExtensions = New-Object System.Windows.Forms.Button
$btnShowExtensions.Text = "إظهار امتدادات الملفات المخفية"
$btnShowExtensions.Location = New-Object System.Drawing.Point(30, 110)
$btnShowExtensions.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnShowExtensions
$btnShowExtensions.Add_Click({
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
    Stop-Process -Name explorer -Force
})

$tabTweaks.Controls.Add($btnDarkTheme)
$tabTweaks.Controls.Add($btnShowExtensions)
$tabs.Controls.Add($tabTweaks)

# ==========================================
# التبويب الثالث: مكتبة التعاريف (مع SDIO)
# ==========================================
$tabDrivers = New-Object System.Windows.Forms.TabPage
$tabDrivers.Text = "إدارة التعاريف"
$tabDrivers.BackColor = $BgColor

$btnWindowsUpdate = New-Object System.Windows.Forms.Button
$btnWindowsUpdate.Text = "بحث عن تحديثات التعاريف (Windows Update)"
$btnWindowsUpdate.Location = New-Object System.Drawing.Point(30, 40)
$btnWindowsUpdate.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnWindowsUpdate
$btnWindowsUpdate.Add_Click({
    Start-Process "ms-settings:windowsupdate-action"
})

$btnSDIO = New-Object System.Windows.Forms.Button
$btnSDIO.Text = "تثبيت Snappy Driver Installer Origin (SDIO)"
$btnSDIO.Location = New-Object System.Drawing.Point(30, 110)
$btnSDIO.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnSDIO
$btnSDIO.BackColor = [System.Drawing.Color]::FromArgb(70, 130, 180) # لون أزرق مميز للبرنامج

$btnSDIO.Add_Click({
    $btnSDIO.Text = "جاري تحميل وتثبيت الأداة... يرجى الانتظار"
    $btnSDIO.Enabled = $false
    
    Start-Process winget -ArgumentList "install --id GlennDelahoy.SnappyDriverInstallerOrigin --exact --silent --accept-package-agreements --accept-source-agreements" -Wait -WindowStyle Hidden
    
    [System.Windows.Forms.MessageBox]::Show("تم تثبيت Snappy Driver Installer Origin بنجاح!", "نجاح", 0, [System.Windows.Forms.MessageBoxIcon]::Information)
    $btnSDIO.Text = "تثبيت Snappy Driver Installer Origin (SDIO)"
    $btnSDIO.Enabled = $true
})

$tabDrivers.Controls.Add($btnWindowsUpdate)
$tabDrivers.Controls.Add($btnSDIO)
$tabs.Controls.Add($tabDrivers)

# ==========================================
# التبويب الرابع: نسخ الأنظمة (ISO)
# ==========================================
$tabISOs = New-Object System.Windows.Forms.TabPage
$tabISOs.Text = "نسخ الأنظمة ISO"
$tabISOs.BackColor = $BgColor

$btnWin11 = New-Object System.Windows.Forms.Button
$btnWin11.Text = "تحميل Windows 11 الرسمي"
$btnWin11.Location = New-Object System.Drawing.Point(30, 40)
$btnWin11.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnWin11
$btnWin11.Add_Click({ Start-Process "https://www.microsoft.com/software-download/windows11" })

$btnUbuntu = New-Object System.Windows.Forms.Button
$btnUbuntu.Text = "تحميل توزيعة Ubuntu Linux"
$btnUbuntu.Location = New-Object System.Drawing.Point(30, 110)
$btnUbuntu.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnUbuntu
$btnUbuntu.Add_Click({ Start-Process "https://ubuntu.com/download/desktop" })

$btnRufus = New-Object System.Windows.Forms.Button
$btnRufus.Text = "تحميل أداة الحرق Rufus"
$btnRufus.Location = New-Object System.Drawing.Point(30, 180)
$btnRufus.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnRufus
$btnRufus.BackColor = [System.Drawing.Color]::FromArgb(184, 134, 11) # لون ذهبي/برتقالي لأداة الحرق
$btnRufus.Add_Click({ Start-Process "https://rufus.ie/" })

$tabISOs.Controls.Add($btnWin11)
$tabISOs.Controls.Add($btnUbuntu)
$tabISOs.Controls.Add($btnRufus)
$tabs.Controls.Add($tabISOs)

# ==========================================
# تشغيل الواجهة
# ==========================================
$form.Controls.Add($tabs)
[void]$form.ShowDialog()
