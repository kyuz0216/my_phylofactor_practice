# Factors, Groups, and Bins
# データセットFTmicrobiomeを用いる
# 上記の
data(FTmicrobiome)
names(FTmicrobiome)
# 補足: taxonomy -> 分類
# 同様の流れで分析
# 今回は、FTmicrobiomeのデータセット中から100種類抽出して実験
set.seed(1)
# 木の作成
tree <- FTmicrobiome$tree
# 100種類サンプルを抽出
species <- sample(tree$tip.label,100)
# なにこれ？
tree <- drop.tip(tree,setdiff(tree$tip.label,species))
# 分類
taxonomy <- FTmicrobiome$taxonomy
# 各クレードを抽出
clade1 <- phangorn::Descendants(tree,128,'tips')[[1]]
clade2 <- phangorn::Descendants(tree,186,'tips')[[1]]
clade3 <- phangorn::Descendants(tree,131,'tips')[[1]]
# 各クレードを出力
# "clade1 has 45 species, clade2 has 4 species and clade3 has 42 species"
paste('clade1 has',length(clade1),
      'species, clade2 has',length(clade2),
      'species and clade3 has',length(clade3),
      'species')
# twoSampleFactor
# 全体の大きさ？、母集団サイズ、存在/不在などのデータのベクトルから
# t検定、ウィルコックス検定、フィッシャー正確検定etcを用いて
# 分割する？？？？
set.seed(1)
# rlnorm : R で対数正規分布から乱数を生成する関数
BodySize <- rlnorm(100)
# clade1とclade2の....?
# なぜ4をかけたり、割ったりしている？？
BodySize[clade1] <- rlnorm(length(clade1))*4
BodySize[clade2] <- rlnorm(length(clade2))/4
# BodySizeのlogを取っている
logBodySize <- log(BodySize)
# 計算時間が表示される -> 大規模な計算の時には便利
pf_twoSample <- twoSampleFactor(logBodySize,tree,nfactors=2)
# 2標本分布の確認
pf_twoSample

# フィッシャーの正確検定を行う
# フィッシャーの正確検定は、input method = "Fisher"と指定すればいい
# rbinom(n, size, prob)：二項分布に従う乱数
# nは発生させる乱数の数
# sizeは各乱数におけるベルヌーイ試行の回数
# probは各ベルヌーイ試行における成功確率
presence <- rbinom(100,1,.5)
presence[clade1] <- rbinom(length(clade1),1,.9)
presence[clade2] <- rbinom(length(clade2),1,.1)
pf_fisher <- twoSampleFactor(presence,tree,nfactors=2,method = "Fisher",ncores = 2)
pf_fisher
