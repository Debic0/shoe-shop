# -*- mode: python ; coding: utf-8 -*-
# Сборка: python -m PyInstaller ShoeStore.spec --noconfirm --clean
# Результат: dist/ShoeStore/ShoeStore.exe (режим onedir — папка с EXE и папкой _internal)

a = Analysis(
    ['main.py'],
    pathex=[],
    binaries=[],
    datas=[('resources', 'resources')],   # изображения, логотип, иконка
    hiddenimports=[],
    hookspath=[],
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='ShoeStore',
    debug=False,
    strip=False,
    upx=False,
    # True — с консольным окном: так видны сообщения об ошибках (нужно для диагностики).
    # После всех проверок можно поставить False (приложение без консоли) и пересобрать.
    console=True,
    icon='resources/icon.ico',
)

coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=False,
    name='ShoeStore',
)
