%% sankey demo8 : A complex demo

figure('Name','sankey demo8','Units','normalized','Position',[.05,.2,.5,.56])

% 随机生成数据(Randomly generated data)
clc;clear;rng(1)
layerNodeName = {'A','B','C','D','E'};
layerNodeNum = [9,6,4,7,10];
cumSumNodeNum = [0, cumsum(layerNodeNum)];
nodeList{sum(layerNodeNum)} = '';
layerAdj{length(layerNodeNum) - 1} = [];
layerAdj{1} = rand(layerNodeNum(1:2));

for i = 1:length(layerNodeNum)
    nodeList((cumSumNodeNum(i) + 1):cumSumNodeNum(i + 1)) = ...
        compose([layerNodeName{i},'%d'], 1:layerNodeNum(i));
end
for i = 2:(length(layerNodeNum) - 1)
    layerAdj{i} = rand(layerNodeNum(i:(i + 1)));
    layerAdj{i} = layerAdj{i}./sum(layerAdj{i}, 2).*(sum(layerAdj{i - 1}, 1).');
end
adjMat = mergeAdjMat(layerAdj);

% 创建桑基图对象(Create a Sankey diagram object)
SK=SSankey([],[],[], 'AdjMat',adjMat);
SK.NodeList = nodeList;


% 修改链接颜色渲染方式(Set link color rendering method)
% 'left'/'right'/'interp'(default)/'map'/'simple'
SK.RenderingMethod='interp';  

% 修改对齐方式(Set alignment)
% 'up'/'down'/'center'(default)
SK.Align='center';

% 修改文本位置(Set Text Location)
% 'left'(default)/'right'/'top'/'center'/'bottom'
SK.LabelLocation='top';

% 设置缝隙占比(Separation distance proportion)
SK.Sep=.4;

% 开始绘图(Start drawing)
SK.draw()





