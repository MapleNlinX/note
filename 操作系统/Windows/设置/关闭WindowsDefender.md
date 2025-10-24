# 停用WindowsDefender
- 使用工具 Defender Control v2.1
![[Pasted image 20240918101152.png]]

# 注册表关闭WindowsDefender
- 组策略 gpedit.msc
- 将"关闭 Microsoft Defender 防病毒"设为已开启
- 刷新组策略 `gpupdate /force`
![[Pasted image 20240918110946.png]]
