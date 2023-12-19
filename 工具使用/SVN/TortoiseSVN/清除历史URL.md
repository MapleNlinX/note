# 删除全部URL记录
使用TortoiseSVN自带功能
- 右键->TortoiseSVN->Settings->SavedData->URL history->clear
![](file/Pasted%20image%2020231017164723.png)
# 删除单条/修改URL
修改注册表
- win+r -> regedit
- 计算机\\HKEY_CURRENT_USER\\SOFTWARE\\TortoiseSVN\\History\\repoURLS 下的某个文件夹
- 全部由url+数字的名称的文件夹就是，这个文件夹是这个仓库的UUID，其中url0就是显示的第一个，通过修改这个可改变默认显示
![](file/Pasted%20image%2020231017164939.png)

## 获取仓库uuid
```cmd
-- 本地仓库目录下
svn info --show-item=repos-uuid
-- 远程命令
svn info https://10.10.10.117/svn/cokutau-dev/game/ProjectC3/client
-- 服务器端目录下
svnlook uuid /path/to/your/local/repository
```
## 在bat脚本操作

```bat
@echo off
reg add "HKCU\SOFTWARE\TortoiseSVN\History\repoURLS\137bc385-c799-7b4b-8eac-1e51b6001df0" /v url0 /t REG_SZ /d "new_url" /f
```

## 在Python脚本操作

```python
import winreg

# 定义注册表项的路径和名称
registry_path = r"SOFTWARE\TortoiseSVN\History\repoURLS\137bc385-c799-7b4b-8eac-1e51b6001df0"
value_name = "url0"

# 设置要写入的新URL值
new_url = "新的URL"  # 将"新的URL"替换为您要设置的新URL

# 打开注册表项
key = winreg.HKEY_CURRENT_USER  # 当前用户的注册表
try:
    with winreg.OpenKey(key, registry_path, 0, winreg.KEY_WRITE) as registry_key:
        # 设置注册表项的新值
        winreg.SetValueEx(registry_key, value_name, 0, winreg.REG_SZ, new_url)
        print(f"已成功将 {value_name} 的值设置为 {new_url}")
except Exception as e:
    print(f"修改注册表时出现错误：{e}")
```
