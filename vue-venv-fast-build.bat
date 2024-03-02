cd /d %~dp0
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit

setlocal enabledelayedexpansion 

@echo off
@chcp 65001
@title vue环境快速搭建

@echo.

@echo [名称]	vue环境快速搭建

@echo [作者]	gmcy

@echo [时间]	2024/03/02

@echo.

:main
	call :stop
	call :checkAll
	echo [提示]	已经完成 vue 环境配置
	echo [提示]	30秒后自动关闭窗口.
	timeout /nobreak /t 30
	exit /b
	goto :eof

call :main
goto :eof

:stop
	echo [确认]	回车执行操作
	echo [取消]	直接关闭窗口
	echo.
	pause
	echo.
	goto :eof

:checkAll
	call node -v > nul
	if errorlevel 1 (
		echo.
		echo [提示]	检查到未安装 nodejs
		call :installNodeJs
	) else (
		echo.
		echo [提示]	检查到已安装 nodejs
	)
	call :showForm "node -v"
	call :showForm "npm -v"
	call :confPowerShell
	call pnpm -v > nul
	if errorlevel 1 (
		echo.
		echo [提示]	检查到未安装 pnpm
		call :installPnpm
	) else (
		echo.
		echo [提示]	检查到已安装 pnpm
	)
	call :showForm "pnpm -v"
	call yarn -v > nul
	if errorlevel 1 (
		echo.
		echo [提示]	检查到未安装 yarn
		call :installYarn
	) else (
		echo.
		echo [提示]	检查到已安装 yarn
	)
	call :showForm "yarn -v"
	goto :eof

:installNodeJs
	echo [注意]	node 将会进行默认安装
	echo		版本为 v18.19.0-x64
	echo		想自定义安装 node
	echo		可自行先安装 node
	echo		再双击重新运行
	echo.
	call :stop
	echo [操作]	安装 node-v18.19.0-x64.msi 中...
	start /wait msiexec.exe /i node-v18.19.0-x64.msi /qn
	echo [结果]	安装 node-v18.19.0-x64.msi 完成.
	echo.
	echo [操作]	配置临时系统环境变量中...
	set nodePath=C:\Program Files\nodejs\;C:\Users\admin\AppData\Roaming\npm
	set PATH=%PATH%;%nodePath%
	echo [结果]	配置临时系统环境变量完成.
	echo.
	call :confForm "正在设置 npm 华为镜像 中..." "call npm config set registry https://mirrors.huaweicloud.com/repository/npm/" "设置 npm 华为镜像 完成."
	goto :eof

:installPnpm
	call :confForm "安装 pnpm 中..." "call npm install -g pnpm" "安装 pnpm 完成."
	call :confForm "设置 pnpm 华为镜像 中..." "call pnpm config set registry https://mirrors.huaweicloud.com/repository/npm/" "设置 pnpm 华为镜像 完成."
	goto :eof

:installYarn
	call :confForm "安装 yarn 中..." "call npm install -g yarn" "安装 yarn 完成."
	call :confForm "设置 yarn 华为镜像 中..." "call yarn config set registry https://mirrors.huaweicloud.com/repository/npm/" "设置 yarn 华为镜像 完成."
	goto :eof

:showForm
	set mes=""
	for /f "delims=" %%a in ('%~1') do (set "mes=%%a")
	echo [操作]	%~1
	echo [输出]	!mes!
	echo.
	goto :eof

:confForm
	echo [操作]	%~1
	for /f "delims=" %%a in ('%~2') do (set "mes=%%a")
	if NOT "%mes%"=="" (
		echo [输出]	!mes!
	)
	echo [结果]	%~3
	echo.
	goto :eof

:confPowerShell
	echo [操作]	准备执行策略中(使得powershell可以调用pnpm等)...
	start /wait powershell set-ExecutionPolicy RemoteSigned
	echo [操作]	设置执行策略完成(可能会失败).
	echo.
	goto :eof