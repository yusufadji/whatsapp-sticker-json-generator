@echo off
setlocal enabledelayedexpansion

:: Setup your assets folder path and contents.json file path
set ASSETS_PATH=C:\path\to\assets
set CONTENTS_JSON_PATH=C:\path\to\contents.json
set ANDROID_PLAY_STORE_LINK=
set IOS_APP_STORE_LINK=
set PUBLISHER_NAME=Frelein
set PUBLISHER_EMAIL=admin@frelein.my.id
set PUBLISHER_WEBSITE=
set PRIVACY_POLICY_WEBSITE=
set LICENSE_AGREEMENT_WEBSITE=
set ANIMATED_STICKER_PACK=true
set AVOID_CACHE=false

:: A list of emojis to be randomized and put into an array
set "emojis_list[0]=😊"
set "emojis_list[1]=😢"
set "emojis_list[2]=😡"
set "emojis_list[3]=😞"

:: Function to get the image_data_version version from the previous contents.json file
:get_image_data_version
if exist "%CONTENTS_JSON_PATH%" (
    for /f "tokens=*" %%a in ('jq ".sticker_packs[]?.image_data_version" "%CONTENTS_JSON_PATH%" ^| sort /r ^| head -n 1') do set "last_version=%%a"
    if "!last_version!"=="" (
        echo 1
    ) else (
        echo !last_version!+1
    )
) else (
    echo 1
)
exit /b

:: Function to change identifier to capitalize and remove numbers
:format_name
set "name=%~1"
set "name=!name:_= !"
set "name=!name:~0,1!!name:~1!"
echo !name!
exit /b

:: Function to select emoji randomly
:get_random_emoji
set /a random=!random! %% 4
echo !emojis_list[!random!]!
exit /b

:: Function to create contents.json
:generate_json
set /a version=!get_image_data_version!

echo { > "%CONTENTS_JSON_PATH%"
echo  "android_play_store_link": "%ANDROID_PLAY_STORE_LINK%"," >> "%CONTENTS_JSON_PATH%"
echo  "ios_app_store_link": "%IOS_APP_STORE_LINK%"," >> "%CONTENTS_JSON_PATH%"
echo  "sticker_packs": [ >> "%CONTENTS_JSON_PATH%"

set "first_pack=true"
for /d %%f in ("%ASSETS_PATH%\*") do (
    set "pack_name=%%~nf"

    :: Formats sticker name from identifier
    call :format_name "!pack_name!" > temp.txt
    set /p formatted_name=<temp.txt
    del temp.txt

    :: Tray images check
    set "png_files="
    for %%p in ("%%f\*.png") do set "png_files=%%p"
    if "!png_files!"=="" (
        echo Warning: There's no PNG file on '!pack_name!'. This folder will not be included in contents.json.
        continue
    )

    :: Get PNG file name
    for %%p in ("%%f\*.png") do set "tray_image_file=%%~np"

    :: Get sticker files in folder (.webp only)
    set "stickers="
    for %%s in ("%%f\*.webp") do set "stickers=!stickers! %%s"
    set "sticker_count=0"
    for %%s in (!stickers!) do set /a sticker_count+=1

    :: Checking the number of .webp files
    if !sticker_count! lss 3 (
        echo Warning: '!pack_name!' folder has !sticker_count! .webp files. Must be between 3 and 30.
        continue
    )
    if !sticker_count! gtr 30 (
        echo Warning: '!pack_name!' folder has !sticker_count! .webp files. Must be between 3 and 30.
        continue
    )

    :: Checking .webp file size
    set "oversized_files="
    for %%s in (!stickers!) do (
        set /a file_size=%%~zs
        if !file_size! gtr 500000 (
            set "oversized_files=!oversized_files! %%~ns on folder '!pack_name!'"
        )
    )

    :: If any file is larger than 500 KB, display a warning.
    if "!oversized_files!" neq "" (
        for %%o in (!oversized_files!) do echo Warning: File %%o has a size of more than 500 KB.
    )

    :: Generate sticker pack JSON
    if "!first_pack!"=="true" (
        set "first_pack=false"
    ) else (
        echo , >> "%CONTENTS_JSON_PATH%"
    )

    echo  { >> "%CONTENTS_JSON_PATH%"
    echo    "name": "!formatted_name!", >> "%CONTENTS_JSON_PATH%"
    echo    "identifier": "!pack_name!", >> "%CONTENTS_JSON_PATH%"
    echo    "image_data_version": !version!, >> "%CONTENTS_JSON_PATH%"
    echo    "publisher": { >> "%CONTENTS_JSON_PATH%"
    echo      "name": "!PUBLISHER_NAME!", >> "%CONTENTS_JSON_PATH%"
    echo      "email": "!PUBLISHER_EMAIL!", >> "%CONTENTS_JSON_PATH%"
    echo      "website": "!PUBLISHER_WEBSITE!" >> "%CONTENTS_JSON_PATH%"
    echo    }, >> "%CONTENTS_JSON_PATH%"
    echo    "tray_image": { >> "%CONTENTS_JSON_PATH%"
    echo      "file": "!tray_image_file!.png" >> "%CONTENTS_JSON_PATH%"
    echo    }, >> "%CONTENTS_JSON_PATH%"
    echo    "stickers": [ >> "%CONTENTS_JSON_PATH%"

    set "first_sticker=true"
    for %%s in (!stickers!) do (
        set "sticker_name=%%~ns"
        set "sticker_name=!sticker_name:.webp=!"

        if "!first_sticker!"=="true" (
            set "first_sticker=false"
        ) else (
            echo , >> "%CONTENTS_JSON_PATH%"
        )

        echo      { >> "%CONTENTS_JSON_PATH%"
        echo        "image": "!sticker_name!.webp", >> "%CONTENTS_JSON_PATH%"
        echo        "emoji": !get_random_emoji! >> "%CONTENTS_JSON_PATH%"
        echo      } >> "%CONTENTS_JSON_PATH%"
    )

    echo    ] >> "%CONTENTS_JSON_PATH%"
    echo  } >> "%CONTENTS_JSON_PATH%"
)

echo ] >> "%CONTENTS_JSON_PATH%"
echo } >> "%CONTENTS_JSON_PATH%"
