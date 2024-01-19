## 环境
- pyinstaller：v5.13.0（打包库）
- python：v3.11.3

## 使用

```python
pyinstaller --onefile --noconsole your_script.py
```
## 参数
- **onefile:** 将所有文件打包成一个单独的可执行文件，而不是一个文件夹。这样生成的可执行文件更容易分发。
```python
pyinstaller --onefile your_script.py
```

- **noconsole:** 创建一个无命令行窗口的 GUI 可执行文件，适用于图形界面应用程序。
```python
pyinstaller --noconsole your_script.py
```

- **name:** 指定生成的可执行文件的名称。
```python
pyinstaller --name my_app your_script.py
```

- **icon:** 指定生成的可执行文件的图标文件。
```python
pyinstaller --icon=app_icon.ico your_script.py
```

- **hidden-import:** 明确指定需要导入的模块，有些模块可能由 PyInstaller 无法自动检测到。
```python
pyinstaller --hidden-import=my_module your_script.py
```

- **exclude-module:** 排除特定模块，防止它们被包含在可执行文件中。
```python
pyinstaller --exclude-module=unwanted_module your_script.py
```