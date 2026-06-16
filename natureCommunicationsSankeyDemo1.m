%% Reproduction of a Nature Communications figure example
% -----------------------------------------------------+
% @author  | slandarer                                 |
% 公众号   | slandarer随笔                              |
% 知乎     | slandarer                                 |
% -----------------------------------------------------+
% 复刻自   | www.nature.com/articles/s41467-025-63215-6 |
% -----------------------------------------------------+

Data = readcell('natureCommunications1.xlsx');
Data(1,:) = [];

figure('Units','normalized','Position',[.2,.2,.52,.7])
axes('Parent',gcf, 'Position',[.2,.1,.6,.8])

SK=SSankey(Data(:,1),Data(:,2),Data(:,3));

SK.ColorList=[86,112,156;151,181,138;227,206,139;216,139,131;204,204,204;
    172,41,52;224,189,133;106,188,161;79,145,187;180,98,96;226,210,151;
    128,158,173;75,106,150;192,198,132;224,190,133;171,213,165;205,193,174;
    110,187,161;82,146,186;192,198,130;156,189,141;179,179,181;223,153,124;182,167,131]./255;

% 修改链接颜色渲染方式(Set link color rendering method)
SK.RenderingMethod='left';

% 修改对齐方式(Set alignment)
SK.Align='up';
% 设置缝隙占比(Separation distance proportion)
SK.Sep=.2;

SK.draw()

for i=1:length(SK.LinkHdl)
    SK.setLink(i,'FaceAlpha',.7)
end
for i=1:length(SK.LabelHdl)
    SK.setLabel(i,'FontName','Arial')
end
SK.setLabelLocation(3,'right')