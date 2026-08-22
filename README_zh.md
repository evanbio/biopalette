<div align="center">

<img src="man/figures/logo.png" width="180" alt="biopalette logo" />

# biopalette

### *面向生物医学可视化的图像驱动配色方案*

[![R-CMD-check](https://github.com/evanbio/biopalette/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/evanbio/biopalette/actions/workflows/R-CMD-check.yaml)
[![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

[📚 文档](https://evanbio.github.io/biopalette/) •
[💬 问题反馈](https://github.com/evanbio/biopalette/issues) •
[🎨 Tessera](https://folio.evanzhou.org/tessera) •
[🧪 Palette Lab](https://folio.evanzhou.org/apps/palette-lab)

---

**语言版本:** [English](https://github.com/evanbio/biopalette/blob/main/README.md) | 简体中文

</div>

---

## 项目简介

**biopalette** 是一个 R 包，提供图像启发的配色方案，专为生物医学可视化设计。

每一套配色都源自一张真实的图像——电影剧照、科研图表或艺术作品——并转化为可复现的色彩系统。来源始终有据可查：颜色从哪里来、代表什么、适合用在哪里。

```r
library(biopalette)

get_palette("babel", n = 5)
get_palette("three_body")
get_palette("walter_white", type = "diverging")

preview_palette("gene_red")
palette_gallery()

# ggplot2 离散与连续尺度
scale_color_biopalette("three_body")
scale_fill_biopalette_gradient("mitonuclear_blue")
```

---

## 安装

```r
# 开发版
devtools::install_github("evanbio/biopalette")
```

**系统要求：** R ≥ 4.1.0

---

## 配色列表

点击名称查看来源页：源图、色表，以及适合的使用场景。

| 名称 | 类型 | 颜色数 | 推荐用途 | 来源 |
|---|---|---:|---|---|
| [`gene_red`](https://github.com/evanbio/biopalette/tree/main/palettes/gene_red) | 定性 | 2 | 重点信号与深色或中性色的对比 | *风骚律师* — Gene Takavic 的红色外套 |
| [`walter_white`](https://github.com/evanbio/biopalette/tree/main/palettes/walter_white) | 发散 | 5 | 围绕中性中心的有符号连续数值 | *绝命毒师* — 荒漠到天空 |
| [`walter_white2`](https://github.com/evanbio/biopalette/tree/main/palettes/walter_white2) | 定性 | 5 | 不超过五个无序类别 | *绝命毒师* — 低饱和大地色调 |
| [`walter_white3`](https://github.com/evanbio/biopalette/tree/main/palettes/walter_white3) | 发散 | 5 | 暖色调的有符号连续数值 | *绝命毒师* — 暖色对应版本 |
| [`babel`](https://github.com/evanbio/biopalette/tree/main/palettes/babel) | 定性 | 21 | 需要标签或位置辅助的多类别图形 | 泛癌骨髓细胞图谱（Cell, 2021）— 22 种细胞类型，21 种声音 |
| [`bcell_atlas`](https://github.com/evanbio/biopalette/tree/main/palettes/bcell_atlas) | 定性 | 7 | 四到七个需要标签或位置辅助的类别 | 泛癌 B 细胞图谱（Cell, 2024）— 图形摘要 |
| [`bcell_atlas2`](https://github.com/evanbio/biopalette/tree/main/palettes/bcell_atlas2) | 发散 | 5 | 暖色与冷色生物学状态之间的有符号变化 | 泛癌 B 细胞图谱（Cell, 2024）— IgA 到 IgG 的转变 |
| [`bcell_clusters`](https://github.com/evanbio/biopalette/tree/main/palettes/bcell_clusters) | 定性 | 20 | 需要标签、位置或分面的多类别图形 | 泛癌 B 细胞图谱（Cell, 2024）— Figure 1B cluster 图例 |
| [`three_body`](https://github.com/evanbio/biopalette/tree/main/palettes/three_body) | 定性 | 3 | 三个群组、谱系或轨迹 | 泛癌骨髓细胞图谱（Cell, 2021）— 三条树突状细胞分化轨迹 |
| [`mitonuclear_blue`](https://github.com/evanbio/biopalette/tree/main/palettes/mitonuclear_blue) | 渐进 | 6 | 冷色调的低到高连续数值 | 衰老中的线粒体—细胞核通信（TIBS, 2022）— 年轻状态蓝 |
| [`mitonuclear_orange`](https://github.com/evanbio/biopalette/tree/main/palettes/mitonuclear_orange) | 渐进 | 6 | 暖色调的低到高连续数值 | 衰老中的线粒体—细胞核通信（TIBS, 2022）— 衰老状态橙 |
| [`heat_light`](https://github.com/evanbio/biopalette/tree/main/palettes/heat_light) | 定性 | 2 | 成对类别或实验条件 | 键两性解离（Nature, 2024）— 热与光将自由基对转为离子对 |
| [`tam_pastel`](https://github.com/evanbio/biopalette/tree/main/palettes/tam_pastel) | 定性 | 6 | 浅色背景上的四到六个类别 | 泛癌骨髓细胞图谱（Cell, 2021）— 柔和的 TAM 状态色 |
| [`cancer_mosaic`](https://github.com/evanbio/biopalette/tree/main/palettes/cancer_mosaic) | 定性 | 15 | 需要标签或位置辅助的十到十五个类别 | 泛癌骨髓细胞图谱（Cell, 2021）— 癌种马赛克 |
| [`lactate_steps`](https://github.com/evanbio/biopalette/tree/main/palettes/lactate_steps) | 定性 | 5 | 五个离散流程阶段或研究组别 | 乳酸代谢与免疫治疗（JECCR, 2024）— 五个研究阶段 |

---

## 从色板到图形

**biopalette** 提供在 R 中获取和应用图像启发配色的接口。
**[Tessera](https://folio.evanzhou.org/tessera)** 记录色板的来源图像、示例数据和可复现的
R 作图配方；**[Palette Lab](https://folio.evanzhou.org/apps/palette-lab)** 固定数据和图形结构，
在 17 类图形场景中比较色板的实际表现。下面的总览和图形均来自 Palette Lab 的真实渲染；Tessera 链接提供对应的图形配方和数据背景。

<p align="center">
  <img src="man/figures/showcase/showcase-lab-overview.webp"
       alt="Palette Lab 图形场景总览"
       width="100%" />
</p>

同一套色板用于点、线、填充区域、热图单元格、集合交集、生存曲线或全基因组信号时，表现可能完全不同。下面这些图形来自 Tessera 配方，也对应 Palette Lab 中的色板比较场景。

<table>
<tr>
<td width="50%" align="center">
  <a href="https://folio.evanzhou.org/tessera/figures/grouped_scatter">
    <img src="man/figures/showcase/showcase-scatter.webp" alt="使用 babel 的分组散点图" width="100%" />
  </a><br />
  <sub><b>分组散点图</b> · <code>babel</code></sub>
</td>
<td width="50%" align="center">
  <a href="https://folio.evanzhou.org/tessera/figures/multi_line">
    <img src="man/figures/showcase/showcase-line.webp" alt="使用 walter_white2 的多组折线图" width="100%" />
  </a><br />
  <sub><b>多组折线图</b> · <code>walter_white2</code></sub>
</td>
</tr>
<tr>
<td width="50%" align="center">
  <a href="https://folio.evanzhou.org/tessera/figures/correlation_heatmap">
    <img src="man/figures/showcase/showcase-heatmap.webp" alt="使用 walter_white 的相关性热图" width="100%" />
  </a><br />
  <sub><b>相关性热图</b> · <code>walter_white</code></sub>
</td>
<td width="50%" align="center">
  <a href="https://folio.evanzhou.org/tessera/figures/bar">
    <img src="man/figures/showcase/showcase-stacked.webp" alt="使用 lactate_steps 的按发色划分眼色构成图" width="100%" />
  </a><br />
  <sub><b>按发色划分的眼色构成</b> · <code>lactate_steps</code></sub>
</td>
</tr>
<tr>
<td width="50%" align="center">
  <a href="https://folio.evanzhou.org/tessera/figures/survival_curve">
    <img src="man/figures/showcase/showcase-survival.webp" alt="使用 heat_light 的 Kaplan–Meier 生存曲线" width="100%" />
  </a><br />
  <sub><b>Kaplan–Meier 生存曲线</b> · <code>heat_light</code></sub>
</td>
<td width="50%" align="center">
  <a href="https://folio.evanzhou.org/tessera/figures/manhattan">
    <img src="man/figures/showcase/showcase-manhattan.webp" alt="使用 cancer_mosaic 的 Manhattan 图" width="100%" />
  </a><br />
  <sub><b>Manhattan 图</b> · <code>cancer_mosaic</code></sub>
</td>
</tr>
</table>

---

## 函数列表

<details>
<summary><b>🎨 配色获取</b>（4 个）</summary>

- `get_palette()` — 按名称、类型和数量获取颜色
- `palette_info()` — 获取单个配色的元数据
- `list_palettes()` — 以数据框形式列出所有配色
- `palette_gallery()` — 分页浏览全部配色预览

</details>

<details>
<summary><b>🔧 配色管理</b>（3 个）</summary>

- `create_palette()` — 将新配色写入 JSON
- `remove_palette()` — 按名称删除配色
- `preview_palette()` — 渲染色块预览图

</details>

<details>
<summary><b>📊 ggplot2 尺度</b>（6 个）</summary>

- `scale_color_biopalette()` / `scale_colour_biopalette()` — 离散颜色尺度
- `scale_fill_biopalette()` — 离散填充尺度
- `scale_color_biopalette_gradient()` / `scale_colour_biopalette_gradient()` — 连续颜色渐变
- `scale_fill_biopalette_gradient()` — 连续填充渐变

</details>

<details>
<summary><b>🔵 颜色工具</b>（2 个）</summary>

- `hex2rgb()` — HEX 转 RGB
- `rgb2hex()` — RGB 转 HEX

</details>

---

## 开源协议

MIT License © 2025–2026 [Yibin Zhou](mailto:evanzhou.bio@gmail.com)

<div align="center">

**用 ❤️ 制作 by [Yibin Zhou](https://github.com/evanbio)**

</div>
