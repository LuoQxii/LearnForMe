## 开机自启文件夹

Windows 系统的启动文件夹通常有两个，分别是当前用户启动文件夹和所有用户启动文件夹，不同系统版本的具体路径基本一致，以下是详细介绍：

- **当前用户启动文件夹**：存放于此的程序快捷方式，仅在当前用户登录时自动启动。
  - 路径为 `C:\Users <用户名>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`。
  - 可以按 `Win+R` 打开 “运行” 对话框，输入 “`shell:startup`” 并回车，快速打开该文件夹。

- **所有用户启动文件夹**：放置在此文件夹中的程序快捷方式，会在任何用户登录系统时都自动启动。
  - 路径是 `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup`。
  - 同样可以通过 `Win+R` 打开 “运行” 对话框，输入 “`shell:common startup`” 来快速访问。


## 结束windows资源管理器处理方法

当在 Windows 任务管理器中把 Windows 资源管理器结束后，导致桌面和任务栏消失，可以通过重新启动资源管理器进程来恢复，具体操作方法如下：

1. 按下 “Ctrl + Shift + Esc” 组合键，打开 “任务管理器” 窗口。
2. 在 “任务管理器” 中，点击 “文件” 菜单，选择 “运行新任务”。
3. 在弹出的 “新建任务” 窗口中，输入 “`explorer.exe`”，然后点击 “确定” 按钮。

执行上述操作后，Windows 资源管理器将重新启动，桌面和任务栏通常会恢复显示。

