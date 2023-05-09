function  [MLen,Stego,Last_OH]=recursive_construction(px,py,Qxy,Qyx,cover2,H2,B,B_Coef)

em=0;
oh=0;
N=size(cover2,1);
Cover=cover2;
Mess=rand(3*N,1)<0.5; %the message
Mess=double(Mess);
for x=0:B-1
    em=em+px(x+1)*h(Qxy(x+1,:));
    oh=oh+py(x+1)*h(Qyx(x+1,:));
end
em=em
oh=oh

max_px=max(px);
j=find(px==max_px);
max_px=max_px+px(j-1);%���ʹδ�Ƶ��֮��

%TH=H2-round(N*py')

%%�������һ��������
n=B*B_Coef;%�γ�

Num_Block=floor(N/n);%����


%%embedding process
Stego=Cover;
Pre_Mess=[];
L_PreMess=0;
Mess_Pos=0;
for i=1:Num_Block
    C_Block=Cover((i-1)*n+1:i*n);
    M_Block=Pre_Mess;%Pre_MessΪ�ָ���һ����Ҫ����Ϣ
    M_Block(L_PreMess+1:2*n)=Mess(Mess_Pos+1:Mess_Pos+2*n-L_PreMess);
    [MLen,S_Block]=Embed(C_Block,M_Block,Qxy);
    MLen=MLen-L_PreMess;
    [L_PreMess,Pre_Mess]=Comp_Oh(S_Block,C_Block,Qyx);
    Mess_Pos=Mess_Pos+MLen;
    Stego((i-1)*n+1:i*n)=S_Block;
    %flag=i
end

MLen=Mess_Pos;
Last_OH=L_PreMess
end













