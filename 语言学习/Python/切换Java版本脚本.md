# 原理
1. 修改`JAVA_HOME`值
2. 修改系统变量中`Path`值，将对应版本的`javapath`地址移到最上面
3. 通知系统系统变量刷新
# 为什么
Q：为什么用winreg，而不是用setx
A：因为setx有字符串限制上限，只能是1024个字符串，而且winreg没这个问题，当然也可以通过先赋值到文本，再从文本获取值方式可以忽视长度限制，但是麻烦，而且对于字符串处理，在python中也更方便

# 代码
```python
import ctypes
import subprocess
import sys
import winreg

java_home_8 = "%JAVA_HOME8%"
java_path_8 = 'C:\Program Files (x86)\Common Files\Oracle\Java\java8path;'

java_home_11 = "%JAVA_HOME11%"
java_path_11 = 'C:\Program Files\Common Files\Oracle\Java\javapath;'

def is_admin():
    """检查是否以管理员身份运行。"""
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def get_env_variable(var_name, user=True):
    """获取环境变量的值。"""
    key = winreg.HKEY_CURRENT_USER if user else winreg.HKEY_LOCAL_MACHINE
    sub_key = r"Environment" if user else r"SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    try:
        reg_key = winreg.OpenKey(key, sub_key, 0, winreg.KEY_READ)
        value, _ = winreg.QueryValueEx(reg_key, var_name)
        winreg.CloseKey(reg_key)
        return value
    except FileNotFoundError:
        return None

def set_env_variable(var_name, value, user=True):
    """设置环境变量的值。"""
    key = winreg.HKEY_CURRENT_USER if user else winreg.HKEY_LOCAL_MACHINE
    sub_key = r"Environment" if user else r"SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    try:
        pass
        reg_key = winreg.OpenKey(key, sub_key, 0, winreg.KEY_SET_VALUE)
        winreg.SetValueEx(reg_key, var_name, 0, winreg.REG_EXPAND_SZ, value)
        winreg.CloseKey(reg_key)
        print(f"新的 {var_name} 值已设置:\n {value}\n")
        
        
        ## 通知系统环境变量已更改
        user32 = ctypes.WinDLL('user32', use_last_error=True)
        result = user32.SendMessageTimeoutW(
            0xFFFF,  # HWND_BROADCAST, 广播消息到所有顶层窗口
            0x1A,    # WM_SETTINGCHANGE, 表示系统设置已更改
            0,       # WPARAM, 这里未使用，设为 0
            "Environment",  # LPARAM, 指向 "Environment" 字符串，表示环境变量已更改
            0x0002,  # SMTO_ABORTIFHUNG, 如果窗口挂起则中止发送消息
            5000     # 超时时间，单位为毫秒，这里为 5 秒
        )
        if result == 0:
            # 获取错误代码
            error_code = ctypes.get_last_error()
            print(f"SendMessageTimeoutW 调用失败，错误代码: {error_code}\n")
        else:
            print("环境变量更新消息已成功发送。\n")

        # # 通知系统环境变量已更改（仅在用户变量时使用）
        # if user:
        #     subprocess.run(["setx", var_name, value], shell=True)
        # else:
        #     subprocess.run(["setx", var_name, value, "/M"], shell=True)
    except Exception as e:
        print(f"设置环境变量  {var_name}  失败: {e}\n")
        

def switch_java_home(new_java_home, user=True):
    """切换JAVA_HOME到新值。"""
    current_java_home = get_env_variable("JAVA_HOME", user)
    print(f"当前 JAVA_HOME 值:\n {current_java_home}\n")

    # 设置新的 JAVA_HOME
    set_env_variable("JAVA_HOME", new_java_home, user)
    print(f"=========================================\n")

def switch_path(java_path, user=True):
    """切换PATH以包含新的Java路径。"""
    # 获取当前的PATH
    current_path = get_env_variable("Path", user)
    print(f"当前 PATH 值:\n {current_path}\n")

    # 移除任何现有的Java路径
    if java_path in current_path:
        current_path = current_path.replace(java_path, "")
    
    # 在开头添加新的Java路径
    new_path = f"{java_path}{current_path}"
    set_env_variable("Path", new_path, user)
    print(f"=========================================\n")
    

def switch_java_8():
    switch_java_home(java_home_8, True)
    switch_path(java_path_8, False)
    print(f"\n——————      已切换至 Java 8     ——————\n")
    
    
    
def switch_java_11():
    switch_java_home(java_home_11, True)
    switch_path(java_path_11, False)
    print(f"\n——————      已切换至 Java 11     ——————\n")
    
    
def main():
    current_java_home = get_env_variable("JAVA_HOME", True)
    if current_java_home == java_home_8:
        switch_java_11()
    elif current_java_home == java_home_11:
        switch_java_8()
    else:
        print("当前JAVA_HOME环境变量的值不是%JAVA_HOME8%的规则，无法切换。")


if __name__ == "__main__":
    if is_admin():
        main()
    else:
        print("需要管理员权限来修改系统环境变量。")
        # ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1)

```