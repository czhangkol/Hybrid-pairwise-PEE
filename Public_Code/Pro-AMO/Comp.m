%ѹ��Ƶ����Ϣx��������������У���¼����λ�ã�Ȼ�󶼲�����к�λ�����зֱ�ѹ����
function [y]=Comp(x)
% clc;clear;
% load Cover;
% N=size(Cover,1);
% B=max(Cover)+1;
% HIST=hist(Cover,B);
% x=HIST;
% 

B=size(x,2);
Max_Val=max(x);
j=find(x==Max_Val);
Diff(1)=x(1);
for i=2:j
    Diff(i)=x(i)-x(i-1);
end
for i=j+1:B
    Diff(i)=x(i-1)-x(i);
end
    
%%ѹ��λ������
%Diff=x;
Pos=(Diff<0);
Pos=double(Pos);
p1=sum(Pos)/B;
Frequency=ones(B,2);
Frequency(:,1)=(1-p1)*Frequency(:,1);
Frequency(:,2)=p1*Frequency(:,2);
Pos=Pos+1;
Pos=reshape(Pos,B,1);
[Comp1]=arith_encode(Pos,Frequency);
oh1=size(Comp1,1);

%%ѹ���������
Diff=abs(Diff);
temp=max(Diff);
temp=log2(temp);
Digit=ceil(temp);
BiSeq=de2bi(Diff,Digit);
BiSeq=reshape(BiSeq,B*Digit,1);
q1=sum(BiSeq)/(B*Digit);
Frequency=ones(B*Digit,2);
Frequency(:,1)=(1-q1)*Frequency(:,1);
Frequency(:,2)=q1*Frequency(:,2);
BiSeq=BiSeq+1;
[Comp2]=arith_encode(BiSeq,Frequency);
oh2=size(Comp2,1);
y=oh1+oh2+ceil(log2(B)); %ceil(log2(B))�洢���ֵ��λ��
%end


