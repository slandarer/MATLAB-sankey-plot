classdef SSankey < handle
% SSankey Create and customize Sankey diagrams (桑基图对象)
%   SS = SSankey(source, target, value); creates a Sankey diagram from
%   three arrays: source nodes, target nodes, and flow values.
%   通过源节点、目标节点和流量值创建桑基图对象。
%
%   SS = SSankey([], [], [], 'AdjMat', adjMat); creates a Sankey diagram
%   from an adjacency matrix where element (i,j) represents flow from i to j.
%   通过邻接矩阵创建桑基图对象，元素 (i,j) 表示从 i 到 j 的流量。
%
%   SS = SSankey(ax, ___); creates a Sankey diagram in the specified axes.
%   在特定坐标区域生成桑基图对象。
%
%   SS = SSankey(___, propName, propVal); specifies property name-value pairs
%   when creating the Sankey diagram object.
%   创建桑基图对象时为其设置属性。
%   
%   SS.propName = propVal; sets properties for the Sankey diagram object
%   after creation, before rendering.
%   创建桑基图对象后，绘图前为其设置属性。
%
%   SS = SS.draw(); renders the Sankey diagram.
%   渲染桑基图对象。
% =========================================================================
% Copyright (c) 2023-2026, Zhaoxu Liu / slandarer
% -------------------------------------------------------------------------
% Zhaoxu Liu / slandarer (2026). sankey plot 
% (https://www.mathworks.com/matlabcentral/fileexchange/128679-sankey-plot), 
% MATLAB Central File Exchange. Retrieved May 19, 2026.
% =========================================================================
% % Basic usage (基本用法)
%
%     links = {'a1','A',1.2;   'a2','A',1;  'a1','B',.6;    'a3','A',1; 'a3','C',.5;
%               'b1','B',.4;   'b2','B',1;   'b3','B',1;    'c1','C',1;
%                'c2','C',1;   'c3','C',1;   'A','AA',2;  'A','BB',1.2;
%              'B','BB',1.5; 'B','AA',1.5; 'C','BB',2.3;  'C','AA',1.2};
% 
%     % Create a Sankey diagram object (创建桑基图对象)
%     SK = SSankey(links(:, 1), links(:, 2), links(:, 3));
% 
%     % Start drawing (开始绘图)
%     SK.draw()
% 
% % Basic usage - AdjMat (邻接矩阵用法)
% 
%     % Define inter-layer adjacency matrices (定义层间邻接矩阵)
%     A12 = [1, 2, 1; 1, 2, 3; 2, 0, 1];
%     A23 = [1, 4; 2, 1; 0, 3];
%     A34 = [1, 5; 2, 3];
% 
%     % Assemble global block matrix (组装全局分块矩阵)
%     adjMat = mergeAdjMat({A12, A23, A34});
% 
%     SK = SSankey([], [], [], 'AdjMat', adjMat);
%     SK.draw()



% =========================================================================
% # update 2.0.0(2024-02-04)
% see natureSankeyDemo1.m
%
% + 层向右对齐(Align layers to the right)
%   try : obj.LayerOrder='reverse';
%
% + 单独调整每层间隙大小(Adjust the Sep size of each layer separately)
%   try : obj.Sep=[.2,.06,.05,.07,.07,.08,.15];
% =========================================================================
% # update 3.0.0(2024-04-15)
% see sankeyDemo9.m sankeyDemo10.m sankeyDemo11.m
% 
% + 通过邻接矩阵创建桑基图(Creating a Sankey diagram through adjacency matrix)
%   method 1 :
%     SK=SSankey([],[],[],'AdjMat',adjMat);
%   method 2 :
%     SK=SSankey([],[],[],'NodeList',nodeList,'AdjMat',adjMat)
%   method 3 :
%     SK=SSankey([],[],[]);
%     SK.AdjMat=adjMat;
% 
%   try : 
%     adjMat=zeros(10,10);
%     layerNum=[3,3,2,2];
%     layerInd=cumsum([0,layerNum]);
%     for i=1:length(layerInd)-2
%         adjMat(layerInd(i)+1:layerInd(i+1),layerInd(i+1)+1:layerInd(i+2))=randi([1,6],[layerNum([i,i+1])]);
%     end
%     disp(adjMat)
%     SK=SSankey([],[],[],'NodeList',nodeList,'AdjMat',adjMat);
%     SK.draw()
%
% + 每层情况可被设置(Each layer state can be set)
%   try : obj.Layer = [1,1,1, 2,2,2, 3,3, 4,4,...];
% 
% + 每个节点可在x方向上位移(Each node can be displaced in the x-direction)
%   try : obj.moveBlockX(n,dx)
% =========================================================================
% # update 3.1.0(2024-05-15)
% see sankeyDemo12.m sankeyDemo13.m
% + 为链接添加显示数值的文本(Display value labels for each link)
%   try : SK.ValueLabelLocation='left';
% =========================================================================
% # update 4.0.0(2024-05-17)
% see sankeyDemo14.m sankeyDemo15.m
% + 增添节点及链接(Add node and link)
%   try : obj.addNode(name,layer)
%   try : obj.addLink(source,target,value)
% =========================================================================
% # version 5.0.0
% + 左键添加数据提示框，右键隐藏高亮 
%   Left-click to add data tooltip, right-click to hide highlight
% =========================================================================
% # version 5.1.0
% + 调整每一层标签位置(Set label location for each layer)
%   try : obj.setLabelLocation(1, 'left')

    properties
        % Core data (核心数据)
        Source; Target; Value;               % Source, target, and flow value (源、目标、流量值)
        SourceInd; TargetInd; % read only    % Indices of source and target (源/目标索引)
        
        % Layer management (层级管理)
        Layer;                               % Layer assignment for each node (节点层级分配)
        LayerPos; % read only                % Position of each layer (每层位置)
        MovePos; % read only                 % Manual displacement offset (手动位移偏移)
        LayerOrder = 'normal';               % Layer propagation direction (层级传播方向)
        
        % Adjacency matrix (邻接矩阵)
        AdjMat;                              % Adjacency matrix (邻接矩阵)
        BoolMat; % read only                 % Logical matrix of non-zero connections (非零连接逻辑矩阵)
        
        % Rendering options (渲染选项)
        RenderingMethod = 'interp';          % 'left'/'right'/'interp'/'map'/'simple'
        LabelLocation = 'left';              % 'left'/'right'/'top'/'center'/'bottom' (标签位置)
        ValueLabelLocation = 'none';         % 'left'/'right'/'center'/'none' (数值标签位置)
        ValueLabelFormat = @(X) num2str(X);  % Value formatting function (数值格式化函数)
        Align = 'center';                    % 'up'/'down'/'center' (垂直对齐方式)
        BlockScale = 0.05;                   % Block width factor (块宽度因子) > 0
        Sep = 0.05;                          % Gap between blocks (块间间隙) >= 0
        
        % Node properties (节点属性)
        NodeList = {};                       % Cell array of node names (节点名称元胞数组)
        
        % Data tip configuration (数据提示框配置)
        % {Alpha, SrcLabel, TgtLabel, ValLabel, Format}
        dataTipFormat = {1, 'Source:', 'Target:', 'Value:', 'auto'};  
        
        % Color settings (颜色设置)
        ColorList = [[ 65, 140, 240; 252, 180,  65; 224,  64,  10;   5, 100, 146; 
                      191, 191, 191;  26,  59, 105; 255, 227, 130;  18, 156, 221;
                      202, 107,  75;   0,  92, 219; 243, 210, 136;  80,  99, 129; 
                      241, 185, 168; 224, 131,  10; 120, 147, 190]./255;
                     [127,  91,  93; 187, 128, 110; 197, 173, 143;  59,  71, 111; 
                      104,  95, 126;  76, 103,  86; 112, 112, 124;  72,  39,  24; 
                      197, 119, 106; 160, 126,  88; 238, 208, 146]./255 ];
        
        % Graphics handles (图形句柄)
        BlockHdl;                            % Node block handles (方块句柄)
        LinkHdl;                             % Link ribbon handles (连接句柄)
        LabelHdl;                            % Node label handles (标签句柄)
        ValueLabelHdl;                       % Value label handles (数值标签句柄)
        ax;                                  % Axes handle (坐标区句柄)
        Parent;                              % Parent figure or axes (父容器)
        
        % Internal state (内部状态)
        BN; LN; VN; % read only              % Number of nodes, layers, links (节点数、层数、连接数)
        TotalLen; SepLen; % read only        % Total block length and separation length (总块长度、间隔长度)
        
        % Parameter list for name-value pair parsing (参数解析列表)
        arginList = {'RenderingMethod', 'LabelLocation', 'ValueLabelLocation', 'BlockScale', 'Layer', ...
                     'Sep', 'Align', 'ColorList', 'Parent', 'NodeList', 'AdjMat'}
    end

    methods
% =========================================================================
% Constructor (构造函数)
% =========================================================================
        function obj = SSankey(varargin)
            % Parse axes handle (解析坐标区句柄)
            if isa(varargin{1}, 'matlab.graphics.axis.Axes')
                obj.ax = varargin{1};
                varargin(1) = [];
            end
            
            % Parse core data (解析核心数据)
            obj.Source = varargin{1};
            obj.Target = varargin{2};
            obj.Value  = varargin{3};
            varargin(1:3) = [];
            
            % Parse name-value pairs (解析名称-值对)
            for i = 1:2:(length(varargin) - 1)
                tid = ismember(lower(obj.arginList), lower(varargin{i}));
                if any(tid)
                    obj.(obj.arginList{tid}) = varargin{i + 1};
                end
            end
            
            % Set default axes (设置默认坐标区)
            if isempty(obj.ax) && (~isempty(obj.Parent))
                obj.ax = obj.Parent;
            end
            if isempty(obj.ax)
                obj.ax = gca;
            end
            obj.ax.NextPlot = 'add';
            
            % Generate NodeList from data if not provided (若未提供则从数据生成)
            if isempty(obj.NodeList)
                if isempty(obj.Source)
                    if ~isempty(obj.AdjMat)
                        obj.NodeList = compose('node%d', 1:size(obj.AdjMat, 1));
                    end
                else
                    obj.NodeList = [obj.Source; obj.Target];
                    obj.NodeList = unique(obj.NodeList, 'stable');
                end
            end
            
            % Initialize node colors (初始化节点颜色)
            obj.BN = length(obj.NodeList);
            if length(obj.NodeList) > size(obj.ColorList, 1)
                obj.ColorList = [obj.ColorList; rand(length(obj.NodeList), 3) * 0.7];
            end
            obj.MovePos = zeros(obj.BN, 4);
            
            % Configure axes appearance (配置坐标区外观)
            obj.ax.YDir      = 'reverse';
            obj.ax.XColor    = 'none';
            obj.ax.YColor    = 'none';
        end


% =========================================================================
% Main drawing method (主绘图方法)
% =========================================================================
        function draw(obj)      
            % Generate adjacency matrix (生成邻接矩阵)
            obj.getAdjMat()
            
            obj.BoolMat = abs(obj.AdjMat) > 0;
            if any(any(obj.BoolMat + obj.BoolMat.' == 2))
                warning('Currently, bidirectional flow sankey diagram plotting is not supported.');
            end
            obj.VN = sum(sum(obj.BoolMat));
            
            % Compute layer and position (计算层级和位置)
            if isempty(obj.Layer)
                obj.getLayer()
            end
            obj.getLayerPos()
            
            % Draw links first (先绘制连接)
            for i = 1:obj.VN
                obj.drawLink(i)
            end
            
            % Draw nodes on top (再绘制方块)
            for i = 1:obj.BN
                drawNode(obj, i)
            end
            try
                axis(obj.ax, 'tight');
            catch
            end
        end


% =========================================================================
% Graphics property setters (图形属性设置方法)
% =========================================================================
        function setBlock(obj, n, varargin)
            set(obj.BlockHdl(n), varargin{:})
        end
        
        function setLink(obj, n, varargin)
            set(obj.LinkHdl(n), varargin{:})
        end
        
        function setLabel(obj, n, varargin)
            set(obj.LabelHdl(n), varargin{:})
        end
        
        function setValueLabel(obj, n, varargin)
            set(obj.ValueLabelHdl(n), varargin{:})
        end


% =========================================================================
% Dynamic node/link addition (动态添加节点/连接)
% =========================================================================
        function addLink(obj, S, T, V)
            obj.getAdjMat()
            if isempty(obj.BlockHdl)
                obj.AdjMat(S, T) = obj.AdjMat(S, T) + abs(V);
            else
                if obj.AdjMat(S, T) == 0
                    obj.AdjMat(S, T) = obj.AdjMat(S, T) + abs(V);
                    obj.getLayerPos()
                    [M, N] = find(obj.AdjMat ~= 0);
                    obj.drawLink(find(M == S & N == T))
                else
                    obj.AdjMat(S, T) = obj.AdjMat(S, T) + abs(V);
                    obj.getLayerPos()
                end
                obj.refresh()
            end
        end
        
        function addNode(obj, name, layer)
            obj.getAdjMat()
            obj.AdjMat(end + 1, :) = 0;
            obj.AdjMat(:, end + 1) = 0;
            
            % Set node name (设置节点名称)
            if nargin < 2
                obj.NodeList{end + 1} = compose('node%d', size(obj.AdjMat, 1));
            else
                obj.NodeList{end + 1} = name;
            end
            
            % Update internal state (更新内部状态)
            obj.BN = length(obj.NodeList);
            obj.BoolMat = abs(obj.AdjMat) > 0;
            if any(any(obj.BoolMat + obj.BoolMat.' == 2))
                warning('Currently, bidirectional flow sankey diagram plotting is not supported.');
            end
            obj.VN = sum(sum(obj.BoolMat));
            
            % Update layer assignment (更新层级分配)
            if isempty(obj.Layer)
                obj.getLayer()
                if nargin < 3
                    obj.Layer(end) = max(obj.Layer);
                else
                    obj.Layer(end) = layer;
                end
            else
                if nargin < 3
                    obj.Layer(end + 1) = max(obj.Layer);
                else
                    obj.Layer(end + 1) = layer;
                end
            end
            
            % Add default color and position (添加默认颜色和位置)
            obj.ColorList(end + 1, :) = rand(1, 3) * 0.7;
            obj.MovePos(end + 1, :) = 0;
            
            % Redraw if already rendered (若已渲染则重绘)
            if ~isempty(obj.BlockHdl)
                obj.getLayerPos()
                obj.drawNode(length(obj.NodeList))
                N = find(obj.Layer == obj.Layer(end));
                for n = 1:length(N)
                    obj.moveBlock(N(n))
                end
            end
        end

% =========================================================================
% Refresh and update methods (刷新与更新方法)
% =========================================================================
        function refresh(obj)
            tLayerPos = obj.MovePos + obj.LayerPos;
            obj.BoolMat = abs(obj.AdjMat) > 0;
            if any(any(obj.BoolMat + obj.BoolMat.' == 2))
                warning('Currently, bidirectional flow sankey diagram plotting is not supported.');
            end
            obj.VN = sum(sum(obj.BoolMat));
            
            % Prepare label locations (准备标签位置)
            if ischar(obj.LabelLocation)
                tLabelLocation = repmat({obj.LabelLocation}, 1, obj.BN);
            else
                tLabelLocation = obj.LabelLocation;
            end
            
            % Update nodes (更新节点)
            for n = 1:obj.BN
                set(obj.BlockHdl(n), 'XData', tLayerPos(n, [1, 2, 2, 1]));
                set(obj.BlockHdl(n), 'YData', tLayerPos(n, [3, 3, 4, 4]));
                
                switch tLabelLocation{n}
                    case 'right'
                        set(obj.LabelHdl(n), 'Position', [tLayerPos(n, 2), mean(tLayerPos(n, [3, 4]))]);
                    case 'left'
                        set(obj.LabelHdl(n), 'Position', [tLayerPos(n, 1), mean(tLayerPos(n, [3, 4]))]);
                    case 'top'
                        set(obj.LabelHdl(n), 'Position', [mean(tLayerPos(n, [1, 2])), tLayerPos(n, 3)]);
                    case 'center'
                        set(obj.LabelHdl(n), 'Position', [mean(tLayerPos(n, [1, 2])), mean(tLayerPos(n, [3, 4]))]);
                    case 'bottom'
                        set(obj.LabelHdl(n), 'Position', [mean(tLayerPos(n, [1, 2])), tLayerPos(n, 4)]);
                end
            end
            
            % Update links (更新连接)
            [obj.SourceInd, obj.TargetInd] = find(obj.AdjMat ~= 0);
            for n = 1:obj.VN
                tSource = obj.SourceInd(n);
                tTarget = obj.TargetInd(n);
                
                tS1 = sum(obj.AdjMat(tSource, 1:(tTarget - 1))) + tLayerPos(tSource, 3);
                tS2 = sum(obj.AdjMat(tSource, 1:tTarget))        + tLayerPos(tSource, 3);
                tT1 = sum(obj.AdjMat(1:(tSource - 1), tTarget))  + tLayerPos(tTarget, 3);
                tT2 = sum(obj.AdjMat(1:tSource, tTarget))        + tLayerPos(tTarget, 3);
                
                if isempty(tS1), tS1 = 0; end
                if isempty(tT1), tT1 = 0; end
                
                tX = [tLayerPos(tSource, 1), tLayerPos(tSource, 2), tLayerPos(tTarget, 1), tLayerPos(tTarget, 2)];
                qX = linspace(tLayerPos(tSource, 1), tLayerPos(tTarget, 2), 200);
                qT = linspace(0, 1, 50);
                
                qY1 = interp1(tX, [tS1, tS1, tT1, tT1], qX, 'pchip');
                qY2 = interp1(tX, [tS2, tS2, tT2, tT2], qX, 'pchip');
                YY = qY1 .* (qT' .* 0 + 1) + (qY2 - qY1) .* (qT');
                
                set(obj.LinkHdl(n), 'YData', YY, 'XData', qX);
                set(obj.ValueLabelHdl(n), 'String', [' ', obj.ValueLabelFormat(obj.AdjMat(obj.SourceInd(n), obj.TargetInd(n)))]);
                
                switch obj.ValueLabelLocation
                    case 'left'
                        set(obj.ValueLabelHdl(n), 'Position', [tLayerPos(tSource, 2), tS1/2 + tS2/2]);
                    case 'right'
                        set(obj.ValueLabelHdl(n), 'Position', [tLayerPos(tTarget, 1), tT1/2 + tT2/2]);
                    case 'center'
                        set(obj.ValueLabelHdl(n), 'Position', [tLayerPos(tSource, 2)/2 + tLayerPos(tTarget, 1)/2, tS1/4 + tS2/4 + tT1/4 + tT2/4]);
                    case 'none'
                        set(obj.ValueLabelHdl(n), 'Position', [tLayerPos(tSource, 2), tS1/2 + tS2/2]);
                end
            end
        end


% =========================================================================
% Link drawing (连接绘制)
% =========================================================================
        function drawLink(obj, n)
            [obj.SourceInd, obj.TargetInd] = find(obj.AdjMat ~= 0);
            tSource = obj.SourceInd(n);
            tTarget = obj.TargetInd(n);
            
            tS1 = sum(obj.AdjMat(tSource, 1:(tTarget - 1))) + obj.LayerPos(tSource, 3);
            tS2 = sum(obj.AdjMat(tSource, 1:tTarget))        + obj.LayerPos(tSource, 3);
            tT1 = sum(obj.AdjMat(1:(tSource - 1), tTarget))  + obj.LayerPos(tTarget, 3);
            tT2 = sum(obj.AdjMat(1:tSource, tTarget))        + obj.LayerPos(tTarget, 3);
            
            if isempty(tS1), tS1 = 0; end
            if isempty(tT1), tT1 = 0; end
            
            tX = [obj.LayerPos(tSource, 1), obj.LayerPos(tSource, 2), obj.LayerPos(tTarget, 1), obj.LayerPos(tTarget, 2)];
            if abs(tX(1) - tX(3)) < eps
                warning('Currently, flow between the same layer is not supported.');
            end
            
            qX = linspace(obj.LayerPos(tSource, 1), obj.LayerPos(tTarget, 2), 200);
            qT = linspace(0, 1, 50);
            
            qY1 = interp1(tX, [tS1, tS1, tT1, tT1], qX, 'pchip');
            qY2 = interp1(tX, [tS2, tS2, tT2, tT2], qX, 'pchip');
            
            XX = repmat(qX, [50, 1]);
            YY = qY1 .* (qT' .* 0 + 1) + (qY2 - qY1) .* (qT');
            
            % Color mapping (颜色映射)
            MeshC = ones(50, 200, 3);
            switch obj.RenderingMethod
                case 'left'
                    MeshC(:, :, 1) = MeshC(:, :, 1) .* obj.ColorList(tSource, 1);
                    MeshC(:, :, 2) = MeshC(:, :, 2) .* obj.ColorList(tSource, 2);
                    MeshC(:, :, 3) = MeshC(:, :, 3) .* obj.ColorList(tSource, 3);
                case 'right'
                    MeshC(:, :, 1) = MeshC(:, :, 1) .* obj.ColorList(tTarget, 1);
                    MeshC(:, :, 2) = MeshC(:, :, 2) .* obj.ColorList(tTarget, 2);
                    MeshC(:, :, 3) = MeshC(:, :, 3) .* obj.ColorList(tTarget, 3);
                case 'interp'
                    MeshC(:, :, 1) = repmat(linspace(obj.ColorList(tSource, 1), obj.ColorList(tTarget, 1), 200), [50, 1]);
                    MeshC(:, :, 2) = repmat(linspace(obj.ColorList(tSource, 2), obj.ColorList(tTarget, 2), 200), [50, 1]);
                    MeshC(:, :, 3) = repmat(linspace(obj.ColorList(tSource, 3), obj.ColorList(tTarget, 3), 200), [50, 1]);
                case 'map'
                    MeshC = MeshC(:, :, 1) .* obj.Value{n};
                case 'simple'
                    MeshC(:, :, 1) = MeshC(:, :, 1) .* 0.6;
                    MeshC(:, :, 2) = MeshC(:, :, 2) .* 0.6;
                    MeshC(:, :, 3) = MeshC(:, :, 3) .* 0.6;
            end
            
            % Create link surface (创建连接曲面)
            tLinkHdl = surf(obj.ax, XX, YY, XX .* 0, 'EdgeColor', 'none', 'FaceAlpha', 0.3, ...
                'CData', MeshC, 'UserData', n, 'ButtonDownFcn', @obj.onLinkClick);
            obj.LinkHdl = [obj.LinkHdl(1:n-1), tLinkHdl, obj.LinkHdl(n:end)];
            
            % Create value label (创建数值标签)
            switch obj.ValueLabelLocation
                case 'left'
                    tValueLabelHdl = text(obj.ax, obj.LayerPos(tSource, 2), tS1/2 + tS2/2, ...
                        [' ', obj.ValueLabelFormat(obj.AdjMat(obj.SourceInd(n), obj.TargetInd(n)))], ...
                        'FontSize', 12, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'left');
                case 'right'
                    tValueLabelHdl = text(obj.ax, obj.LayerPos(tTarget, 1), tT1/2 + tT2/2, ...
                        [obj.ValueLabelFormat(obj.AdjMat(obj.SourceInd(n), obj.TargetInd(n))), ' '], ...
                        'FontSize', 12, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'right');
                case 'center'
                    tValueLabelHdl = text(obj.ax, obj.LayerPos(tSource, 2)/2 + obj.LayerPos(tTarget, 1)/2, ...
                        tS1/4 + tS2/4 + tT1/4 + tT2/4, ...
                        obj.ValueLabelFormat(obj.AdjMat(obj.SourceInd(n), obj.TargetInd(n))), ...
                        'FontSize', 12, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'center');
                case 'none'
                    tValueLabelHdl = text(obj.ax, obj.LayerPos(tSource, 2), tS1/2 + tS2/2, ...
                        [' ', obj.ValueLabelFormat(obj.AdjMat(obj.SourceInd(n), obj.TargetInd(n)))], ...
                        'FontSize', 12, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'left', 'Visible', 'off');
            end
            obj.ValueLabelHdl = [obj.ValueLabelHdl(1:n-1), tValueLabelHdl, obj.ValueLabelHdl(n:end)];
        end


% =========================================================================
% Node drawing (节点绘制)
% =========================================================================
        function drawNode(obj, n)
            % Draw node block (绘制方块)
            obj.BlockHdl(n) = fill(obj.ax, obj.LayerPos(n, [1, 2, 2, 1]), ...
                obj.LayerPos(n, [3, 3, 4, 4]), obj.ColorList(n, :), 'EdgeColor', 'none');

            % Prepare label locations (准备标签位置)
            if ischar(obj.LabelLocation)
                tLabelLocation = repmat({obj.LabelLocation}, 1, obj.BN);
            else
                tLabelLocation = obj.LabelLocation;
            end

            % Draw node label (绘制节点标签)
            switch tLabelLocation{n}
                case 'right'
                    obj.LabelHdl(n) = text(obj.ax, obj.LayerPos(n, 2), mean(obj.LayerPos(n, [3, 4])), ...
                        [' ', obj.NodeList{n}, ' '], 'FontSize', 15, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'left');
                case 'left'
                    obj.LabelHdl(n) = text(obj.ax, obj.LayerPos(n, 1), mean(obj.LayerPos(n, [3, 4])), ...
                        [' ', obj.NodeList{n}, ' '], 'FontSize', 15, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'right');
                case 'top'
                    obj.LabelHdl(n) = text(obj.ax, mean(obj.LayerPos(n, [1, 2])), obj.LayerPos(n, 3), ...
                        [' ', obj.NodeList{n}, ' '], 'FontSize', 15, 'FontName', 'Times New Roman', ...
                        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
                case 'center'
                    obj.LabelHdl(n) = text(obj.ax, mean(obj.LayerPos(n, [1, 2])), mean(obj.LayerPos(n, [3, 4])), ...
                        [' ', obj.NodeList{n}, ' '], 'FontSize', 15, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'center');
                case 'bottom'
                    obj.LabelHdl(n) = text(obj.ax, mean(obj.LayerPos(n, [1, 2])), obj.LayerPos(n, 4), ...
                        [' ', obj.NodeList{n}, ' '], 'FontSize', 15, 'FontName', 'Times New Roman', ...
                        'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
            end
        end


% =========================================================================
% Internal computation methods (内部计算方法)
% =========================================================================
        function getAdjMat(obj)
            if isempty(obj.AdjMat)
                obj.AdjMat = zeros(obj.BN, obj.BN);
                for i = 1:length(obj.Source)
                    obj.SourceInd(i) = find(strcmp(obj.Source{i}, obj.NodeList));
                    obj.TargetInd(i) = find(strcmp(obj.Target{i}, obj.NodeList));
                    obj.AdjMat(obj.SourceInd(i), obj.TargetInd(i)) = obj.Value{i};
                end
            end
        end
        
        function getLayer(obj)
            if strcmp(obj.LayerOrder, 'normal')
                obj.Layer = zeros(obj.BN, 1);
                obj.Layer(sum(obj.BoolMat, 1) == 0) = 1;
                startMat = diag(obj.Layer);
                for i = 1:(obj.BN - 1)
                    tLayer = (sum(startMat * obj.BoolMat^i, 1) > 0) .* (i + 1);
                    obj.Layer = max([obj.Layer, tLayer'], [], 2);
                end
            else
                obj.Layer = zeros(obj.BN, 1);
                obj.Layer(sum(obj.BoolMat, 2) == 0) = -1;
                startMat = diag(obj.Layer);
                for i = 1:(obj.BN - 1)
                    tLayer = (sum(startMat * (obj.BoolMat.')^i, 1) < 0) .* (-i - 1);
                    obj.Layer = min([obj.Layer, tLayer'], [], 2);
                end
                obj.Layer = obj.Layer - min(obj.Layer) + 1;
            end
        end
        
        function getLayerPos(obj)
            obj.Layer = obj.Layer(:);
            obj.LN = max(obj.Layer);
            obj.TotalLen = max([sum(obj.AdjMat, 1).', sum(obj.AdjMat, 2)], [], 2);
            obj.TotalLen(obj.TotalLen == 0) = mean(obj.TotalLen) / 2;
            obj.SepLen = max(obj.TotalLen) .* obj.Sep;
            obj.LayerPos = zeros(obj.BN, 4);
            
            for i = 1:obj.LN
                tBlockInd = find(obj.Layer == i);
                tBlockLen = [0; cumsum(obj.TotalLen(tBlockInd))];
                sepVal = obj.SepLen(min(i, length(obj.Sep)));
                tY1 = tBlockLen(1:end-1) + (0:length(tBlockInd)-1).' .* sepVal;
                tY2 = tBlockLen(2:end)   + (0:length(tBlockInd)-1).' .* sepVal;
                obj.LayerPos(tBlockInd, 3) = tY1;
                obj.LayerPos(tBlockInd, 4) = tY2;
            end
            
            obj.LayerPos(:, 1) = obj.Layer;
            obj.LayerPos(:, 2) = obj.Layer + obj.BlockScale;
            
            % Adjust Y-coordinates based on alignment (根据对齐方式调整)
            tMinY = min(obj.LayerPos(:, 3));
            tMaxY = max(obj.LayerPos(:, 4));
            for i = 1:obj.LN
                tBlockInd = find(obj.Layer == i);
                tBlockPos3 = obj.LayerPos(tBlockInd, 3);
                tBlockPos4 = obj.LayerPos(tBlockInd, 4);
                switch obj.Align
                    case 'up'
                        % No adjustment (无需调整)
                    case 'down'
                        obj.LayerPos(tBlockInd, 3) = obj.LayerPos(tBlockInd, 3) + tMaxY - max(tBlockPos4);
                        obj.LayerPos(tBlockInd, 4) = obj.LayerPos(tBlockInd, 4) + tMaxY - max(tBlockPos4);
                    case 'center'
                        shift = min(tBlockPos3)/2 - max(tBlockPos4)/2 + tMinY/2 - tMaxY/2;
                        obj.LayerPos(tBlockInd, 3) = obj.LayerPos(tBlockInd, 3) + shift;
                        obj.LayerPos(tBlockInd, 4) = obj.LayerPos(tBlockInd, 4) + shift;
                end
            end
        end


% =========================================================================
% Node movement methods (节点移动方法)
% =========================================================================
        function moveBlock(obj, n)
            tLayerPos = obj.MovePos + obj.LayerPos;
            set(obj.BlockHdl(n), 'XData', tLayerPos(n, [1, 2, 2, 1]));
            set(obj.BlockHdl(n), 'YData', tLayerPos(n, [3, 3, 4, 4]));
            
            if ischar(obj.LabelLocation)
                tLabelLocation = repmat({obj.LabelLocation}, 1, obj.BN);
            else
                tLabelLocation = obj.LabelLocation;
            end
            
            switch tLabelLocation{n}
                case 'right'
                    set(obj.LabelHdl(n), 'Position', [tLayerPos(n, 2), mean(tLayerPos(n, [3, 4]))]);
                case 'left'
                    set(obj.LabelHdl(n), 'Position', [tLayerPos(n, 1), mean(tLayerPos(n, [3, 4]))]);
                case 'top'
                    set(obj.LabelHdl(n), 'Position', [mean(tLayerPos(n, [1, 2])), tLayerPos(n, 3)]);
                case 'center'
                    set(obj.LabelHdl(n), 'Position', [mean(tLayerPos(n, [1, 2])), mean(tLayerPos(n, [3, 4]))]);
                case 'bottom'
                    set(obj.LabelHdl(n), 'Position', [mean(tLayerPos(n, [1, 2])), tLayerPos(n, 4)]);
            end
            
            for i = 1:obj.VN
                tSource = obj.SourceInd(i);
                tTarget = obj.TargetInd(i);
                if tSource == n || tTarget == n
                    tS1 = sum(obj.AdjMat(tSource, 1:(tTarget - 1))) + tLayerPos(tSource, 3);
                    tS2 = sum(obj.AdjMat(tSource, 1:tTarget))        + tLayerPos(tSource, 3);
                    tT1 = sum(obj.AdjMat(1:(tSource - 1), tTarget))  + tLayerPos(tTarget, 3);
                    tT2 = sum(obj.AdjMat(1:tSource, tTarget))        + tLayerPos(tTarget, 3);
                    
                    if isempty(tS1), tS1 = 0; end
                    if isempty(tT1), tT1 = 0; end
                    
                    tX = [tLayerPos(tSource, 1), tLayerPos(tSource, 2), ...
                          tLayerPos(tTarget, 1), tLayerPos(tTarget, 2)];
                    qX = linspace(tLayerPos(tSource, 1), tLayerPos(tTarget, 2), 200);
                    qT = linspace(0, 1, 50);
                    
                    qY1 = interp1(tX, [tS1, tS1, tT1, tT1], qX, 'pchip');
                    qY2 = interp1(tX, [tS2, tS2, tT2, tT2], qX, 'pchip');
                    YY = qY1 .* (qT' .* 0 + 1) + (qY2 - qY1) .* (qT');
                    
                    set(obj.LinkHdl(i), 'YData', YY, 'XData', qX);
                    
                    switch obj.ValueLabelLocation
                        case 'left'
                            set(obj.ValueLabelHdl(i), 'Position', [tLayerPos(tSource, 2), tS1/2 + tS2/2]);
                        case 'right'
                            set(obj.ValueLabelHdl(i), 'Position', [tLayerPos(tTarget, 1), tT1/2 + tT2/2]);
                        case 'center'
                            set(obj.ValueLabelHdl(i), 'Position', [tLayerPos(tSource, 2)/2 + tLayerPos(tTarget, 1)/2, ...
                                tS1/4 + tS2/4 + tT1/4 + tT2/4]);
                        case 'none'
                            set(obj.ValueLabelHdl(i), 'Position', [tLayerPos(tSource, 2), tS1/2 + tS2/2]);
                    end
                end
            end
        end
        
        function moveBlockX(obj, n, dx)
            % moveBlockX Move node horizontally (水平移动节点)
            %   dx: displacement in X direction (X方向位移量)
            obj.MovePos(n, [1, 2]) = obj.MovePos(n, [1, 2]) + dx;
            obj.moveBlock(n)
        end
        
        function moveBlockY(obj, n, dy)
            % moveBlockY Move node vertically (垂直移动节点)
            %   dy: displacement in Y direction (Y方向位移量)
            obj.MovePos(n, [3, 4]) = obj.MovePos(n, [3, 4]) - dy;
            obj.moveBlock(n)
        end
        
        function onLinkClick(obj, src, event)
            % onLinkClick Callback for link click interaction (连接点击回调)
            %   Left-click: show data tip (左键显示数据提示)
            %   Right-click: hide highlight (右键隐藏高亮)
            if ~verLessThan('matlab', '9.7')
                if event.Button == 1
                    src.FaceAlpha = obj.dataTipFormat{1};
                    datatip(src, event.IntersectionPoint(1), event.IntersectionPoint(2));
                    n = src.UserData;
                    
                    src.DataTipTemplate.DataTipRows(1) = ...
                        dataTipTextRow(obj.dataTipFormat{2}, repmat(obj.NodeList(obj.SourceInd(n)), ...
                        length(src.XData), length(src.YData)));
                    src.DataTipTemplate.DataTipRows(2) = ...
                        dataTipTextRow(obj.dataTipFormat{3}, repmat(obj.NodeList(obj.TargetInd(n)), ...
                        length(src.XData), length(src.YData)));
                    src.DataTipTemplate.DataTipRows(3) = ...
                        dataTipTextRow(obj.dataTipFormat{4}, repmat(obj.AdjMat(obj.SourceInd(n), obj.TargetInd(n)), ...
                        [length(src.XData), length(src.YData)]), obj.dataTipFormat{5});
                else
                    src.FaceAlpha = 0.3;
                end
            end
        end
        
        function setLabelLocation(obj, layer, location)
            % setLabelLocation Set label position for nodes in a specific layer
            %   设置指定层中节点的标签位置
            %   layer: layer index (层级索引)
            %   location: 'left'/'right'/'top'/'center'/'bottom'
            if ischar(obj.LabelLocation)
                obj.LabelLocation = repmat({obj.LabelLocation}, 1, obj.BN);
            end
            tLayerPos = obj.MovePos + obj.LayerPos;
            
            for n = find(obj.Layer == layer).'
                obj.LabelLocation{n} = location;
                switch obj.LabelLocation{n}
                    case 'right'
                        set(obj.LabelHdl(n), 'Position', [tLayerPos(n, 2), mean(tLayerPos(n, [3, 4]))], ...
                            'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');
                    case 'left'
                        set(obj.LabelHdl(n), 'Position', [tLayerPos(n, 1), mean(tLayerPos(n, [3, 4]))], ...
                            'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');
                    case 'top'
                        set(obj.LabelHdl(n), 'Position', [mean(tLayerPos(n, [1, 2])), tLayerPos(n, 3)], ...
                            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
                    case 'center'
                        set(obj.LabelHdl(n), 'Position', [mean(tLayerPos(n, [1, 2])), mean(tLayerPos(n, [3, 4]))], ...
                            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
                    case 'bottom'
                        set(obj.LabelHdl(n), 'Position', [mean(tLayerPos(n, [1, 2])), tLayerPos(n, 4)], ...
                            'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
                end
            end
        end
    end

% Copyright (c) 2023-2026, Zhaoxu Liu / slandarer
% =========================================================================
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer
% -------------------------------------------------------------------------
end