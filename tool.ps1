# استدعاء مكتبات الواجهة الرسومية
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ==========================================
# محرك الثيمات (Theme Engine)
# ==========================================
$global:AllButtons = @()

# مصفوفة الثيمات المتوفرة (يمكنك التعديل على الألوان بنظام Hex)
$global:Themes = @(
    @{ Name="الوضع الليلي (Dark)";    Bg="#1E1E2E"; Tab="#28283C"; Btn="#3C3C55"; High="#2E8B57"; Text="#FFFFFF" },
    @{ Name="قرصنة (Matrix Hacker)"; Bg="#0D1117"; Tab="#161B22"; Btn="#0F5323"; High="#238636"; Text="#39FF14" },
    @{ Name="أعماق المحيط (Ocean)";   Bg="#0F172A"; Tab="#1E293B"; Btn="#1E3A8A"; High="#0284C7"; Text="#E0F2FE" },
    @{ Name="الوضع الدموي (Crimson)"; Bg="#1A0505"; Tab="#2B0909"; Btn="#4A0E0E"; High="#991B1B"; Text="#FECACA" },
    @{ Name="الوضع الفاتح (Light)";   Bg="#F3F4F6"; Tab="#E5E7EB"; Btn="#D1D5DB"; High="#3B82F6"; Text="#1F2937" }
)

# دالة مساعدة لتسجيل الأزرار وتجهيزها
function Set-ModernButton ($btn, $isHighlight = $false) {
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 0
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    if ($isHighlight) { $btn.Tag = "Highlight" } else { $btn.Tag = "Normal" }
    $global:AllButtons += $btn
}

# دالة تغيير الثيم وتطبيقه على كافة عناصر الأداة
function Change-Theme($Index) {
    $t = $global:Themes[$Index]
    $bg = [System.Drawing.ColorTranslator]::FromHtml($t.Bg)
    $tab = [System.Drawing.ColorTranslator]::FromHtml($t.Tab)
    $btnBg = [System.Drawing.ColorTranslator]::FromHtml($t.Btn)
    $high = [System.Drawing.ColorTranslator]::FromHtml($t.High)
    $txt = [System.Drawing.ColorTranslator]::FromHtml($t.Text)

    # حفظ المتغيرات لرسم شريط التبويبات
    $global:CurrentTabColor = $tab
    $global:CurrentAccentColor = $btnBg
    $global:CurrentTextColor = $txt

    # تغيير لون النافذة
    $form.BackColor = $bg
    $form.ForeColor = $txt

    # تغيير لون التبويبات الداخلية
    foreach ($tp in $tabs.TabPages) { $tp.BackColor = $bg }

    # تغيير لون قائمة البرامج
    $checkedListBoxPrograms.BackColor = $tab
    $checkedListBoxPrograms.ForeColor = $txt

    # تغيير لون القائمة المنسدلة للثيمات
    $cmbTheme.BackColor = $tab
    $cmbTheme.ForeColor = $txt

    # تحديث كافة الأزرار مع تأثيرات المرور (Hover)
    foreach ($btn in $global:AllButtons) {
        if ($btn.Tag -eq "Highlight") {
            $btn.BackColor = $high
            $btn.FlatAppearance.MouseOverBackColor = [System.Windows.Forms.ControlPaint]::Light($high)
        } else {
            $btn.BackColor = $btnBg
            $btn.FlatAppearance.MouseOverBackColor = [System.Windows.Forms.ControlPaint]::Light($btnBg)
        }
        $btn.ForeColor = $txt
    }
    $tabs.Invalidate() # إجبار شريط التبويبات على إعادة الرسم بالألوان الجديدة
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
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

# ==========================================
# إعدادات شريط التبويبات (رسم مخصص)
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
    $brush = New-Object System.Drawing.SolidBrush($global:CurrentTabColor)
    $textBrush = New-Object System.Drawing.SolidBrush($global:CurrentTextColor)
    
    if ($e.State -match "Selected") { $brush.Color = $global:CurrentAccentColor }
    
    $g.FillRectangle($brush, $tabRect)
    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    $text = $sender.TabPages[$e.Index].Text
    $g.DrawString($text, $font, $textBrush, $tabRect, $format)
    
    $brush.Dispose(); $textBrush.Dispose()
})

# ==========================================
# التبويب الأول: مكتبة البرامج
# ==========================================
$tabPrograms = New-Object System.Windows.Forms.TabPage
$tabPrograms.Text = "البرامج الأساسية"

$checkedListBoxPrograms = New-Object System.Windows.Forms.CheckedListBox
$checkedListBoxPrograms.Location = New-Object System.Drawing.Point(20, 20)
$checkedListBoxPrograms.Size = New-Object System.Drawing.Size(580, 280)
$checkedListBoxPrograms.CheckOnClick = $true
$checkedListBoxPrograms.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$checkedListBoxPrograms.Font = New-Object System.Drawing.Font("Segoe UI", 11)

foreach ($prog in $ProgramsLibrary) { [void]$checkedListBoxPrograms.Items.Add($prog.Name) }

$btnInstallSelected = New-Object System.Windows.Forms.Button
$btnInstallSelected.Text = "تثبيت البرامج المحددة صامتاً"
$btnInstallSelected.Location = New-Object System.Drawing.Point(20, 330)
$btnInstallSelected.Size = New-Object System.Drawing.Size(580, 50)
Set-ModernButton $btnInstallSelected $true # زر مميز (Highlight)

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

# --- قائمة تغيير ثيم الأداة ---
$lblTheme = New-Object System.Windows.Forms.Label
$lblTheme.Text = "مظهر الأداة:"
$lblTheme.AutoSize = $true
$lblTheme.Location = New-Object System.Drawing.Point(30, 20)

$cmbTheme = New-Object System.Windows.Forms.ComboBox
$cmbTheme.Location = New-Object System.Drawing.Point(30, 45)
$cmbTheme.Size = New-Object System.Drawing.Size(560, 30)
$cmbTheme.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$cmbTheme.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
foreach ($t in $global:Themes) { [void]$cmbTheme.Items.Add($t.Name) }
$cmbTheme.SelectedIndex = 0
$cmbTheme.Add_SelectedIndexChanged({ Change-Theme $cmbTheme.SelectedIndex })

# --- أزرار النظام ---
$btnDarkTheme = New-Object System.Windows.Forms.Button
$btnDarkTheme.Text = "تفعيل الوضع الليلي للويندوز"
$btnDarkTheme.Location = New-Object System.Drawing.Point(30, 100)
$btnDarkTheme.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnDarkTheme
$btnDarkTheme.Add_Click({
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -ErrorAction SilentlyContinue
    [System.Windows.Forms.MessageBox]::Show("تم تفعيل الوضع الليلي للويندوز.", "تم بنجاح")
})

$btnShowExtensions = New-Object System.Windows.Forms.Button
$btnShowExtensions.Text = "إظهار امتدادات الملفات المخفية"
$btnShowExtensions.Location = New-Object System.Drawing.Point(30, 170)
$btnShowExtensions.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnShowExtensions
$btnShowExtensions.Add_Click({
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
    Stop-Process -Name explorer -Force
})

$tabTweaks.Controls.Add($lblTheme)
$tabTweaks.Controls.Add($cmbTheme)
$tabTweaks.Controls.Add($btnDarkTheme)
$tabTweaks.Controls.Add($btnShowExtensions)
$tabs.Controls.Add($tabTweaks)

# ==========================================
# التبويب الثالث: مكتبة التعاريف (مع SDIO)
# ==========================================
$tabDrivers = New-Object System.Windows.Forms.TabPage
$tabDrivers.Text = "إدارة التعاريف"

$btnWindowsUpdate = New-Object System.Windows.Forms.Button
$btnWindowsUpdate.Text = "بحث عن تحديثات التعاريف (Windows Update)"
$btnWindowsUpdate.Location = New-Object System.Drawing.Point(30, 40)
$btnWindowsUpdate.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnWindowsUpdate

$btnSDIO = New-Object System.Windows.Forms.Button
$btnSDIO.Text = "تثبيت Snappy Driver Installer Origin (SDIO)"
$btnSDIO.Location = New-Object System.Drawing.Point(30, 110)
$btnSDIO.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnSDIO $true # زر مميز (Highlight)

$btnSDIO.Add_Click({
    $btnSDIO.Text = "جاري تحميل وتثبيت الأداة... يرجى الانتظار"
    $btnSDIO.Enabled = $false
    Start-Process winget -ArgumentList "install --id GlennDelahoy.SnappyDriverInstallerOrigin --exact --silent --accept-package-agreements --accept-source-agreements" -Wait -WindowStyle Hidden
    [System.Windows.Forms.MessageBox]::Show("تم تثبيت Snappy Driver بنجاح!", "نجاح", 0, [System.Windows.Forms.MessageBoxIcon]::Information)
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

$btnWin11 = New-Object System.Windows.Forms.Button
$btnWin11.Text = "تحميل Windows 11 الرسمي"
$btnWin11.Location = New-Object System.Drawing.Point(30, 40)
$btnWin11.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnWin11

$btnUbuntu = New-Object System.Windows.Forms.Button
$btnUbuntu.Text = "تحميل توزيعة Ubuntu Linux"
$btnUbuntu.Location = New-Object System.Drawing.Point(30, 110)
$btnUbuntu.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnUbuntu

$btnRufus = New-Object System.Windows.Forms.Button
$btnRufus.Text = "تحميل أداة الحرق Rufus"
$btnRufus.Location = New-Object System.Drawing.Point(30, 180)
$btnRufus.Size = New-Object System.Drawing.Size(560, 55)
Set-ModernButton $btnRufus $true # زر مميز (Highlight)
$btnRufus.Add_Click({ Start-Process "https://rufus.ie/" })

$tabISOs.Controls.Add($btnWin11)
$tabISOs.Controls.Add($btnUbuntu)
$tabISOs.Controls.Add($btnRufus)
$tabs.Controls.Add($tabISOs)

# ==========================================
# تشغيل الواجهة
# ==========================================
Change-Theme 0 # تطبيق الثيم الأول الافتراضي عند التشغيل
$form.Controls.Add($tabs)
[void]$form.ShowDialog()
