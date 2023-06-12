# Recursively XOR encrypt/decrypt current directory

function encryptDir() {
	# Read key file bytes into f2
	$f2 = $pwd.toString() + "\key.secret"
	$f2b = [System.IO.File]::ReadAllBytes($f2)

	# Recursively examine directory looking for .txt files.
	foreach ($file in get-childitem -recurse) {
		if ($file.name -like "*.txt") {
			$f1b = [System.IO.File]::ReadAllBytes($file.fullname)
			$len = $f1b.Count

			# Exclude files larger than key, otherwise data would be exposed or lost.
			if($f1b.Count -gt $f2b.Count) {
				write-host -nonewline "File larger than key "
				write-host -backgroundcolor yellow -foregroundcolor red $file.fullname
			} else {
				# This is where magic happens
				# File bytes are XOR'd agains key bytes to produce output ciphertext.
				$xorArray = New-Object Byte[] $len
				for($i=0; $i -lt $len; $i++) {
					$xorArray[$i] = $f1b[$i] -bxor $f2b[$i]
				}

				# Write ciphertext to file
				$f3 = $file.fullname + ".encrypted"
				[System.IO.File]::WriteAllBytes($f3, $xorArray)

				# Delete original plaintext file
				remove-item $file.fullname

				write-host -nonewline "Encrypted:           "
				write-host -backgroundcolor red -foregroundcolor black $file.fullname
			}
		}
	}
}

function decryptDir() {
	$f2 = $pwd.toString() + "\key.secret"
	$f2b = [System.IO.File]::ReadAllBytes($f2)
	foreach ($file in get-childitem -recurse) {
		if ($file.name -like "*encrypted") {
			$s = $file.fullname -split ".encrypted"
			$f3 = $s[0]
			$f1b = [System.IO.File]::ReadAllBytes($file.fullname)
			$len = $f1b.Count
			$xorArray = New-Object Byte[] $len
			for($i=0; $i -lt $len; $i++) {
				$xorArray[$i] = $f1b[$i] -bxor $f2b[$i]
			}
			[System.IO.File]::WriteAllBytes($f3, $xorArray)
			remove-item $file.fullname

			write-host -nonewline "Decrypted: "
			write-host -backgroundcolor green -foregroundcolor black $f3
		}
	}
}	
	
