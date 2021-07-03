mkdir c:\buildArtifacts
echo Azure-Image-Builder-Was-Here  > c:\buildArtifacts\azureImageBuilder.txt
curl https://github.com/yamauchikazu/public/raw/master/aibuilder/ja-jp.cab -o c:\buildArtifacts\Microsoft-Windows-Server-Language-Pack_x64_ja-jp.cab
