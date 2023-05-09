%M����Ϣ���У�Cover���������У�ȡֵ0��B-1��px��Cover��pmf
function [Final_Stego,dist,MLen,Last_OH,Qxy]=OPTM(Cover,T,EmRate)
% clc;clear;
Qxy = [];
dist = 0;
r = 0;
MLen = 0;
Last_OH = 0;
%Cover
C_Len=floor(length(Cover)/2)*2;
B_Coef=15;%���ƶγ�������
% T=6;%ֻȡ[-T��T]֮���ֵ��



%����codetable and decodetable
CodeTable=zeros(2*T+2,2*T+2); %�˴��޸�Ϊ2(T+1), T = 1ʱ����-2��-1,0,1
DecodeTable=zeros((2*T+2)^2,2);
for i=-T-1:T  %�˴����Ըĳ�-T-1:T
    for j=-T-1:T
        a1=i+T+1; %��ȡֵ��0��ʼ
        a2=j+T+1;
        CodeTable(a1+1,a2+1)=a1*(2*T+2)+a2;
    end
end

for i=0:(2*T+2)^2-1
    a2=mod(i,2*T+2);
    a1=(i-a2)/(2*T+2);
    DecodeTable(i+1,1)=a1-T-1;
    DecodeTable(i+1,2)=a2-T-1;
end


Ind=zeros(C_Len/2,1);
pfor=1;

for i=1:2:C_Len-1
    if((abs(2*Cover(i)+1)-1)/2<=T && (abs(2*Cover(i+1)+1)-1)/2<=T) % �˴��ĳ�(abs(2*Cover(i)+1)-1)/2, ʹ��a��-a-1�����a
        Ind(pfor)=i;
        Final_Cover(2*pfor-1)=Cover(i);
        Final_Cover(2*pfor)=Cover(i+1);
        cover2(pfor)=CodeTable(Cover(i)+T+2,Cover(i+1)+T+2);  
         
        pfor=pfor+1;
    end
end
Final_Stego=Final_Cover;%Final_Cover��ģ�������
N=pfor-1; %N �Ƕ�ά���峤��
B=(2*T+2)^2;


for i=0:B-1
    st=(cover2==i);
    H2(i+1)=sum(st);
end
px=H2/N;
px=px';
%С����У��
ZeroPos=(px<=eps);
ZeroNum=size(ZeroPos,2);
px(ZeroPos)=10*ones(ZeroNum,1)/N;
px(ZeroPos)=0.0000001;
px=px/sum(px);

P_S(1)=0;
for i=2:B+1
    P_S(i)=P_S(i-1)+px(i-1);  % �ƺ����ۻ�����
end

%Ԥ��һ�δ���overhead
L_px=compressFun(H2);%������ֲ���Ҫ�ı�����
ParaL=L_px+B*B_Coef;% B*B_Coef��һ�εĳ��ȣ�Ԥ����һ�Σ���LSB�滻Ƕ�����ڶ��ε�Overhead
CoverL=N;%���峤��
cover2=cover2';
Stego=cover2;
%cover3=cover2(ParaL+1:N);


% distortion matrix example: d(x,y)=(x-y)^2
Dxy=zeros(B,B);
for xx=0:B-1
    for yy=0:B-1
        a1=DecodeTable(xx+1,1);
        a2=DecodeTable(xx+1,2);
        b1=DecodeTable(yy+1,1);
        b2=DecodeTable(yy+1,2);
        Dxy(xx+1,yy+1)=(a1-b1)^2+(a2-b2)^2; %%%��δ����������
%         if (a1-b1)^2 > 1 || (a2-b2)^2 > 1 %����޸���Ϊ1
%             Dxy(xx+1,yy+1) = 99999;
%         end

if a1 == 0 && a2 == 2 &&  b1 == -1 && b2 == 2    
    Dxy(xx+1,yy+1) = 9999999;    
end

if a1 == 2 && a2 == 0 &&  b1 == 2 && b2 == -1  
    Dxy(xx+1,yy+1) = 9999999;    
end
        
%         if a1 >= 0 && a2 >= 0
%             if b1 >= 0 && b2 >= 0
%                 continue
%             else
%                Dxy(xx+1,yy+1) = 6;
%             end
%         end
%         
%         if a1 >= 0 && a2 <= -1
%             if b1 >= 0 && b2 <= -1
%                 continue
%             else
%                Dxy(xx+1,yy+1) = 6;
%             end
%         end
%         
%         if a1 <= -1 && a2 >= 0
%             if b1 <= -1 && b2 >= 0
%                 continue
%             else
%                Dxy(xx+1,yy+1) = 6;
%             end
%         end
%         
%         if a1 <= -1 && a2 <= -1
%             if b1 <= -1 && b2 <= -1
%                 continue
%             else
%                Dxy(xx+1,yy+1) = 6;
%             end
%         end
        
    end
end

H_X=h(px); %������
r=EmRate;
flag=1;
j=1;
t=clock;
while (flag&&j<2)
    [py]=max_entropy_br(px,Dxy,0);
    r_max=h(py)-H_X;
    if(r>r_max)
        disp('too large embedding rate');
    end
    flag=(r<=r_max);
    if(flag)
       %[py]=Esti_rate(px,Dxy,r,r_max,H_X);
       Hy=(r+H_X)*log(2);%��Ƕ���ʶ�Ӧ��H(Y)��������Ȼ������ʾ
       py=min_distortion_br(px,Dxy,Hy);
       [P_sy,Qxy,Qyx]=AnyDistortion(px,py,Dxy); %%P_xy�����Ϸֲ���Qxy��x��>y��ת�Ƹ��ʣ�Qyx��y��>x��ת�Ƹ��ʣ�
%        ZeroPos=(Qyx<=0.0001);
%        ZeroNum=size(ZeroPos,2);
%        Qyx(ZeroPos)=0;
       %���۽�
       D(j)=0;
       for s=0:(B-1)
            for y=0:(B-1)
                D(j)=D(j)+P_sy(s+1,y+1)*Dxy(s+1,y+1);
            end
       end
       R(j)=h(py)-H_X;

    
       %����
       [MLen,modi_cover,Last_OH]=recursive_construction(px,py,Qxy,Qyx,cover2,H2,B,B_Coef);%recursive_construction_new(cover2,B,a);
       OverHead=Last_OH+L_px;%�洢����ֲ��ͻָ����һ����Ҫ�ı�����
       %MLen=MLen-OverHead;
       MLen=MLen-Last_OH;
       Stego=modi_cover;
       if sum(Stego < 0) >=1
           break
       end
%        temp=(rand(OverHead,1)<0.5);
%        Stego(1:OverHead)=2*floor(Stego(1:OverHead)/2)+temp;%ģ��LSB�滻Ƕ��OverHead
%        for k=1:OverHead
%            if(Stego(k)>(2*T+1)^2-1)
%                Stego(k)=(2*T+1)^2-1;
%            end
%        end
       rate(j)=MLen/(N*2); %�˴�Ƕ��������Ե�ԣ�����2�ĳɶ�ÿ����
       for i=1:N
           Final_Stego(2*i-1)=DecodeTable(Stego(i)+1,1);
           Final_Stego(2*i)=DecodeTable(Stego(i)+1,2);
       end
       DI=(Final_Stego-Final_Cover).^2;
       dist(j)=sum(DI); %�˴�ƽ��ʧ������Ե�ԣ�����2�ĳɶ�ÿ����
%        r=r+5000/512^2;
   end
   j=j+1;
end
% rate(1)=0;
% dist(1)=0;
% e=etime(clock,t)



% FG=figure('Pos',[150 100 530 460]);
% AX=axes('Pos',[0.12 0.12 0.83 0.85]);
% L1=plot(D,R,'-^',dist,rate,'--o');
% XL=xlabel('Distortion'); YL=ylabel('Embedding rate');
% LG=legend('Upper bound','Proposed code',4);
% set(AX,'FontSize',[12]);
% set(XL,'FontSize',[12]);
% set(YL,'FontSize',[12]);
% set(LG,'FontSize',[12]);
% grid;
% set(L1(1),'Color',[0 0 0],'LineWidth',[1.3]);
% set(L1(2),'Color',[0 0 0],'MarkerSize',[10],'LineWidth',[1.3]);

% dist = (dist+dist2(1:length(dist2)))/2;
% rate = (rate+rate2(1:length(dist2)))/2;



end      