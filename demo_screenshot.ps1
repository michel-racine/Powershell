# saves screenshot to a user specified file. run as admin.

$File = (read-host -prompt "[+] enter full path to save file:");
Add-Type -AssemblyName System.Windows.Forms;
Add-type -AssemblyName System.Drawing;
$Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen;

# issue 2: figure out how to do this automatically.
$Width =  1366;
$Height = 768;

$Left = $Screen.Left;
$Top = $Screen.Top;
$bitmap = New-Object System.Drawing.Bitmap $Width, $Height;
$graphic = [System.Drawing.Graphics]::FromImage($bitmap);
$graphic.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size);
$bitmap.Save($File);
