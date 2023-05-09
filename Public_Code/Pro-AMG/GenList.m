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
% 
% mapList(2,:) = {0,1,2,3,1,2,3,3,3};
% 
i1 = 0;
index = 0;
for i2 = 0:1
    for i3 = [0 2]
        for i4 = 0:3
            for i5 = 1
                for i6 = 2
                    for i7 = 1:3
                        for i8 = 1:3
                            for i9 = 1:3

                                childin2 = cell(1,9);
                                childin2(1,1:9) = {i1,i2,i3,i4,i5,i6,i7,i8,i9};
                                
%                                 if isequal(childin,childin2)
%                                     childin
%                                 end
                                
                                [flag,testout] = checkValid(childin2,locCode); %�Ķ��Ƿ����
                                if flag == 0
                                    continue
                                end
                                index = index + 1;
                                mapList(index,1:9) = childin2;

                            end
                        end
                    end
                end
            end
        end
    end
end
mapList = mapList(1:index,:);

end