# napcatqq-win

NapCat **v4.18.42** 的 Windows 部署方法与一键部署脚本（搭配 QQ 9.9.33，实测可用）。

> 本项目计划发布到：https://github.com/whgm06/napcatqq-win

## 背景

- 上游项目 [NapNeko/NapCatQQ](https://github.com/NapNeko/NapCatQQ) **已归档**，不再提供程序和代码。
- 社区归档 [XingYunStar/NapCatQQ](https://github.com/XingYunStar/NapCatQQ/) 保留了可用资源：**完整源码历史、v4.15.0 – v4.18.42 release 产物与 Docker 镜像**（`docker load` 导入）。上游已删除，此处保留可用的历史版本。
- 但其中 **Windows 一键脚本的下载链接已失效**，无法自动安装。

因此本项目提供 **v4.18.42 的 Windows 部署方法和安装脚本**：菜单式交互，自动判断 Windows 架构，多源回退下载 QQ 与 NapCat，自动解压部署。

## 版本组合

| 组件 | 版本 | 备注 |
| --- | --- | --- |
| QQ | 9.9.33（260813） | 实测可用，其他 QQ 版本未验证 |
| NapCat | v4.18.42（Shell 包） | 取自 XingYunStar 归档 |

> 仅实测 QQ 9.9.33 与 NapCat v4.18.42 组合可用；x86 / arm64 的 QQ 安装包链接已备好但未实测。

## 环境要求

- Windows 10 / 11，x64 / x86 / arm64 任一架构
- 网络可访问腾讯官方下载源或 GitHub（直连或代理）
- `launcher.bat` 需要管理员权限（脚本会自动提权）；本工具本身**无需**管理员权限

## 快速开始

双击运行 `install.bat`（中文菜单，编码为 GBK/ANSI，适合中文版 Windows）：

```
[1] 一键安装     下载 QQ 与 NapCat，解压到 NapCat.Shell 目录
[2] 创建快捷方式  设置 QQ 号快速登录，桌面创建 NapcatQQ 快捷方式
[Q] 退出
```

### 选项 1：一键安装

1. 自动检测 Windows 架构（x64 / x86 / arm64），确定对应的 QQ 安装包；
2. 下载 QQ 9.9.33 安装包：**腾讯官方直链 → gh-proxy 备用 → GitHub 直连**，依次自动回退；
3. 下载 `NapCat.Shell.zip`（v4.18.42）：**优先从本项目仓库源码下载**，失败依次回退：raw 直连 → XingYunStar release（gh-proxy）→ GitHub 直连；全部失败会提示手动下载地址；
4. 自动解压 `NapCat.Shell.zip` 到脚本所在目录下的 `NapCat.Shell` 文件夹（无需管理员权限；目录已存在时可选择跳过或覆盖）；
5. 提示安装 QQ：可输入 `Y` 让脚本直接启动 QQ 安装程序（安装完成后无需解压进 QQ 目录，NapCat 独立目录运行即可）。

### 选项 2：创建快捷方式

1. 输入要快速登录的 QQ 号（纯数字校验）；
2. 自动生成 `NapCat.Shell\quickLogin.bat`（写入 QQ 号，内含 Windows 10 / 免管理员等备选启动方式的注释说明）；
3. 在桌面创建快捷方式 **NapcatQQ**：指向 `quickLogin.bat`，图标使用 `NapCat.Shell\static\favicon.ico`；
4. 可选择立即启动测试。

### 登录方式

- **首次使用**：双击 `NapCat.Shell\launcher.bat` 扫码登录（需管理员权限，自动提权）；
- **已登录过**：双击桌面 **NapcatQQ** 快捷方式即可免扫码快速登录（依赖本机 QQ 已有登录记录）。

## 插件

### 插件市场（第三方索引）

原 NapCat 官方插件索引仓库已随上游归档一并删除，**v4.18.42 版的 NapCat 已改用第三方社区插件索引**（HolyFoxTeam 维护）：

- 索引地址：<https://raw.githubusercontent.com/HolyFoxTeam/napcat-plugin-community-index/refs/heads/main/plugins.v4.json>
- 索引内容：42 个插件（插件更新检测、缓存清理、插件调试服务等），含 `version` / `updateTime` / `statsUrl` / `plugins` 字段

启动 NapCat 后，在 **WebUI 的插件市场**里即可在线安装、更新、卸载插件，插件列表默认从上面的索引拉取。

> 提示：`raw.githubusercontent.com` 直连不稳定时，可在 URL 前加 `http://v4.gh-proxy.org/` 加速访问。

### 手动安装插件

不走插件市场也可以：手动下载插件的 zip 包，解压到 `NapCat.Shell\plugins\` 目录，重启 NapCat 即生效。

### 自定义插件索引

想换用自己的索引仓库时，编辑 `NapCat.Shell\napcat.mjs`，搜索 `plugins.v4.json`，找到：

```js
Dve = [ "https://raw.githubusercontent.com/HolyFoxTeam/napcat-plugin-community-index/refs/heads/main/plugins.v4.json" ]
```

把数组里的 URL 替换或追加为自己的索引地址（数组支持多个源，逗号分隔）。

> `napcat.mjs` 是约 3MB 的打包压缩文件，记事本打开会很卡，建议用 VS Code 等编辑器修改并保存。

## 下载地址

### QQ 9.9.33（脚本按架构自动选择，三链回退）

| 架构 | 官方直链 | gh-proxy 备用 | GitHub 直连备用 |
| --- | --- | --- | --- |
| x64 | [官方 x64](https://qqdl.gtimg.cn/qqfile/QQNT/9.9.33/release/497e2f1f/QQ_9.9.33_260813_x64_01.exe) | [gh-proxy x64](http://v4.gh-proxy.org/https://github.com/Rodert/qq-versions/releases/download/qq-packages-20260813-1d08f1d4/QQ_9.9.33_260813_x64_01.exe) | [直连 x64](https://github.com/Rodert/qq-versions/releases/download/qq-packages-20260813-1d08f1d4/QQ_9.9.33_260813_x64_01.exe) |
| x86 | [官方 x86](https://qqdl.gtimg.cn/qqfile/QQNT/9.9.33/release/497e2f1f/QQ_9.9.33_260813_x86_01.exe) | [gh-proxy x86](http://v4.gh-proxy.org/https://github.com/Rodert/qq-versions/releases/download/qq-packages-20260813-1d08f1d4/QQ_9.9.33_260813_x86_01.exe) | [直连 x86](https://github.com/Rodert/qq-versions/releases/download/qq-packages-20260813-1d08f1d4/QQ_9.9.33_260813_x86_01.exe) |
| arm64 | [官方 arm64](https://qqdl.gtimg.cn/qqfile/QQNT/9.9.33/release/497e2f1f/QQ_9.9.33_260813_arm64_01.exe) | [gh-proxy arm64](http://v4.gh-proxy.org/https://github.com/Rodert/qq-versions/releases/download/qq-packages-20260813-1d08f1d4/QQ_9.9.33_260813_arm64_01.exe) | [直连 arm64](https://github.com/Rodert/qq-versions/releases/download/qq-packages-20260813-1d08f1d4/QQ_9.9.33_260813_arm64_01.exe) |

> 实测备注：腾讯官方直链的 x64 / x86 包已 404（仅 arm64 存活），脚本会自动走备用链。gh-proxy 免费代理偶有不稳定时段，此时脚本自动回退 GitHub 直连。

### NapCat.Shell.zip（v4.18.42，四链回退，优先本项目仓库）

| 优先级 | 来源 | 链接 |
| --- | --- | --- |
| 1 | 本项目仓库源码（gh-proxy 加速） | `http://v4.gh-proxy.org/https://raw.githubusercontent.com/whgm06/napcatqq-win/main/NapCat.Shell.zip` |
| 2 | 本项目仓库源码（直连） | `https://raw.githubusercontent.com/whgm06/napcatqq-win/main/NapCat.Shell.zip` |
| 3 | XingYunStar 归档 release（gh-proxy） | `http://v4.gh-proxy.org/https://github.com/XingYunStar/NapCatQQ/releases/download/v4.18.42/NapCat.Shell.zip` |
| 4 | XingYunStar 归档 release（直连） | `https://github.com/XingYunStar/NapCatQQ/releases/download/v4.18.42/NapCat.Shell.zip` |

> 本仓库发布后选项 1/2 即为默认下载源；归档 release 路径以 [XingYunStar/NapCatQQ v4.18.42 release 页面](https://github.com/XingYunStar/NapCatQQ/releases/tag/v4.18.42) 为准。

## 手动部署

脚本不可用或所有下载链接均失效时，可手动完成部署：

1. 从上表按本机架构下载 QQ 9.9.33 安装包，双击安装；
2. 通过任一链接下载 `NapCat.Shell.zip`；
3. 在任意文件夹新建 `NapCat.Shell` 目录，将 zip 内**全部文件**解压进去（无需解压到 QQ 安装目录）；
4. 双击 `NapCat.Shell\launcher.bat` 扫码登录（launcher 自动从注册表定位 QQ 安装路径）；
5. （可选）编辑 `NapCat.Shell\quickLogin.bat`，把 QQ 号 `12345` 改成自己的 QQ 号，实现免扫码快速登录；也可自行创建桌面快捷方式。

## 常见问题

**Q：脚本被杀毒软件（火绒等）拦截？**
脚本行为完全透明：按架构下载官方 QQ 安装包与 NapCat 压缩包、解压、生成 quickLogin.bat、创建桌面快捷方式，无任何提权或隐藏执行。批处理下载器容易被启发式引擎误报，确认弹窗时选择放行/添加信任即可。

**Q：官方直链和备用链接都下载失败？**
QQ 安装包可到 [Rodert/qq-versions 的 qq-packages-20260813-1d08f1d4 标签页](https://github.com/Rodert/qq-versions/releases/tag/qq-packages-20260813-1d08f1d4) 手动获取，或从其他可信渠道下载 QQ 9.9.33（260813）；`NapCat.Shell.zip` 可到 [XingYunStar/NapCatQQ v4.18.42 release 页面](https://github.com/XingYunStar/NapCatQQ/releases/tag/v4.18.42) 手动下载，放到脚本同目录后重新运行即可（脚本会校验文件头自动识别）。

**Q：GitHub 直连下载太慢？**
可以手动把安装包下载好放进脚本所在目录，脚本检测到有效文件后自动跳过下载。也可自行替换脚本顶部的下载链接为其他加速源。

**Q：launcher.bat 提示 QQ installation was not found？**
QQ 尚未安装或未正确安装。`launcher.bat` 通过注册表定位 QQ 安装路径，请先安装 QQ 9.9.33，并以管理员权限运行。

**Q：quickLogin.bat 启动失败？**
按生成文件内的注释，将 `launcher.bat` 替换为 `launcher-win10.bat`（Windows 10）、`launcher-user.bat`（免管理员）或 `launcher-win10-user.bat`（Win10 免管理员）。

**Q：为什么锁定 QQ 9.9.33？**
只实测了 QQ 9.9.33 与 NapCat v4.18.42 的组合可用；其他 QQ 版本未验证，不保证兼容。

## 致谢

- [NapNeko/NapCatQQ](https://github.com/NapNeko/NapCatQQ) — NapCat 原项目
- [XingYunStar/NapCatQQ](https://github.com/XingYunStar/NapCatQQ) — 历史版本归档
- [Rodert/qq-versions](https://github.com/Rodert/qq-versions) — QQ 安装包归档
- [HolyFoxTeam/napcat-plugin-community-index](https://github.com/HolyFoxTeam/napcat-plugin-community-index) — 第三方插件索引

## 免责声明

本项目仅供学习与研究用途。NapCat 属于第三方 QQ 插件，使用可能违反腾讯相关服务协议并存在账号风险，请自行评估并谨慎使用。

> AI生成
