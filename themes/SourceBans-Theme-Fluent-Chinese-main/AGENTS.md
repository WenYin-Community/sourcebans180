# AGENTS.md

## 项目概述

SourceBans++ Fluent Design 主题中文翻译版。纯前端主题项目，无构建流程。

## 技术栈

- **模板引擎**: Smarty（`.tpl` 文件）
- **样式**: SCSS → CSS（手动编译，无自动构建）
- **JavaScript**: MooTools 框架（非现代框架）
- **图标**: Font Awesome 6.5.1
- **PHP**: 8.1+（仅 theme.conf.php 配置文件）

## 目录结构

```
core/           # 核心模板（header, footer, navbar, title, admin_tabs）
page_*.tpl      # 页面模板
box_*.tpl       # 搜索组件模板
scripts/        # JavaScript 文件
style/          # CSS/SCSS 样式
  scss/         # SCSS 源文件
    framework/  # 基础组件样式
images/         # 图片资源
mails/          # 邮件模板
```

## 关键约定

- 所有文本必须翻译为简体中文，保留英文技术术语（Steam ID, SourceMod 等）
- 模板变量使用 `{$variable}` 语法
- 响应式类名：`responsive_show:desktop`、`responsive_hide:mobile`
- 深色模式：通过 `__dark.scss` 和 JavaScript 切换

## 开发注意事项

- 无 package.json、无 npm/yarn、无构建脚本
- SCSS 需手动编译为 CSS（使用 sass 命令）
- 无测试框架、无 lint 工具
- 修改后直接部署到 SourceBans++ 的 `themes` 目录即可生效

## 文件命名规则

- 页面模板：`page_{功能}.tpl`
- 搜索组件：`box_{功能}_search.tpl`
- 核心模板：`core/{功能}.tpl`

## 常见修改场景

- **翻译文本**: 直接编辑 `.tpl` 文件中的中文文本
- **样式调整**: 修改 `style/scss/` 下的 SCSS 文件，然后编译
- **添加功能**: 在对应 `page_*.tpl` 中添加模板代码
- **修改配置**: 编辑 `theme.conf.php`
