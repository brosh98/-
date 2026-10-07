# استدعاء مكتبات الواجهة الرسومية
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ==========================================
# محرك الثيمات (Theme Engine مع الخلفيات المتدرجة)
# ==========================================
$global:AllButtons = @()

$global:Themes = @(
    @{ Name="الوضع الليلي (Dark)";    Bg1="#181825"; Bg2="#11111B"; Tab="#252538"; Btn="#313244"; High="#A6E3A1"; Text="#CDD6F4" },
    @{ Name="قرصنة (Matrix Hacker)"; Bg1="#090D16"; Bg2="#020408"; Tab="#0D1117"; Btn="#0F5323"; High="#39FF14"; Text="#39FF14" },
    @{ Name="أعماق المحيط (Ocean)";   Bg1="#0F172A"; Bg2="#020617"; Tab="#1E293B"; Btn="#1E3A8A"; High="#38BDF8"; Text="#E0F2FE" },
    @{ Name="الوضع الدموي (Crimson)"; Bg1="#1A0505"; Bg2="#0B0202"; Tab="#2B0909"; Btn="#4A0E0E"; High="#EF4444"; Text="#FECACA" },
    @{ Name="الوضع الفاتح (Light)";   Bg1="#F9FAFB"; Bg2="#E5E7EB"; Tab="#FFFFFF"; Btn="#D1D5DB"; High="#2563EB"; Text="#1F2937" }
)

function Set-ModernButton ($btn, $isHighlight = $false) {
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 0
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    if ($isHighlight) { $btn.Tag = "Highlight" } else { $btn.Tag = "Normal" }
    $global:AllButtons += $btn
}

function Change-Theme($Index) {
    $t = $global:Themes[$Index]
    $global:CurrentBg1 = [System.Drawing.ColorTranslator]::FromHtml($t.Bg1)
    $global:CurrentBg2 = [System.Drawing.ColorTranslator]::FromHtml($t.Bg2)
    $global:CurrentTab = [System.Drawing.ColorTranslator]::FromHtml($t.Tab)
    $global:CurrentBtn = [System.Drawing.ColorTranslator]::FromHtml($t.Btn)
    $global:CurrentHigh = [System.Drawing.ColorTranslator]::FromHtml($t.High)
    $global:CurrentText = [System.Drawing.ColorTranslator]::FromHtml($t.Text)

    $form.ForeColor = $global:CurrentText
    foreach ($tp in $tabs.TabPages) { $tp.BackColor = $global:CurrentTab }

    $checkedListBoxPrograms.BackColor = $global:CurrentTab
    $checkedListBoxPrograms.ForeColor = $global:CurrentText
    $cmbTheme.BackColor = $global:CurrentTab
    $cmbTheme.ForeColor = $global:CurrentText

    foreach ($btn in $global:AllButtons) {
        if ($btn.Tag -eq "Highlight") {
            $btn.BackColor = $global:CurrentHigh
            if ($Index -eq 4) { $btn.ForeColor = [System.Drawing.Color]::White } else { $btn.ForeColor = [System.Drawing.Color]::Black }
            $btn.FlatAppearance.MouseOverBackColor = [System.Windows.Forms.ControlPaint]::Light($global:CurrentHigh)
        } else {
            $btn.BackColor = $global:CurrentBtn
            $btn.ForeColor = $global:CurrentText
            $btn.FlatAppearance.MouseOverBackColor = [System.Windows.Forms.ControlPaint]::Light($global:CurrentBtn)
        }
    }
    $form.Invalidate()
    $tabs.Invalidate()
}

# ==========================================
# 1. مكتبة البرامج والأدوات الموسعة
# ==========================================
$ProgramsLibrary = @(
    @{ Name = "[تصفح] Google Chrome"; ID = "Google.Chrome" }
    @{ Name = "[تصفح] Mozilla Firefox"; ID = "Mozilla.Firefox" }
    @{ Name = "[تصفح] Brave Browser"; ID = "Brave.Brave" }
    @{ Name = "[تصفح] Opera GX (متصفح الجيمرز)"; ID = "Opera.OperaGX" }
    
    @{ Name = "[تحميل] Internet Download Manager (IDM)"; ID = "ToneCamo.InternetDownloadManager" }
    @{ Name = "[تحميل] Neat Download Manager"; ID = "NeatDownloadManager.NeatDownloadManager" }
    @{ Name = "[تحميل] qBittorrent (تورنت)"; ID = "qBittorrent.qBittorrent" }

    @{ Name = "[حماية] Malwarebytes Antimalware"; ID = "Malwarebytes.Malwarebytes" }
    @{ Name = "[حماية] Bitdefender Antivirus Free"; ID = "Bitdefender.BitdefenderAntivirusFree" }
    @{ Name = "[حماية] Avast Free Antivirus"; ID = "Avast.AvastFreeAntivirus" }

    @{ Name = "[ميديا] VLC Media Player"; ID = "VideoLAN.VLC" }
    @{ Name = "[ميديا] PotPlayer (المشغل الأقوى)"; ID = "Kakao.PotPlayer" }
    @{ Name = "[ميديا] K-Lite Codec Pack Mega"; ID = "CodecGuide.K-LiteCodecPack.Mega" }
    @{ Name = "[ميديا] Audacity (محرر ومسجل الصوتيات)"; ID = "Audacity.Audacity" }

    @{ Name = "[ألعاب] Playnite (لانشر وتجميعة الألعاب)"; ID = "Playnite.Playnite" }
    @{ Name = "[ألعاب] RetroBat (واجهة محاكيات الألعاب الكلاسيكية)"; ID = "RetroBat.RetroBat" }
    @{ Name = "[ألعاب] PCSX2 (محاكي بلايستيشن 2)"; ID = "PCSX2.PCSX2" }
    @{ Name = "[ألعاب] RPCS3 (محاكي بلايستيشن 3)"; ID = "RPCS3.RPCS3" }
    @{ Name = "[ألعاب] Dolphin Emulator (محاكي GameCube / Wii)"; ID = "DolphinEmulator.Dolphin" }
    @{ Name = "[ألعاب] PPSSPP (محاكي PSP)"; ID = "PPSSPP.PPSSPP" }

    @{ Name = "[أدوات] 7-Zip (فك وضغط الملفات)"; ID = "7zip.7zip" }
    @{ Name = "[أدوات] WinRAR"; ID = "RARLab.WinRAR" }
    
    @{ Name = "[دردشة] Telegram Desktop"; ID = "Telegram.TelegramDesktop" }
    @{ Name = "[دردشة] WhatsApp Desktop"; ID = "WhatsApp.WhatsApp" }
    @{ Name = "[دردشة] Discord"; ID = "Discord.Discord" }
    
    @{ Name = "[مطورين] Visual Studio Code"; ID = "Microsoft.VisualStudioCode" }
    @{ Name = "[مطورين] Git (إدارة الكود)"; ID = "Git.Git" }
    @{ Name = "[مطورين] Python 3.11"; ID = "Python.Python.3.11" }
    
    @{ Name = "[صيانة] Revo Uninstaller (إزالة من الجذور)"; ID = "RevoUninstaller.RevoUninstaller" }
    @{ Name = "[صيانة] CCleaner (تنظيف النظام)"; ID = "Piriform.CCleaner" }
    @{ Name = "[صيانة] TeamViewer (الدعم عن بُعد)"; ID = "TeamViewer.TeamViewer" }
    @{ Name = "[صيانة] AnyDesk"; ID = "AnyDesk.AnyDesk" }
)

# ==========================================
# إعدادات النافذة الرئيسية (تفاعلية بخلفية متدرجة)
# ==========================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "مكتبة النظام الشاملة - Ultimate Toolbox"
$form.Size = New-Object System.Drawing.Size(720, 600)
$form.StartPosition = "CenterScreen"
$form.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
$form.RightToLeftLayout = $true
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false
$form.DoubleBuffered = $true # لمنع الوميض عند التحديث

# رسم خلفية متدرجة للنافذة الرئيسية
$form.Add_Paint({
    param($sender, $e)
    $rect = $e.ClipRectangle
    if ($global:CurrentBg1 -and $global:CurrentBg2) {
        $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $global:CurrentBg1, $global:CurrentBg2, 45.0)
        $e.Graphics.FillRectangle($brush, $rect)
        $brush.Dispose()
    }
})

# رأس الواجهة (Header / Logo)
$lblHeaderTitle = New-Object System.Windows.Forms.Label
$lblHeaderTitle.Text = "⚡ أداة الصيانة الشاملة وتثبيت البرامج"
$lblHeaderTitle.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$lblHeaderTitle.Location = New-Object System.Drawing.Point(20, 15)
$lblHeaderTitle.AutoSize = $true
$lblHeaderTitle.BackColor = [System.Drawing.Color]::Transparent
$form.Controls.Add($lblHeaderTitle)

# ==========================================
# إعدادات شريط التبويبات
# ==========================================
$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Location = New-Object System.Drawing.Point(20, 55)
$tabs.Size = New-Object System.Drawing.Size(665, 490)
$tabs.DrawMode = [System.Windows.Forms.TabDrawMode]::OwnerDrawFixed
$tabs.SizeMode = [System.Windows.Forms.TabSizeMode]::Fixed
$tabs.ItemSize = New-Object System.Drawing.Size(155, 35)
$tabs.BackColor = [System.Drawing.Color]::Transparent

$tabs.Add_DrawItem({
    param($sender, $e)
    $g = $e.Graphics
    $tabRect = $e.Bounds
    $font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush($global:CurrentTab)
    $textBrush = New-Object System.Drawing.SolidBrush($global:CurrentText)
    
    if ($e.State -match "Selected") { 
        $brush.Color = $global:CurrentHigh
        if ($cmbTheme.SelectedIndex -eq 4) { $textBrush.Color = [System.Drawing.Color]::White } else { $textBrush.Color = [System.Drawing.Color]::Black }
    }
    
    $g.FillRectangle($brush, $tabRect)
    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    $text = $sender.TabPages[$e.Index].Text
    $g.DrawString($text, $font, $textBrush, $tabRect, $format)
    
    $brush.Dispose(); $textBrush.Dispose()
})

# ==========================================
# التبويب الأول: مكتبة البرامج والألعاب
# ==========================================
$tabPrograms = New-Object System.Windows.Forms.TabPage
$tabPrograms.Text = "مكتبة البرامج والألعاب"

$checkedListBoxPrograms = New-Object System.Windows.Forms.CheckedListBox
$checkedListBoxPrograms.Location = New-Object System.Drawing.Point(15, 15)
$checkedListBoxPrograms.Size = New-Object System.Drawing.Size(625, 340)
$checkedListBoxPrograms.CheckOnClick = $true
$checkedListBoxPrograms.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$checkedListBoxPrograms.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)

foreach ($prog in $ProgramsLibrary) { [void]$checkedListBoxPrograms.Items.Add($prog.Name) }

# عداد تفاعلي يظهر عدد البرامج المحددة
$lblSelectedCount = New-Object System.Windows.Forms.Label
$lblSelectedCount.Text = "العناصر المحددة للتثبيت: 0"
$lblSelectedCount.Location = New-Object System.Drawing.Point(15, 362)
$lblSelectedCount.AutoSize = $true
$lblSelectedCount.BackColor = [System.Drawing.Color]::Transparent

$checkedListBoxPrograms.Add_ItemCheck({
    # تحديث العداد بعد تحديث الحالة بلحظة
    [System.Windows.Forms.Application]::DoEvents()
    $count = $checkedListBoxPrograms.CheckedItems.Count
    $lblSelectedCount.Text = "العناصر المحددة للتثبيت: $count"
})

$btnInstallSelected = New-Object System.Windows.Forms.Button
$btnInstallSelected.Text = "تثبيت العناصر المحددة صامتاً (Silent Install)"
$btnInstallSelected.Location = New-Object System.Drawing.Point(15, 388)
$btnInstallSelected.Size = New-Object System.Drawing.Size(625, 48)
Set-ModernButton $btnInstallSelected $true

$btnInstallSelected.Add_Click({
    if ($checkedListBoxPrograms.CheckedItems.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("يرجى تحديد عنصر واحد على الأقل من القائمة!", "تنبيه", 0, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }

    $btnInstallSelected.Text = "جاري التثبيت... يرجى الانتظار وعدم إغلاق الأداة"
    $btnInstallSelected.Enabled = $false
    
    foreach ($item in $checkedListBoxPrograms.CheckedItems) {
        $progID = ($ProgramsLibrary | Where-Object { $_.Name -eq $item }).ID
        Start-Process winget -ArgumentList "install --id $progID --exact --silent --accept-package-agreements --accept-source-agreements" -Wait -WindowStyle Hidden
    }
    
    [System.Windows.Forms.MessageBox]::Show("تم الانتهاء من تثبيت العناصر المحددة بنجاح!", "نجاح", 0, [System.Windows.Forms.MessageBoxIcon]::Information)
    $btnInstallSelected.Text = "تثبيت العناصر المحددة صامتاً (Silent Install)"
    $btnInstallSelected.Enabled = $true
})

$tabPrograms.Controls.Add($checkedListBoxPrograms)
$tabPrograms.Controls.Add($lblSelectedCount)
$tabPrograms.Controls.Add($btnInstallSelected)
$tabs.Controls.Add($tabPrograms)

# ==========================================
# التبويب الثاني: الثيمات والتحسينات
# ==========================================
$tabTweaks = New-Object System.Windows.Forms.TabPage
$tabTweaks.Text = "تخصيص المظهر والنظام"

$lblTheme = New-Object System.Windows.Forms.Label
$lblTheme.Text = "اختر الثيم التفاعلي للأداة:"
$lblTheme.AutoSize = $true
$lblTheme.Location = New-Object System.Drawing.Point(20, 20)
$lblTheme.BackColor = [System.Drawing.Color]::Transparent

$cmbTheme = New-Object System.Windows.Forms.ComboBox
$cmbTheme.Location = New-Object System.Drawing.Point(20, 48)
$cmbTheme.Size = New-Object System.Drawing.Size(615, 32)
$cmbTheme.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$cmbTheme.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
foreach ($t in $global:Themes) { [void]$cmbTheme.Items.Add($t.Name) }
$cmbTheme.SelectedIndex = 0
$cmbTheme.Add_SelectedIndexChanged({ Change-Theme $cmbTheme.SelectedIndex })

$btnDarkTheme = New-Object System.Windows.Forms.Button
$btnDarkTheme.Text = "تفعيل الوضع الليلي الشامل للويندوز (System Dark Mode)"
$btnDarkTheme.Location = New-Object System.Drawing.Point(20, 115)
$btnDarkTheme.Size = New-Object System.Drawing.Size(615, 52)
Set-ModernButton $btnDarkTheme
$btnDarkTheme.Add_Click({
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -ErrorAction SilentlyContinue
    [System.Windows.Forms.MessageBox]::Show("تم تفعيل الوضع الليلي للويندوز بنجاح.", "تم بنجاح")
})

$btnShowExtensions = New-Object System.Windows.Forms.Button
$btnShowExtensions.Text = "إظهار امتدادات الملفات المخفية في المستكشف (File Extensions)"
$btnShowExtensions.Location = New-Object System.Drawing.Point(20, 185)
$btnShowExtensions.Size = New-Object System.Drawing.Size(615, 52)
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
$btnWindowsUpdate.Text = "بحث وتثبيت تحديثات التعاريف الرسمية (Windows Update)"
$btnWindowsUpdate.Location = New-Object System.Drawing.Point(20, 35)
$btnWindowsUpdate.Size = New-Object System.Drawing.Size(615, 55)
Set-ModernButton $btnWindowsUpdate
$btnWindowsUpdate.Add_Click({ Start-Process "ms-settings:windowsupdate-action" })

$btnSDIO = New-Object System.Windows.Forms.Button
$btnSDIO.Text = "تثبيت عملاق التعاريف Snappy Driver Origin (SDIO)"
$btnSDIO.Location = New-Object System.Drawing.Point(20, 110)
$btnSDIO.Size = New-Object System.Drawing.Size(615, 55)
Set-ModernButton $btnSDIO $true

$btnSDIO.Add_Click({
    $btnSDIO.Text = "جاري تحميل وتثبيت الأداة... يرجى الانتظار"
    $btnSDIO.Enabled = $false
    Start-Process winget -ArgumentList "install --id GlennDelahoy.SnappyDriverInstallerOrigin --exact --silent --accept-package-agreements --accept-source-agreements" -Wait -WindowStyle Hidden
    [System.Windows.Forms.MessageBox]::Show("تم تثبيت Snappy Driver بنجاح!", "نجاح", 0, [System.Windows.Forms.MessageBoxIcon]::Information)
    $btnSDIO.Text = "تثبيت عملاق التعاريف Snappy Driver Origin (SDIO)"
    $btnSDIO.Enabled = $true
})

$tabDrivers.Controls.Add($btnWindowsUpdate)
$tabDrivers.Controls.Add($btnSDIO)
$tabs.Controls.Add($tabDrivers)

# ==========================================
# التبويب الرابع: نسخ الأنظمة (ISO)
# ==========================================
$tabISOs = New-Object System.Windows.Forms.TabPage
$tabISOs.Text = "نسخ الأنظمة (ISO)"

$btnWin11 = New-Object System.Windows.Forms.Button
$btnWin11.Text = "تحميل Windows 11 الرسمي (من مايكروسوفت)"
$btnWin11.Location = New-Object System.Drawing.Point(20, 25)
$btnWin11.Size = New-Object System.Drawing.Size(615, 48)
Set-ModernButton $btnWin11
$btnWin11.Add_Click({ Start-Process "https://www.microsoft.com/software-download/windows11" })

$btnUbuntu = New-Object System.Windows.Forms.Button
$btnUbuntu.Text = "تحميل توزيعة Ubuntu Linux"
$btnUbuntu.Location = New-Object System.Drawing.Point(20, 85)
$btnUbuntu.Size = New-Object System.Drawing.Size(615, 48)
Set-ModernButton $btnUbuntu
$btnUbuntu.Add_Click({ Start-Process "https://ubuntu.com/download/desktop" })

$btnKali = New-Object System.Windows.Forms.Button
$btnKali.Text = "تحميل توزيعة Kali Linux (أمن المعلومات والشبكات)"
$btnKali.Location = New-Object System.Drawing.Point(20, 145)
$btnKali.Size = New-Object System.Drawing.Size(615, 48)
Set-ModernButton $btnKali
$btnKali.Add_Click({ Start-Process "https://www.kali.org/get-kali/" })

$btnRufus = New-Object System.Windows.Forms.Button
$btnRufus.Text = "تحميل أداة حرق الأنظمة على الفلاشة (Rufus)"
$btnRufus.Location = New-Object System.Drawing.Point(20, 205)
$btnRufus.Size = New-Object System.Drawing.Size(615, 48)
Set-ModernButton $btnRufus $true
$btnRufus.Add_Click({ Start-Process "https://rufus.ie/" })

$tabISOs.Controls.Add($btnWin11)
$tabISOs.Controls.Add($btnUbuntu)
$tabISOs.Controls.Add($btnKali)
$tabISOs.Controls.Add($btnRufus)
$tabs.Controls.Add($tabISOs)

# ==========================================
# تشغيل الواجهة
# ==========================================
Change-Theme 0 # تطبيق الثيم الافتراضي وتوليد الخلفية
$form.Controls.Add($tabs)
[void]$form.ShowDialog()
