python updateconfig.py
set name=getitle
gox.exe -osarch="linux/amd64 linux/arm64 linux/386 windows/amd64 linux/mips64 windows/386 darwin/amd64" -ldflags="-s -w" -gcflags="-trimpath=$GOPATH" -asmflags="-trimpath=$GOPATH" -output=".\bin\%name%_{{.OS}}_{{.Arch}}" .

@REM  go strip 去除编译信息
@REM go-strip -f ./bin/%name%_windows_386.exe -a -output ./bin/%name%_windows_386.exe > nul
@REM go-strip -f ./bin/%name%_windows_amd64.exe -a -output ./bin/%name%_windows_amd64.exe > nul
@REM go-strip -f ./bin/%name%_linux_386 -a -output ./bin/%name%_linux_386 > nul
@REM go-strip -f ./bin/%name%_linux_arm64 -a -output ./bin/%name%_linux_arm64 > nul
@REM go-strip -f ./bin/%name%_linux_amd64 -a -output ./bin/%name%_linux_amd64 > nul
@REM go-strip -f ./bin/%name%_linux_mips64 -a -output ./bin/%name%_linux_mips64 > nul
@REM go-strip -f ./bin/%name%_darwin_amd64 -a -output ./bin/%name%_darwin_amd64 > nul

@REM upx 加壳
upxs  -k -o ./bin/%name%_windows_386_upx.exe ./bin/%name%_windows_386.exe
upxs  -k -o ./bin/%name%_windows_amd64_upx.exe ./bin/%name%_windows_amd64.exe
upxs  -k -o ./bin/%name%_linux_386_upx ./bin/%name%_linux_386
upxs  -k -o ./bin/%name%_linux_amd64_upx ./bin/%name%_linux_amd64
upxs  -k -o ./bin/%name%_linux_arm64_upx ./bin/%name%_linux_arm64

@REM 伪造证书
limelighter -I ./bin/%name%_windows_amd64.exe -O ./bin/%name%_windows_amd64s.exe -Domain www.sangfor.com
limelighter -I ./bin/%name%_windows_amd64_upx.exe -O ./bin/%name%_windows_amd64_upxs.exe -Domain www.sangfor.com
limelighter -I ./bin/%name%_windows_386_upx.exe -O ./bin/%name%_windows_386_upxs.exe -Domain www.sangfor.com
limelighter -I ./bin/%name%_windows_386.exe -O ./bin/%name%_windows_386s.exe -Domain www.sangfor.com

rm *.sangfor.*
rm ./bin/%name%_windows_amd64.exe
rm ./bin/%name%_windows_amd64_upx.exe
rm ./bin/%name%_windows_386.exe
rm ./bin/%name%_windows_386_upx.exe

@REM 打包
tar -zcvf release/%name%v%1.tar.gz bin/* README.md gtfilter.py UPDATELOG.md