# メタデータの分析を行うにはどうすればいいか？
# 行は種であり、列はサンプル
# コントラスト基準要素を生成する。
# なにこれ？
# 生データまたは変換データをilrvecからのベクトルに直接投影する？
# 数値データに変換
ilrvec(list(c(4,5),c(1,2,3)),n=5)
v1 <- ilrvec(list(c(4,5),c(1,2,3)),n=5) ## separate {1,2,3|4,5}
v2 <- ilrvec(list(1,c(2,3)),n=5) ## separate {1|2,3}
basis <- matrix(c(v1,v2),ncol=2,byrow=F)
basis
# basisは正規直交なので
t(basis) %*% basis

# Phylofactorizationは系統発生のすべてのエッジを反復処理する
# それぞれがilrvecで投影されたデータとメタデータを使用してモデルを生成する
# 最適なモデルの選択方法は、２種類ある
# 分散を最大化する：choice = 'var' 
## -> 説明された分散と説明されていない分散（全体のF統計）の比率が高いほど予測可能な因子が見つかる
# F値を最大化する：hoice = 'F'
## -> データセット内の分散の多くを捉える因子が見つかる
set.seed(1)
m=length(species)
n=50 #number of samples
MetaData <- data.frame('latitude'=runif(n,0,90))
BodySize <- matrix(rlnorm(m*n),nrow=m)
rownames(BodySize) <- tree$tip.label # This step is necessary for PhyloFactor
for (spp in clade1){
  BodySize[spp,] <- rlnorm(n,meanlog=MetaData$latitude/15)
}
for (spp in clade2){
  BodySize[spp,] <- rlnorm(n,meanlog=-MetaData$latitude/10)
}
for (spp in clade3){
  BodySize[spp,] <- rlnorm(n,meanlog=MetaData$latitude/30)
}
cols <- viridis::viridis(3)
pf.heatmap(tree=tree,Data=log(BodySize[,order(MetaData$latitude)]),color=NA)+
  ggtree::geom_hilight(128,fill=cols[1])+
  ggtree::geom_hilight(131,fill=cols[2])+
  ggtree::geom_hilight(186,fill=cols[3])
# 分散とF値をパラメータとして利用するそれぞれの結果を比較
# yがない
g.F <- glm(y.F~x)
g.var <- glm(y.var~x)
output <- rbind(getStats(g.F),getStats(g.var))
rownames(output) <- c("y.F","y.var")
output

# 以上の処理をphylofactorを用いると
pf_PhyloFactor <- PhyloFactor(BodySize,tree,MetaData,
                              frmla = Data~latitude,nfactors=3,choice='F')
# 全結果を表示
pf_PhyloFactor
# 因子のみ表示
pf_PhyloFactor$factors
# 各クレードごとの計算
pf_PhyloFactor$models[[1]]
# オプションの引数をglmに渡すことで、
# 複数の回帰、バランスコントラストによるメタデータの予測などをすべて実装できる
# 以下は加重二項回帰を使用して、カテゴリ変数（サンプルサイトなど）をオフセットで予測する多重回帰
MetaData$x <- rnorm(n)
MetaData$z <- rnorm(n)
MetaData$y <- factor(rep(c('a','b'),each=n/2))
wts <- seq(0,1,length.out=n)
ix <- 20:30
pf_demo <- PhyloFactor(BodySize,tree,MetaData,frmla=y~Data+x+offset(z),
                       family=binomial,weights=wts,subset=ix,
                       nfactors=2)
pf_demo
data.frame('sample'=ix,
           'model_weights'=pf_demo$models[[1]]$prior.weights,
           'input_weights'=wts[ix])[1:4,]

# PhyloFactorのまとめ
# コントラスト基準要素に投影されたデータの目的関数に基づいて系統を分割し、
# 入力frmlaのDataという用語を使用して、
# 柔軟な回帰スタイルの分析を実装できます。