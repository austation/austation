if(!(Test-Path -Path "C:/byond")){
    bash tools/ci/download_byond.sh
    [System.IO.Compression.ZipFile]::ExtractToDirectory("C:/byond.zip", "C:/")
    Remove-Item C:/byond.zip
}

<<<<<<< HEAD
&"C:/byond/bin/dm.exe" -max_errors 0 austation.dme
=======
bash tools/ci/install_node.sh
bash tools/build/build

>>>>>>> 261160d855... Juke Build Reforged (#4861)
exit $LASTEXITCODE
