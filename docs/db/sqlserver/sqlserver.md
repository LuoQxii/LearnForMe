### 使用 SQL Server Profiler开启跟踪（图形界面）

1. **打开 SQL Server Profiler**
   - 在 SQL Server Management Studio (SSMS) 中，依次点击 **工具 > SQL Server Profiler**，或者直接从开始菜单搜索并打开。
   
2. **连接到数据库引擎**
   - 输入服务器名称和身份验证信息，点击 **连接**。
   
3. **创建跟踪会话**
   - 在**新建跟踪**窗口中：
     - **常规** 选项卡：命名跟踪会话，选择要跟踪的服务器。
     - **事件选择**选项卡：
       - 勾选需要捕获的事件类别（如 `TSQL`、`Performance`）和具体事件（如 `SQL:BatchStarting`、`RPC:Completed`）。
       - 使用 **列筛选器** 限制跟踪范围（如特定用户、数据库或时间段）。
     - **运行**：点击 **确定** 开始跟踪。
   
4. **停止跟踪**
   
   - 完成后，点击工具栏中的 **停止** 按钮。
   
