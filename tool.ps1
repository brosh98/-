# استدعاء مكتبات الواجهة الرسومية
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ==========================================
# 1. مكتبة البرامج (يمكنك إضافة المزيد هنا)
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
$form.Size = New-Object System.Drawing.Size(650, 500)
$form.StartPosition = "CenterScreen"
$form.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
$form.RightToLeftLayout = $true
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Dock = 'Fill'

# ==========================================
# التبويب الأول: مكتبة البرامج
# ==========================================
$tabPrograms = New-Object System.Windows.Forms.TabPage
$tabPrograms.Text = "تثبيت البرامج الأساسية"

# قائمة الاختيار المتعدد للبرامج
$checkedListBoxPrograms = New-Object System.Windows.Forms.CheckedListBox
$checkedListBoxPrograms.Location = New-Object System.Drawing.Point(20, 20)
$checkedListBoxPrograms.Size = New-Object System.Drawing.Size(580, 300)
$checkedListBoxPrograms.CheckOnClick = $true

foreach ($prog in $ProgramsLibrary) {
    [void]$checkedListBoxPrograms.Items.Add($prog.Name)
}

$btnInstallSelected = New-Object System.Windows.Forms.Button
$btnInstallSelected.Text = "تثبيت البرامج المحددة صامتاً"
$btnInstallSelected.Location = New-Object System.Drawing.Point(20, 330)
$btnInstallSelected.Size = New-Object System.Drawing.Size(580, 40)
$btnInstallSelected.BackColor = [System.Drawing.Color]::LightGreen
$btnInstallSelected.Add_Click({
    $btnInstallSelected.Text = "جاري التثبيت... يرجى الانتظار"
    $btnInstallSelected.Enabled = $false
    
    foreach ($item in $checkedListBoxPrograms.CheckedItems) {
        $progID = ($ProgramsLibrary | Where-Object { $_.Name -eq $item }).ID
        # التثبيت الصامت عبر Winget
        Start-Process winget -ArgumentList "install --id $progID --exact --silent --accept-package-agreements --accept-source-agreements" -Wait -WindowStyle Hidden
    }
    
    [System.Windows.Forms.MessageBox]::Show("تم الانتهاء من تثبيت البرامج المحددة!")
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
$tabTweaks.Text = "الثيمات وتحسينات النظام"

$btnDarkTheme = New-Object System.Windows.Forms.Button
$btnDarkTheme.Text = "تفعيل الوضع الليلي الشامل"
$btnDarkTheme.Location = New-Object System.Drawing.Point(20, 30)
$btnDarkTheme.Size = New-Object System.Drawing.Size(280, 45)
$btnDarkTheme.Add_Click({
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -ErrorAction SilentlyContinue
    [System.Windows.Forms.MessageBox]::Show("تم تفعيل الوضع الليلي.")
})

$btnShowExtensions = New-Object System.Windows.Forms.Button
$btnShowExtensions.Text = "إظهار امتدادات الملفات (مهم)"
$btnShowExtensions.Location = New-Object System.Drawing.Point(320, 30)
$btnShowExtensions.Size = New-Object System.Drawing.Size(280, 45)
$btnShowExtensions.Add_Click({
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
    Stop-Process -Name explorer -Force
})

$tabTweaks.Controls.Add($btnDarkTheme)
$tabTweaks.Controls.Add($btnShowExtensions)
$tabs.Controls.Add($tabTweaks)

# ==========================================
# التبويب الثالث: مكتبة التعاريف
# ==========================================
$tabDrivers = New-Object System.Windows.Forms.TabPage
$tabDrivers.Text = "التعاريف"

$lblDrivers = New-Object System.Windows.Forms.Label
$lblDrivers.Text = "اختر مصدر تحديث التعاريف الخاص بك:"
$lblDrivers.Location = New-Object System.Drawing.Point(20, 20)
$lblDrivers.AutoSize = $true

$btnWindowsUpdate = New-Object System.Windows.Forms.Button
$btnWindowsUpdate.Text = "جلب التعاريف من سيرفرات ويندوز"
$btnWindowsUpdate.Location = New-Object System.Drawing.Point(20, 60)
$btnWindowsUpdate.Size = New-Object System.Drawing.Size(580, 45)
$btnWindowsUpdate.Add_Click({
    Start-Process "ms-settings:windowsupdate-action"
})

$btnSDI = New-Object System.Windows.Forms.Button
$btnSDI.Text = "تحميل وتشغيل Snappy Driver (لكافة الأجهزة)"
$btnSDI.Location = New-Object System.Drawing.Point(20, 120)
$btnSDI.Size = New-Object System.Drawing.Size(580, 45)
$btnSDI.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("سيتم الآن فتح صفحة أداة Snappy Driver Lite، وهي أفضل أداة مجانية لجلب أي تعريف مفقود.")
    Start-Process "https://sdi-tool.org/download/"
})

$tabDrivers.Controls.Add($lblDrivers)
$tabDrivers.Controls.Add($btnWindowsUpdate)
$tabDrivers.Controls.Add($btnSDI)
$tabs.Controls.Add($tabDrivers)

# ==========================================
# التبويب الرابع: نسخ الأنظمة (ISO)
# ==========================================
$tabISOs = New-Object System.Windows.Forms.TabPage
$tabISOs.Text = "تحميل الأنظمة (ISO)"

$btnWin11 = New-Object System.Windows.Forms.Button
$btnWin11.Text = "تحميل Windows 11 الرسمي"
$btnWin11.Location = New-Object System.Drawing.Point(20, 30)
$btnWin11.Size = New-Object System.Drawing.Size(280, 45)
$btnWin11.Add_Click({ Start-Process "https://www.microsoft.com/software-download/windows11" })

$btnUbuntu = New-Object System.Windows.Forms.Button
$btnUbuntu.Text = "تحميل توزيعة Ubuntu (لينكس)"
$btnUbuntu.Location = New-Object System.Drawing.Point(320, 30)
$btnUbuntu.Size = New-Object System.Drawing.Size(280, 45)
$btnUbuntu.Add_Click({ Start-Process "https://ubuntu.com/download/desktop" })

$btnRufus = New-Object System.Windows.Forms.Button
$btnRufus.Text = "تحميل أداة الحرق Rufus"
$btnRufus.Location = New-Object System.Drawing.Point(170, 90)
$btnRufus.Size = New-Object System.Drawing.Size(280, 45)
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
