# 编程入门

## Bootstrap 框架

### 边框工具类

Bootstrap 的边框工具类遵循以下规则：

```
border-{方向}-{宽度} border-{颜色}
```

- **`border-{方向}-{宽度}`**：控制边框的方向（左/右/上/下等）和粗细（0~5 可选）
- **`border-{颜色}`**：控制边框的颜色（基于 Bootstrap 主题色体系）

### 方向可选值

| 方向缩写 | 含义 | 示例（搭配宽度 `2`） |
| :--: | :-- | :-- |
| `l` | left（左） | `border-l-2` |
| `r` | right（右） | `border-r-2` |
| `t` | top（上） | `border-t-2` |
| `b` | bottom（下） | `border-b-2` |
| `x` | left + right（左右） | `border-x-2` |
| `y` | top + bottom（上下） | `border-y-2` |

### 颜色可选值

Bootstrap 定义了 10 种核心主题色：

| 类名 | 颜色含义 | 适用场景 |
| :-- | :-- | :-- |
| `border-primary` | 品牌主色（深蓝色） | 强调核心模块 |
| `border-secondary` | 次级辅助色（浅灰色） | 次要信息区分 |
| `border-success` | 成功/完成（绿色） | 操作成功提示 |
| `border-danger` | 危险/错误（红色） | 警告、错误提示 |
| `border-warning` | 警告/提醒（橙色） | 需注意的状态 |
| `border-info` | 信息/提示（浅蓝色） | 说明性内容 |
| `border-light` | 浅色调（接近背景） | 视觉弱化的分隔线 |
| `border-dark` | 深色调（深灰色） | 强调厚重感的模块 |
| `border-white` | 白色 | 深色背景下的边框 |
| `border-transparent` | 透明 | 隐藏边框但保留布局 |

### 宽度可选值

6 种边框宽度（数值越大，边框越粗）：`0`（隐藏）、`1`、`2`、`3`、`4`、`5`。

### 完整组合示例

| 组合 | 效果 |
| :-- | :-- |
| `border-t-3 border-success` | 顶部 3px 宽的绿色边框（成功状态的上边框） |
| `border-x-1 border-info` | 左右 1px 宽的浅蓝色边框（信息卡片的左右装饰） |
| `border-b-5 border-danger` | 底部 5px 宽的红色边框（错误提示的下边框） |
