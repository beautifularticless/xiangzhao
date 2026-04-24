@echo off
chcp 65001 >nul
title 【终极强制】本地完全覆盖远程GitHub
color 0C

echo ==============================================
echo           终极强制推送
echo      警告：远程所有内容将被本地完全替换
echo ==============================================
echo.

:: ===================== 配置区 =====================
set "GIT_REPO_URL=https://github.com/beautifularticless/xiangzhao.git"
set "COMMIT_MSG=强制覆盖：本地替换远程"
:: ==================================================

git --version >nul 2>&1
if errorlevel 1 (
    echo 错误：未安装Git！
    pause
    exit /b 1
)

if not exist .git (
    git init
    git remote add origin %GIT_REPO_URL%
)

git remote set-url origin %GIT_REPO_URL%

echo 正在添加所有文件...
git add .

echo 正在提交...
git commit -m "%COMMIT_MSG%" 2>&1 >nul

git branch -M main

:: ==============================================
:: 核心：真正的强制推送（无视一切，直接覆盖）
:: ==============================================
echo 正在强制覆盖远程仓库...
git push --force origin main

echo.
echo ==============================================
echo            ✅ 强制覆盖完成！
echo          远程已被本地完全替换
echo ==============================================
echo.

pause