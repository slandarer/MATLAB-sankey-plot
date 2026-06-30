%% sankey demo1 : Basic usage

figure('Name','sankey demo1','Units','normalized','Position',[.05,.2,.5,.56])

links={'a1','A',1.2;'a2','A',1;'a1','B',.6;'a3','A',1; 'a3','C',0.5;
       'b1','B',.4; 'b2','B',1;'b3','B',1; 'c1','C',1;
       'c2','C',1;  'c3','C',1;'A','AA',2; 'A','BB',1.2;
       'B','BB',1.5; 'B','AA',1.5; 'C','BB',2.3; 'C','AA',1.5};

% Create a Sankey diagram object (创建桑基图对象)
SK=SSankey(links(:,1),links(:,2),links(:,3));

% Set link color rendering method (修改链接颜色渲染方式)
% 'left'/'right'/'interp'(default)/'map'/'simple'
SK.RenderingMethod='interp';  

% Set alignment (修改对齐方式)
% 'up'/'down'/'center'(default)/'justify'
SK.Align='up';

% Set text location (修改文本位置)
% 'left'(default)/'right'/'top'/'center'/'bottom'
SK.LabelLocation='top';

% Set separation distance proportion (设置缝隙占比)
SK.Sep=.2;

SK.ValueLabelLocation = 'left';

% Start drawing (开始绘图)
SK.draw()


SK.dataTipFormat = {1, 'Source:', 'Target:', 'Value:', 'auto'};

% Set text location for the first layer to the left (将第一层标签调整到左侧)
SK.setLabelLocation(1, 'left')



