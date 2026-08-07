---
# 色板名。snake_case，^[a-z][a-z0-9_]*$。
# 三处必须一致：这里、文件夹名、inst/extdata/palettes/<type>/<name>.json。
# 也就是 get_palette("<name>") 里的那个名字。
name: palette_name

# 收藏编号。整数，按收进集子的先后排。
# 只是元数据，不进路径 —— 所以重新编号是零成本的。
index: 0

# 结构维度：这套色**能用来画什么**。
# qualitative | sequential | diverging
# 必须与 JSON 的 type 一致（它决定 JSON 放在哪个子目录）。
type: qualitative

# 出处维度：色是从哪儿取的。与 type 正交，不混用。
# paper | screen
source: paper

# 源图文件名，在 palettes/_source/ 下，不含路径、不含扩展名。与色板同名。
# 一图出多套色时，用第一个用它的那个色板名 —— walter_white / 2 / 3 都写 walter_white。
# 指向同一张图这件事本身就说明了同源，正文里不必再写一遍。
image: palette_name

# 收进集子的日子，YYYY-MM-DD。
date: 2026-01-01
---

# palette_name

## Source

![source](../_source/palette_name.jpg)

为什么是这张图。它是什么、出自哪里、意味着什么。

写故事，不写参数。这一段是这个色板存在的理由，也是它和一串十六进制的区别。

如果取色时做了转译——比如纯黑纯白造成色阶断层，手工补了一档过渡——在这里说明。
**没发生就不写，不留空栏。**

## Palette

![preview](preview.png)

<!-- HEX 照抄 JSON，顺序有意义。
     第三列：影视取色写色名（Sky teal），论文取色写原图分组名（Macro_SPP1）——
     后者要补一句说明，声明那只是出处记录，用的人可以自行映射。 -->

| # | HEX | Color |
|---|---|---|
| 1 | `#000000` | 色名 or 原图分组名 |

## Use cases

<!-- 具体的图种或对比场景。不写"适合数据可视化"这种等于没说的话。 -->

- ...
