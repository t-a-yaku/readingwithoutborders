@echo off
chcp 65001 >nul
echo.
echo ═══════════════════════════════════════════════
echo  Вибір читачів — оновлення мапи
echo ═══════════════════════════════════════════════
echo.

cd /d "C:\Projects\PortKEY\mvp"

echo [1/3] Генеруємо index.html з бази даних...
docker-compose exec web python export_reader_choice_map.py
if errorlevel 1 (
    echo.
    echo ПОМИЛКА: не вдалось згенерувати HTML
    echo Перевір що Docker запущено: docker ps
    pause
    exit /b 1
)

echo.
echo [2/3] Копіюємо в репо...
copy /Y "backend\export_map_output\index.html" "C:\Projects\readingwithoutborders\index.html" >nul
echo     OK

echo.
echo [3/3] Публікуємо на GitHub...
cd /d "C:\Projects\readingwithoutborders"

for /f "tokens=1-3 delims=." %%a in ("%date%") do set TODAY=%%a.%%b.%%c

git add index.html
git commit -m "update %TODAY%"
git push origin main

echo.
echo ═══════════════════════════════════════════════
echo  Готово! Мапа оновлена.
echo  https://t-a-yaku.github.io/readingwithoutborders/
echo ═══════════════════════════════════════════════
echo.
pause
