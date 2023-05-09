%%P_S ����pmf��a��=1��ʵ����e������ֵ
%function [X]=StegoPmf(P_S,a,e)
clc;clear;
P_S=[0,0.8,0.95,1];
px=[0.8,0.15,0.05];
a=2.15;
e=0.00001;

B=size(P_S,2)-1;
X=zeros(1,B+1);
for y=-1:(B-1)
    X(y+2)=(y+1)/B; % X(y+2)�����X_y
end
%X=[0,0.2,0.35,1];%ȡ0.95��0.65��������ͬ��ֵ
X_new=X;
Var=0;
j=1;
tap=0;
while(tap==0)%j<1000 ��ֹ�����������������ѭ��
    for y=0:(B-2)
        s=0;
        flag=0;
        while (s<=(B-1))&&(flag==0)
            inter=(X(y+3)-P_S(s+2))/(P_S(s+2)-X(y+1)+eps);
            L=a^((s-y)^2-(s-y-1)^2);
            U=a^((s+1-y)^2-(s-y)^2);
            if (X(y+2)>P_S(s+1))&&(X(y+2)<P_S(s+2))
                flag=1;
            elseif (inter>=L)&&(inter<=U)
                flag=2;
            end
            s=s+1;
        end

        if (flag==1)
            X_new(y+2)=(X(y+3)-X(y+1))/(1+a^((s-1-y)^2-(s-1-y-1)^2))+X(y+1); 
        elseif (flag==2)
            X_new(y+2)=P_S(s-1+2);        
        end
        Var=max(Var,abs(X_new(y+2)-X(y+2)));
        X(y+2)=X_new(y+2);
    end
    
     for y=(B-2):0
        s=0;
        flag=0;
        while (s<=(B-1))&&(flag==0)
            inter=(X(y+3)-P_S(s+2))/(P_S(s+2)-X(y+1)+eps);
            L=a^((s-y)^2-(s-y-1)^2);
            U=a^((s+1-y)^2-(s-y)^2);
            if (X(y+2)>P_S(s+1))&&(X(y+2)<P_S(s+2))
                flag=1;
            elseif (inter>=L)&&(inter<=U) 
                flag=2;
            end
            s=s+1;
        end

        if (flag==1)
           X_new(y+2)=(X(y+3)-X(y+1))/(1+a^((s-1-y)^2-(s-1-y-1)^2))+X(y+1);  
        elseif (flag==2)
            X_new(y+2)=P_S(s-1+2);        
        end
        Var=max(Var,abs(X_new(y+2)-X(y+2)));
        X(y+2)=X_new(y+2);
    end
      
    if(Var>e)
        Var=0;
    else
        tap=1;
    end
    j=j+1
end


for i=0:(B-1)
    py(i+1)=X(i+2)-X(i+1);
end
%end



        
        
    
           
        

    