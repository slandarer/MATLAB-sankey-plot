% sankey demo17 : Land use transition sankey diagram
% -----------------------
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

% 本示例来源于微信公众号「图绘科研」的原创教程
% 《图绘科研｜MATLAB科研绘图：土地利用转移桑基图绘制教程》，作者为 QDY

figure('Name','sankey demo17', 'Units','normalized', 'Position',[.05,.2,.6,.6])

layerNames = {'2005', '2010', '2015', '2020'};
nodeNames  = {'耕地', '林地', '草地', '水域', '建设用地', '未利用地'};
LN = length(layerNames); NN = length(nodeNames);

nodeTitle  = '土地利用类型';
CList = [.86, .70, .45;   % 耕地：浅棕色
         .35, .62, .35;   % 林地：绿色
         .68, .80, .45;   % 草地：黄绿色
         .45, .72, .88;   % 水域：蓝色
         .86, .42, .38;   % 建设用地：红橙色
         .68, .64, .58];  % 未利用地：灰褐色
T12 = [300,  35,  20,  5, 55,  5;
        20, 230,   5,  5,  0,  0;
        25,  10, 130,  5,  5,  5;
         2,   5,   3, 48,  2,  0;
        20,   0,   2,  0, 98,  0;
        13,   5,  10,  2, 10, 30];  % 2005 -> 2015
T23 = [300,  15,  10,  5,  45,  5;
        10, 260,   5,  5,   5,  0;
        15,  10, 125,  3,  12,  5;
         1,   3,   2, 58,   1,  0;
        18,   2,   3,  1, 145,  1;
         6,  10,  15,  3,  12, 14]; % 2015 -> 2020
T34 = [300,  10,   6,  4,  28,  2;
         5, 285,   4,  5,   1,  0;
        10,  12, 120,  4,   9,  5;
         1,   5,   2, 60,   2,  0;
        12,   2,   3,  1, 202,  0;
         2,   1,  15,  1,   8, 23]; % 2020 -> 2022

% 获取全局邻接矩阵 (Assemble global block matrix)
layerAdj = {T12, T23, T34};
adjMat = mergeAdjMat(layerAdj);

% 计算节点流量 (Compute node values)
nodeVal = zeros(NN, LN);
for i = 1:(LN - 1)
    nodeVal(:, i)     = max(nodeVal(:, i), sum(layerAdj{i}, 2)); 
    nodeVal(:, i + 1) = max(nodeVal(:, i + 1), sum(layerAdj{i}, 1).');
end

% 创建桑基图对象 (Create sankey plot object)
SK = SSankey([],[],[], 'AdjMat',adjMat);
SK.RenderingMethod = 'left';                 % 链接与左侧节点颜色相同 (Rendering Method : 'left')
SK.ColorList = repmat(CList, [LN, 1]);       % 为每个节点分配颜色 (Assign colors to all nodes)
SK.NodeList = cellstr(num2str(nodeVal(:)));  % 设置节点标签 (Set node labels)
% SK.NodeList = repmat(nodeNames, [1, LN]);
% SK.LabelLocation = 'center';
% SK.NodeList = arrayfun(@(x) num2str(x), nodeVal(:), 'UniformOutput', false);
SK.LabelLocation = 'left';                   % 设置节点标签位于左侧 (Place labels on left side)
SK.draw()

% 添加层标签及图例 (Add layer labels and legend)
text(1:LN, zeros(1, LN), layerNames, ...
    'HorizontalAlignment','center', 'VerticalAlignment','top', ...
    'FontName','Times New Roman', 'FontSize',17, 'FontWeight','bold')
set(gca, 'Positio',[.13, .11, .68, .815]);
lgdHdl = legend(SK.BlockHdl(1:NN), nodeNames, ...
    'FontSize',15, 'Box','off', 'FontName','宋体');
lgdHdl.Title.String = nodeTitle;
lgdHdl.Position = [.8, .55, .2, .4];
lgdHdl.ItemTokenSize = [20, 20];


% for i = 1:length(SK.LabelHdl)
%     set(SK.LabelHdl(i), 'FontSize',14, 'FontName','宋体')
% end