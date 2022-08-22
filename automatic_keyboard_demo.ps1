# pops open notepad and says hello
# for special key formats see: 
# https://msdn.microsoft.com/en-us/library/system.windows.forms.sendkeys.send(v=vs.110).aspx

add-type -AssemblyName System.Windows.Forms;

notepad; start-sleep 3;

$s = "hello world";

for($i=0;$i -lt $s.length;$i++){
  [System.Windows.Forms.SendKeys]::SendWait($s[$i]);
  start-sleep -milliseconds 250;
}
