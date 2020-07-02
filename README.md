# my_phylofactor_practice
微生物の進化系統分類のパッケージ"phylofactor"の練習リポジトリ

# メモ
## 準備
```R
library(phylofactor)
data("FTmicrobiome")
```
データセットFTmicrobiomeは、二人から採取した糞便および舌の身体部位からの細菌  


## 回帰分析

```R
PF <- PhyloFactor(OTUTable,tree,body.site,nfactors=3)
```
|入力引数|  役割  |
| ---- | ---- |
|  OTUTable  |  TD  |
|  TD  |  TD  |
