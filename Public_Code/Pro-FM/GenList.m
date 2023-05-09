function [mapList] = GenList
mapList = cell(4096,9);

locCode = [10 12 14 16;
    5  7  9  15;
    2  4  8  13;
    1  3  6  11];  %��һ���ޱ�ţ����½�Ϊ��0,0��
locCode = rot90(locCode,3);  %˳ʱ����ת90��
%0:�õ�����Ϊx,y;
%1:���Ϊx,y-1;
%2:x-1,y;
%3:x-1,y-1

childin = cell(1,9);
childin(1,1:9) = {0, 1, 2, 3, 1, 2, 3, 3, 3}; % ��άӳ������������ʽ Sachnev
childin(1,1:9) = {0, 1, 2, 0, 1, 2, 3, 3, 3}; %pairwise PEE ӳ��
index = 1;
mapList(index,:) = childin;
mapList = mapList(1:index,:);
 

end