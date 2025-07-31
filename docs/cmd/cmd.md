## 导出文件夹的文件名到列表

**方法一：Windows PowerShell 实现（推荐，灵活且可直接生成表格文件）**

1. **打开 PowerShell**：
   按住 `Win + R`，输入 `powershell` 回车，或在文件夹空白处按住 `Shift + 右键`，选 “在此处打开 PowerShell 窗口”。

2. **执行导出命令：**
   假设要导出当前文件夹（也可替换为具体路径，如`D:\your_folder`）的文件到`文件名列表.xlsx`，输入：
```powershell
   Get-ChildItem | Select-Object Name | Export-Csv -Path "文件名列表.csv" -Encoding UTF8 -NoTypeInformation

   # 若需要带修改日期，用：
   # Get-ChildItem | Select-Object Name, LastWriteTime | Export-Csv -Path "文件名_带日期.csv" -Encoding UTF8 -NoTypeInformation
```
   执行后，文件夹会生成`csv`文件，Excel 可直接打开（本质是表格格式，也能另存为`xlsx`）。

**方法二：Windows Excel 自带功能（适合简单需求）**

1. **生成文件名单纯文本**：
   打开 cmd（`Win + R`输入`cmd`回车），进入目标文件夹（用`cd 路径`，如`cd D:\your_folder`)，输入：
```cmd
   dir /b > files.txt
```
文件夹生成  `files.txt`，存着文件名。

2. **导入 Excel**：
   打开 Excel → 数据 → 自文本 / CSV → 选 `files.txt` → 按向导完成导入，文本转成表格列。