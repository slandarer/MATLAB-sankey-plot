%% sankey demo18 : State transition matrix visualization
% -----------------------
% gitee/github      : slandarer
% fileexchange      : Zhaoxu Liu / slandarer
% 公众号            : slandarer随笔
% 知乎              : slandarer

% 本示例来源于: 代号鸢黄月英

figure('Name','sankey demo18', 'Units','normalized', 'Position',[.05,.2,.6,.6])
% 定义状态转移矩阵 (Define transition matrix S)
S = [0, .4, .0; 
     0, .0, .6; 
     1, .6, .4];
% 初始状态向量 (Initial state vector)
s0 = [0; 0; 1];
% 时间层数量 (Number of time layers)
LN = 7; NN = size(S, 1);
% 状态颜色配置 (Color palette for states)
CList = [245,210,136; 121, 84,181; 137,170,237]./255;

layerNames = compose('Round-%d', 1:LN);
nodeNames = {'Orange-Star', 'Purple-Star', 'Blue-Star'};

% 计算状态随时间分布 (Compute state distribution over time)
states = zeros(NN, LN - 1);
states(:,1) = s0;
for t = 2:(LN - 1)
    states(:, t) = S * states(:, t - 1);
end
% 构建层间邻接矩阵 (Build inter-layer adjacency matrices)
A = rot90(fliplr(S));
layerAdj = cell(1, LN - 1);
for t = 1:(LN - 1)
    layerAdj{t} = diag(states(:, t))*A;
end
% 绘制桑基图 (Render the Sankey diagram)
adjMat = mergeAdjMat(layerAdj);
SK = SSankey([],[],[], 'AdjMat',adjMat);
SK.Layer = kron(1:LN, ones(1, NN));
SK.ColorList = repmat(CList, [LN, 1]);
SK.NodeList = repmat({''}, 1, LN*NN);
SK.RenderingMethod = 'left';
SK.ValueLabelLocation = 'left';
SK.Align = 'down';
SK.draw()

legend(SK.blockHdl(1:NN), nodeNames, 'FontSize',15, 'FontName','Times New Roman', 'Box','off')
ax = gca;
text(1:LN, ones(1, LN).*ax.YLim(2), layerNames, ...
    'HorizontalAlignment','center', 'VerticalAlignment','top', ...
    'FontName','Times New Roman', 'FontSize',15)
