%----------------------����������Piezo TV-RF  Thermal WiFi-home----------------------% 
%��ȡpower trace�ļ�

Power_harvest1=xlsread('E:\matlab\ICCAD\energy\Piezo.xlsx');% power trace read
Power_harvest=Power_harvest1(:,1);%ע��power trace�ļ��ɼ����������п��ܲ�ͬ

% Power_harvest1=xlsread('E:\matlab\ICCAD\energy\TV-RF.xlsx');
% Power_harvest=Power_harvest1(1:900,1);%ע��power trace�ļ��ɼ����������п��ܲ�ͬ

% Power_harvest1=xlsread('E:\matlab\ICCAD\energy\Thermal.xlsx');
% Power_harvest=Power_harvest1(:,1);%ע��power trace�ļ��ɼ����������п��ܲ�ͬ

%Power_harvest1=xlsread('E:\matlab\ICCAD\energy\WiFi-home.xlsx');
%Power_harvest=Power_harvest1(1:100,4);%ע��power trace�ļ��ɼ����������п��ܲ�ͬ

%----��ͬ�����Ĳ������ڲ�һ������Ҫ�ֶ��޸�----%
cyc_time=0.0001; % piezo��������
% cyc_time=0.1; % TV-RF��������
%cyc_time=0.2; % Thermal��������
%cyc_time=0.2; % WiFi-home��������
%----��ͬ�����Ĳ������ڲ�һ������Ҫ�ֶ��޸�----%

%----------------------end ����������Piezo TV-RF  Thermal WiFi-home------------------------% 

%------------------------------2������ ÿ���tile size����ز���---------------------------------%

%----------------------------FRÿ���tile size�ļ���ȡ---------------------------%
%---��������������������ˮƽ��һ�£����ͬһ�����Ӧÿ���������õ�tile size��ͬ��---%

% Solution=xlsread('E:\matlab\ICCAD\networks\fr-piezo-max-2.xlsx');
% % Solution=xlsread('E:\matlab\ICCAD\networks\fr-TVRF-max.xlsx');
% % Solution=xlsread('E:\matlab\ICCAD\networks\fr-thermal-max.xlsx');
% % Solution=xlsread('E:\matlab\ICCAD\networks\fr-WifiHome.xlsx');
% % -----------------------------end FRÿ���tile size�ļ���ȡ-----------------------%
% 
% % Power_Level=Solution(2:11,7);
% 
% %--------------------------FR����������------------------------%
% FR_Conv1=[4,28,28];
% FR_Conv2=[16,10,10];
% 
% %tile sizeΪ25x1x1ʱ����һ��ִ�еĴ���(��С����size ʱ������ 4cycles)
% layer1_op_times=FR_Conv1(1)*FR_Conv1(2)*FR_Conv1(3);
% %tile sizeΪ64x1x1ʱ���ڶ���ִ�еĴ���(��С����size ʱ������ 12cycles)
% layer2_op_times=FR_Conv2(1)*FR_Conv2(2)*FR_Conv2(3);
% 
% %FR-piezo��ȡÿһ���tile size����
% Solution_layer1=Solution(1:61,:);%��һ��tile size
% Solution_layer2=Solution(62:91,:);%�ڶ���tile size
% %FR-TVRF��ȡÿһ���tile size����
% % Solution_layer1=Solution(1:341,:);%��һ��tile size
% % Solution_layer2=Solution(342:471,:);%�ڶ���tile size
% %FR-thermal��ȡÿһ���tile size����
% % Solution_layer1=Solution(1:141,:);%��һ��tile size
% % Solution_layer2=Solution(142:201,:);%�ڶ���tile size
% %----------------------------end  FRÿ���tile size����ز���-------------------------------%

% Solution=xlsread('E:\matlab\ICCAD\networks\lenet-piezo-max-2.xlsx');
% % Solution=xlsread('E:\matlab\ICCAD\networks\lenet-TVRF-max.xlsx');
% %------------LeNet�������-------------%
% LeNet_Conv1=[6,28,28];
% LeNet_Conv2=[16,10,10];
% 
% %tile sizeΪ25x1x1ʱ����һ��ִ�еĴ���
% layer1_op_times=LeNet_Conv1(1)*LeNet_Conv1(2)*LeNet_Conv1(3);
% %tile sizeΪ150x1x1ʱ���ڶ���ִ�еĴ���
% layer2_op_times=LeNet_Conv2(1)*LeNet_Conv2(2)*LeNet_Conv2(3);
% 
% %LeNet-piezo��ȡÿһ���tile size����
% Solution_layer1=Solution(1:61,:);%��һ��tile size
% Solution_layer2=Solution(62:81,:);%�ڶ���tile size
% %LeNet-TVRF��ȡÿһ���tile size����
% % Solution_layer1=Solution(1:381,:);%��һ��tile size
% % Solution_layer2=Solution(382:471,:);%�ڶ���tile size
% %LeNet-thermal��ȡÿһ���tile size����
% %Solution_layer1=Solution(1:15,:);%��һ��tile size
% %Solution_layer2=Solution(16:21,:);%�ڶ���tile size
% 
% %---------end LeNet�������-----------%
% 
%-------------------HG�������--------------------%
%HG
 Solution=xlsread('E:\matlab\ICCAD\networks\hg-piezo-max-2.xlsx');
%Solution=xlsread('E:\matlab\ICCAD\networks\lenet-TVRF-max.xlsx');
%------------HG�������-------------%
HG_Conv1=[6,24,24];
HG_Conv2=[12,8,8];

%tile sizeΪ25x1x1ʱ����һ��ִ�еĴ���
layer1_op_times=HG_Conv1(1)*HG_Conv1(2)*HG_Conv1(3);
%tile sizeΪ150x1x1ʱ���ڶ���ִ�еĴ���
layer2_op_times=HG_Conv2(1)*HG_Conv2(2)*HG_Conv2(3);
%LeNet-piezo��ȡÿһ���tile size����
Solution_layer1=Solution(1:71,:);%��һ��tile size
Solution_layer2=Solution(72:111,:);%�ڶ���tile size
% Solution_layer1=Solution(1:391,:);%��һ��tile size
% Solution_layer2=Solution(392:561,:);%�ڶ���tile size

%--------------end HG�������----------------%

%ÿһ��tile size�ĸ���
Size_Solution_layer1=size(Solution_layer1);
Size_Solution_layer2=size(Solution_layer2);

%�������
Solution_1=Solution(1,:);%�����ѹ
[m_ph,n_ph]=size(Power_harvest);
Energy_efficiency=zeros(m_ph,1); %��Ч
Throughput_efficiency=zeros(m_ph,1); %������
Energy_utilization=zeros(m_ph,1); %����������
Out=zeros(m_ph,4);

C=0.47; %����

Power_search_layer1=Solution_layer1(:,3);%��һ��tile size�Ĺ���
Power_search_layer2=Solution_layer2(:,3);%�ڶ���tile size�Ĺ���

%���size��λ��
[layer1_rmax,layer1_cmax]=size(Solution_layer1);%��һ��
[layer2_rmax,layer2_cmax]=size(Solution_layer2);%�ڶ���

%-----FR ��ѯ����ʶ�Ӧ����Сת��Ч�ʺ���С���ʶ�Ӧ�����ת��Ч��,���ڲ�ͬ���磬�ò�����Ҫ�ֶ��޸�-----%
%----------------------------------------�����ж���������Ĳ���---------------------------%
Psl_layer1=Solution_layer1(2,3)/(0.01*max(Solution_layer1(2,8:+2:57)));
Psl_layer2=Solution_layer2(1,3)/(0.01*max(Solution_layer2(1,8:+2:57)));
Psl=max(Psl_layer1,Psl_layer2); %min ��Сsize��Ӧ��õ�ת��Ч�ʵĹ���

Pll_layer1=Solution_layer1(layer1_rmax,3)/(0.01*min(Solution_layer1(layer1_rmax,8:+2:57)));
Pll_layer2=Solution_layer2(layer2_rmax,3)/(0.01*min(Solution_layer2(layer2_rmax,8:+2:57)));
Pll=max(Pll_layer1,Pll_layer2); %max ���size��Ӧ����ת��Ч�ʵĹ���

%----------------------------------------�����ж���������Ĳ���---------------------------%

%ͳ�����н���ܺ�
All_Operand_sum=0;
E_use_sum=0;
E_collect_sum=0;

V=0;%���ݵ�ǰ��ѹ
Estore=0;%���ݴ洢��������ȫ��

%�����ж�ִ�е���һ��
layer1_count=0;
layer2_count=1;
count_layer_times=0;
%---------------------------����power trace�ļ� ִ��ģ�����-----------------------------%
for i=1:m_ph
    
    P_harvest=Power_harvest(i,1)*1e-6; % ��ǰcycle��Pload ��λW
    test_cnt=1;
    Cycle_cnt=0;
    Operand_sum=0;
    Energy_use=0;
    Energy_collect=0;
    V_present=0;
    V_down=0;
    V_up=0;
    %��Ъִ����Ҫ�Ĳ���
    Energy_collect_i=0;
    Energy_collect_i1=0;
    Operand_sum_i=0;
    Operand_sum_i1=0;
    Energy_use_i=0;
    Throughput_i=0;
    Energy_use_i1=0;
    Throughput_i1=0;
    %����ִ����Ҫ�Ĳ���
    Energy_collect_c=0;
    Operand_sum_c=0;
    Energy_use_c=0;
    Throughput_c=0;
    t=0;%���ʱ��
    t_count=0;%һ��cycle�ĳ�����
    time=0;%ִ��ʱ��
    working_cycle_time=0;
    P_layer1=0;
    P_layer2=0;
    t_onecycle=0;
    Energy_consume_layer1=0;
    Energy_consume_layer2=0;
    Max_Energy_consume=0;
    Energy_Effi_c=0;
    Energy_Effi_i=0;
    working_cycle_ops_c=0;
    
    %��ǰcycle �ܼ��ж�
    if P_harvest<=100*1e-6
        pl_present=1; 
        pl_ps_size1=2;
    elseif P_harvest<=200*1e-6
        pl_present=2;
        pl_ps_size1=3;
    elseif P_harvest<=300*1e-6
        pl_present=3;
        pl_ps_size1=4;
    elseif P_harvest<=400*1e-6
        pl_present=4; 
        pl_ps_size1=5;
    elseif P_harvest<=500*1e-6
        pl_present=5;
        pl_ps_size1=6;
    elseif P_harvest<=600*1e-6
        pl_present=6;
        pl_ps_size1=7;
    elseif P_harvest<=700*1e-6
        pl_present=7;  
        pl_ps_size1=8;
    elseif P_harvest<=800*1e-6
        pl_present=8;
        pl_ps_size1=9;
    elseif P_harvest<=900*1e-6
        pl_present=9; 
        pl_ps_size1=10;
    else
        pl_present=10;
        pl_ps_size1=11;
    end

%     %��ǰcycle �ܼ��ж� TVRF
%     if P_harvest<=2000*1e-6
%         pl_present=1; 
%         pl_ps_size1=2;
%     elseif P_harvest<=4000*1e-6
%         pl_present=2;
%         pl_ps_size1=3;
%     elseif P_harvest<=6000*1e-6
%         pl_present=3;
%         pl_ps_size1=4;
%     elseif P_harvest<=8000*1e-6
%         pl_present=4; 
%         pl_ps_size1=5;
%     elseif P_harvest<=10000*1e-6
%         pl_present=5;
%         pl_ps_size1=6;
%     elseif P_harvest<=12000*1e-6
%         pl_present=6;
%         pl_ps_size1=7;
%     elseif P_harvest<=14000*1e-6
%         pl_present=7;  
%         pl_ps_size1=8;
%     elseif P_harvest<=16000*1e-6
%         pl_present=8;
%         pl_ps_size1=9;
%     elseif P_harvest<=18000*1e-6
%         pl_present=9; 
%         pl_ps_size1=10;
%     else
%         pl_present=10;
%         pl_ps_size1=11;
%     end
% %��ǰcycle �ܼ��ж� Thermal
%     if P_harvest<=300*1e-6
%         pl_present=1; 
%         pl_ps_size1=2;
%     elseif P_harvest<=600*1e-6
%         pl_present=2;
%         pl_ps_size1=3;
%     elseif P_harvest<=900*1e-6
%         pl_present=3;
%         pl_ps_size1=4;
%     elseif P_harvest<=1200*1e-6
%         pl_present=4; 
%         pl_ps_size1=5;
%     elseif P_harvest<=1500*1e-6
%         pl_present=5;
%         pl_ps_size1=6;
%     elseif P_harvest<=1800*1e-6
%         pl_present=6;
%         pl_ps_size1=7;
%     elseif P_harvest<=2100*1e-6
%         pl_present=7;  
%         pl_ps_size1=8;
%     elseif P_harvest<=2400*1e-6
%         pl_present=8;
%         pl_ps_size1=9;
%     elseif P_harvest<=2700*1e-6
%         pl_present=9; 
%         pl_ps_size1=10;
%     else
%         pl_present=10;
%         pl_ps_size1=11;
%     end
    %------------------------- case 1 ���size ����ִ��-------------------------%
    if P_harvest >= Pll % 
        %[layer1_rmax,layer1_cmax]=size(Solution_layer1);%��һ�������к���
        %[layer2_rmax,layer2_cmax]=size(Solution_layer2);
        
        %Cycle_cnt_time=(layer1_op_times*(Solution_layer1(layer1_rmax,1)/4/(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6)))+...
        %(layer2_op_times*Solution_layer2(layer2_rmax,1)/4/(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6))))*20e-9;%ִ��һ����Ҫ��ʱ��
        %op_cycle=cyc_time/Cycle_cnt_time;%һ��power cycle����˳��ִ�еĴ���
        
        %��һ��+�ڶ�����󼤻���Ĳ�����
        %Operand_sum=(Solution_layer1(layer1_rmax,4)*Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6)...
        % +Solution_layer2(layer2_rmax,4)*Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6))*op_cycle;
         
        %time_layer1=layer1_op_times*Solution_layer1(layer1_rmax,1)/4/(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6))*20e-9;
        %time_layer2=layer2_op_times*Solution_layer2(layer2_rmax,1)/4/(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6))*20e-9;
        
        %ѡ�е�Tile size��ʱ������
        time_layer1_tile=Solution_layer1(layer1_rmax,1)/4*20e-9;
        time_layer2_tile=Solution_layer2(layer2_rmax,1)/4*20e-9;
        while cyc_time>t_onecycle
            %��һ��
            if layer1_count==0 %��һ��ִ������
                Operand_sum=Operand_sum+(Solution_layer1(layer1_rmax,4)*Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6));

                count_time=count_time+time_layer1_tile;
                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer1_tile)
                    Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
                else
                    Estore=Estore+P_harvest*time_layer1_tile;
                end
                t_onecycle=t_onecycle+time_layer1_tile;
                count_layer_times=count_layer_times+1*(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6));
                %�����ж�ִ�е�һ�㻹�ǵڶ���
                if  layer1_op_times<=count_layer_times
                    layer1_count=1;
                    layer2_count=0;
                    count_layer_times=0;
                end
            end
            %�ڶ���
            if layer2_count==0 %�ڶ���ִ������
                Operand_sum=Operand_sum+(Solution_layer2(layer2_rmax,4)*Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6));   
                count_time=count_time+time_layer2_tile;
                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer2_tile)
                    Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
                else
                    Estore=Estore+P_harvest*time_layer2_tile;
                end
                t_onecycle=t_onecycle+time_layer2_tile;
                count_layer_times=count_layer_times+1*(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6));
                %�����ж�ִ�е�һ�㻹�ǵڶ���
                if  layer2_op_times<=count_layer_times
                    layer1_count=0;
                    layer2_count=1;
                    count_layer_times=0;
                end
            end 
        end
        Energy_use=((Solution_layer1(layer1_rmax,3)+Solution_layer2(layer2_rmax,3))*cyc_time)/2;
        Energy_collect=P_harvest*cyc_time;
    %------------------------------ case 1 end --------------------------------%
        
%     %-------------------------case 2  ����ִ�л��Ъִ�� ѡ��������ִ�з�ʽ�ϸߵ�-----------------------------%
%     elseif P_harvest >= Psl % ��ţ���ϣ�ģ��
%         
%         %-------------------------case 2 �������е����size-------------------------%
%         %���ݹ���ѡ���������ִ�е�tile size
%         %P_layer1=find(Power_search_layer1<=(P_harvest*0.595382245764776));%��һ����Լ����
%         %P_layer2=find(Power_search_layer2<=(P_harvest*0.641726047596523));%�ڶ�����Լ����
%         
%         %------------��һ����Լ�������Tile size------------%
%         for m=Size_Solution_layer1(1,1):-1:2
%             Sizem_Effi=min(min(Solution_layer1(m,7:52)))*0.01;
%             if Power_search_layer1(m,1)/Sizem_Effi<P_harvest
%                 P_layer1=m;
%                 break;
%             end
%         end
%         %------------�ڶ�����Լ�������Tile size-------------%
%         for n=Size_Solution_layer2(1,1):-1:1
%             Sizen_Effi=min(min(Solution_layer2(n,7:52)))*0.01;
%             if Power_search_layer2(n,1)/Sizen_Effi<P_harvest
%                 P_layer2=n;
%                 break;
%             end
%         end
%         
%         %[P_layer1_r,P_layer1_c]=size(P_layer1);
%         %[P_layer2_r,P_layer2_c]=size(P_layer2);
% 
%         %--------------------------case 2 ��Ъִ��--------------------------%
%          %------���ݹ���ѡ�񲻿�������ִ�е�tile size-----------%
%          if P_layer1==0 || P_layer2==0
%              P_layer1=0;
%              P_layer2=0;
%          end
%          %case2 ��Ъִ�е�size
%          P_layer1i=zeros(Size_Solution_layer1(1,1)-P_layer1(1,1),1);
%          P_layer2i=zeros(Size_Solution_layer2(1,1)-P_layer2(1,1),1);
%          x=0;    
%          for m=P_layer1(1,1)+1:Size_Solution_layer1(1,1)
%             x=x+1;
%             P_layer1i(x,1)=P_layer1(1,1)+x;%��һ�㲻���Լ����
%          end
%           y=0;
%          for n=P_layer2(1,1)+1:Size_Solution_layer2(1,1)
%             y=y+1;
%             P_layer2i(y,1)=P_layer2(1,1)+y;%�ڶ��㲻���Լ����
%          end
%             
%         [P_layer1_ri,P_layer1_ci]=size(P_layer1i);
%         [P_layer2_ri,P_layer2_ci]=size(P_layer2i);
%         Solution_layer1i=Solution_layer1(P_layer1i,:);%��һ�㲻�ܼ��������size
%         Solution_layer2i=Solution_layer2(P_layer2i,:);%�ڶ��㲻�ܼ��������size
%         %------���ݹ���ѡ�񲻿�������ִ�е�tile size-----------%
%         
%         %[layer1_rmax,layer1_cmax]=size(Solution_layer1);%��һ�������к���
%         %[layer2_rmax,layer2_cmax]=size(Solution_layer2);
%         
%         %û�в��ܼ����size
%         if P_layer1_ri==0
%             Solution_layer1i=Solution_layer1(layer1_rmax,:); 
%         end
%         
%         if P_layer2_ri==0 
%             Solution_layer2i=Solution_layer2(layer2_rmax,:);
%         end
%         
%         %------------------��ʼ��Ъִ��----------------------%
%         flag=1; %���ͷŵ��жϲ���
%         count_time=0; %ִ��ʱ��
%         flag_size=0;
%        
%         layer1_trans_r=0;
%         layer2_trans_r=0;
%         Layer1_eta=0;
%         Layer2_eta=0;
%         t_onecycle=0; %���ʱ��+ִ��ʱ��
%         charge_flag=0;%һ��cycle��һ��
%         t_total=0; %һ��power cycle���ʱ���ܺ�
%         %��Ъִ�вɼ�������
%         Energy_collect_i=P_harvest*cyc_time;
%         V_present=sqrt(2*Estore/(C*(1e-9)));%��ǰ���ݵĵ�ѹֵ
%         t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);%���ʱ��
%         working_cycle_time1=0;
% 
%         working_cycle_time2=0;
%         working_cycle_ops_i=0;
%         
%         if cyc_time>t %������ʱ����ڲ���ʱ�䣬�������һ��power cacle
%             while cyc_time>t_onecycle % �����ŵ�ʱ�䳬������ʱ�䣬�������һ��power cacle
%                 % ---------------------�ж��Ƿŵ绹�Ƿŵ�--------------------- %
%                 if flag==0
%                     Solution_1abs=abs(V-Solution_1);
%                     [size_m,size_n]=find(Solution_1abs==min(Solution_1abs));%��ǰ��ѹ��ת��Ч�ʱ���ӽ��ĵ�ѹ
% 
%                     Solution_layer1Effi=Solution_layer1i(:,size_n);%��ǰ��ѹ��һ���Ӧ��ת��Ч��
%                     Solution_layer2Effi=Solution_layer2i(:,size_n);%��ǰ��ѹ�ڶ����Ӧ��ת��Ч��
%         
%                     %��һ�����ת��Ч��
%                     Layer1_Trans_Efficiency=max(Solution_layer1Effi);
%                     %�ڶ������ת��Ч��
%                     Layer2_Trans_Efficiency=max(Solution_layer2Effi);
%                     %��ȡ��λ��
%                     [layer1_trans_r,layer1_trans_c]=find(Solution_layer1Effi== Layer1_Trans_Efficiency);
%                     [layer2_trans_r,layer2_trans_c]=find(Solution_layer2Effi== Layer2_Trans_Efficiency);
%                     layer1_trans_r=max(layer1_trans_r);
%                     %time_layer1=layer1_op_times*Solution_layer1i(layer1_trans_r,1)/4/(Solution_layer1i(layer1_trans_r,5)*Solution_layer1i(layer1_trans_r,6))*20e-9;
%                     %time_layer2=layer2_op_times*Solution_layer2i(layer2_trans_r,1)/4/(Solution_layer2i(layer2_trans_r,5)*Solution_layer2i(layer2_trans_r,6))*20e-9;
%                     
%                     time_layer1_tile=Solution_layer1i(layer1_trans_r,1)/4*20e-9;
%                     time_layer2_tile=Solution_layer2i(layer2_trans_r,1)/4*20e-9;
%                     
%                     %ÿһ�����������
%                     %Energy_consume_layer1=(Solution_layer1i(layer1_trans_r,3)/(0.01*Trans_Efficiency_layer1_present))*time_layer1;
%                     %Energy_consume_layer2=(Solution_layer2i(layer2_trans_r,3)/(0.01*Trans_Efficiency_layer2_present))*time_layer2;
%                     
%                     Energy_consume_layer1_tile=(Solution_layer1i(layer1_trans_r,3)/(0.01*Layer1_Trans_Efficiency))*time_layer1_tile;
%                     Energy_consume_layer2_tile=(Solution_layer2i(layer2_trans_r,3)/(0.01*Layer2_Trans_Efficiency))*time_layer2_tile;
%                     
%                     if layer1_count==0
%                         Max_Energy_consume=Energy_consume_layer1_tile;
%                     else
%                         Max_Energy_consume=Energy_consume_layer2_tile;
%                     end
%                     %Max_Energy_consume=max(Energy_consume_layer1,Energy_consume_layer2);
% 
%                     if  Estore>=Max_Energy_consume %���ٿ���ִ��һ��
%                         %��һ��
%                         if layer1_count==0 && Estore>=Energy_consume_layer1_tile %��һ��ִ������
%                             Operand_sum_i=Operand_sum_i+(Solution_layer1i(layer1_trans_r,4)*Solution_layer1i(layer1_trans_r,5)*Solution_layer1i(layer1_trans_r,6));
%                             Energy_use_i=Energy_use_i+Energy_consume_layer1_tile;
%                             %ִ�е�һ������ʣ������
%                             Estore=Estore-Energy_consume_layer1_tile;
%                             count_time=count_time+time_layer1_tile;
%                             if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer1_tile)
%                                 Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
%                             else
%                                 Estore=Estore+P_harvest*time_layer1_tile;
%                             end
%                             if charge_flag==1
%                                 working_cycle_time2=working_cycle_time2+time_layer1_tile;
%                                 working_cycle_ops_i=working_cycle_ops_i+(Solution_layer1i(layer1_trans_r,4)*Solution_layer1i(layer1_trans_r,5)*Solution_layer1i(layer1_trans_r,6));
%                             end
%                             t_onecycle=t_onecycle+time_layer1_tile;
%                             count_layer_times=count_layer_times+1*(Solution_layer1i(layer1_trans_r,5)*Solution_layer1i(layer1_trans_r,6));
%                             %�����ж�ִ�е�һ�㻹�ǵڶ���
%                             if  layer1_op_times<=count_layer_times
%                                 layer1_count=1;
%                                 layer2_count=0;
%                                 count_layer_times=0;
%                             end
%                         end
%                         %�ڶ���
%                         if layer2_count==0 && Estore>=Energy_consume_layer2_tile %�ڶ���ִ������
%                             Operand_sum_i=Operand_sum_i+(Solution_layer2i(layer2_trans_r,4)*Solution_layer2i(layer2_trans_r,5)*Solution_layer2i(layer2_trans_r,6));
%                             Energy_use_i=Energy_use_i+Energy_consume_layer2_tile;
%                             %ִ�еڶ�������ʣ������
%                             Estore=Estore-Energy_consume_layer2_tile;   
%                             if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer2_tile)
%                                 Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
%                             else
%                                 Estore=Estore+P_harvest*time_layer2_tile;
%                             end
%                             if charge_flag==1
%                                 working_cycle_time2=working_cycle_time2+time_layer2_tile;
%                                 working_cycle_ops_i=working_cycle_ops_i+(Solution_layer2i(layer2_trans_r,4)*Solution_layer2i(layer2_trans_r,5)*Solution_layer2i(layer2_trans_r,6));
%                             end
%                             count_time=count_time+time_layer2_tile;
%                             t_onecycle=t_onecycle+time_layer2_tile;
%                             count_layer_times=count_layer_times+1*(Solution_layer2i(layer2_trans_r,5)*Solution_layer2i(layer2_trans_r,6));
%                             %�����ж�ִ�е�һ�㻹�ǵڶ���
%                             if  layer2_op_times<=count_layer_times
%                                 layer1_count=0;
%                                 layer2_count=1;
%                                 count_layer_times=0;
%                             end
%                         end 
%                     elseif  Estore==(1/2*C*1e-9*0.48*0.48) && Estore<Max_Energy_consume %���������������֧��һ������
%                         break;
%                     end
%                     V_up=sqrt(2*Estore/(C*(1e-9)));
%                 else %���
%                     if Estore<1/2*C*1e-9*0.48*0.48
%                         V_present=sqrt(2*Estore/(C*(1e-9)));
%                         t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);%���ʱ��
%                         Estore=1/2*C*1e-9*0.48*0.48;%���֮����ݴ洢������
% 
%                         charge_flag=charge_flag+1; 
%                         working_cycle_time1=t;
%                         V_up=0.48;
%                         V_down=0;
%                     else
%                         V_up=0.48;
%                         V_down=0;
%                         t=0;
%                         charge_flag=charge_flag+1; 
%                     end
%                 end
%                 % --------------------- ���ͷŵ� end  --------------------- %
%                 V=V_up-V_down;
%                 %ִ��һ�ηŵ���ж��Ƿ�����ŵ����ִ�г��
%                 if V>=0.255 && Estore>=Max_Energy_consume %�ŵ��ж�
%                     flag=0; 
%                 else %����ж�
%                     flag=1;
%                     t_total=t_total+t;%һ��power cycle���ʱ���ܺ�
%                     t_onecycle=t_onecycle+t;%һ��power cycle���ʱ���ִ��ʱ���ܺͣ�������������ʱ��������һ��power cycle
%                     count_time=0;
%                 end
%             end
%         else
%             Operand_sum_i=0;
%             Energy_use_i=0;
%             Estore=Estore+P_harvest*cyc_time;
%             working_cycle_time1=t;
%         end
%         if working_cycle_time1>=cyc_time
%             working_cycle_time=cyc_time;
%         elseif working_cycle_time2>=cyc_time
%             working_cycle_time=cyc_time;
%         else
%             working_cycle_time=working_cycle_time1+working_cycle_time2;
%         end
%         Energy_Effi_i=working_cycle_ops_i/(P_harvest*working_cycle_time);
%         Throughput_i=Operand_sum_i/cyc_time;%��Ъִ��������
%         %------------------case 2 end ��Ъִ��----------------------%
%         %---------------------------��Ъִ�� end------------------------%
%         
%         %------------------------- case2 ����ִ��--------------------------%
%         %��ǰpower cycle���ʲ�������Сsize�ļ���ʣ���������ִ��
%         if P_layer1==0 || P_layer2==0
%             Operand_sum_c=0;
%             Energy_use_c=0;
%             Energy_collect_c=P_harvest*cyc_time;
%             Throughput_c=0;%����ִ�е�������
%             working_cycle_ops_c=0;
%         %ѡ�����֧������ִ�е����size
%         else
%             %��������ִ�е�����tile size
%             Pmax_rpos1=P_layer1;
%             Pmax_rpos2=P_layer2;
%             
%             %Cycle_cnt_time=layer1_op_times*(Solution_layer1(Pmax_rpos1,1)/4/(Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6))+layer2_op_times*Solution_layer2(Pmax_rpos2,1)/4/(Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6)))*20e-9;
%             %op_cycle=cyc_time/Cycle_cnt_time;
%             %��һ��+�ڶ�����󼤻���Ĳ�����
%             %Operand_sum_c=(Solution_layer1(Pmax_rpos1,4)*Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6)...
%             %+Solution_layer2(Pmax_rpos2,4)*Solution_layer2(Pmax_rpos2,5)*Solution_layer2(Pmax_rpos2,6))*op_cycle;
%             
%             %time_layer1=layer1_op_times*Solution_layer1(Pmax_rpos1,1)/4/(Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6))*20e-9;
%             %time_layer2=layer2_op_times*Solution_layer2(Pmax_rpos2,1)/4/(Solution_layer2(Pmax_rpos2,5)*Solution_layer2(Pmax_rpos2,6))*20e-9;
% 
%             time_layer1_tile=Solution_layer1(Pmax_rpos1,1)/4*20e-9;
%             time_layer2_tile=Solution_layer2(Pmax_rpos2,1)/4*20e-9;
%             while cyc_time>t_onecycle
%                 %��һ��
%                 if layer1_count==0 %��һ��ִ������
%                     Operand_sum_c=Operand_sum_c+(Solution_layer1(Pmax_rpos1,4)*Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6));
%                     count_time=count_time+time_layer1_tile;
%                     if working_cycle_time>count_time
%                         working_cycle_ops_c=working_cycle_ops_c+(Solution_layer1(Pmax_rpos1,4)*Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6));
%                     end
%                     if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer1_tile)
%                         Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
%                     else
%                         Estore=Estore+P_harvest*time_layer1_tile;
%                     end
%                     t_onecycle=t_onecycle+time_layer1_tile;
%                     count_layer_times=count_layer_times+1*(Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6));
%                     %�����ж�ִ�е�һ�㻹�ǵڶ���
%                     if  layer1_op_times<=count_layer_times
%                         layer1_count=1;
%                         layer2_count=0;
%                         count_layer_times=0;
%                     end
%                 end
%                 %�ڶ���
%                 if layer2_count==0 %�ڶ���ִ������
%                     Operand_sum_c=Operand_sum_c+(Solution_layer2(Pmax_rpos2,4)*Solution_layer2(Pmax_rpos2,5)*Solution_layer2(Pmax_rpos2,6));
%                     count_time=count_time+time_layer2_tile;
%                     if working_cycle_time>=count_time
%                         working_cycle_ops_c=working_cycle_ops_c+(Solution_layer2(Pmax_rpos2,4)*Solution_layer2(Pmax_rpos2,5)*Solution_layer2(Pmax_rpos2,6));
%                     end 
%                     if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer2_tile)
%                         Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
%                     else
%                         Estore=Estore+P_harvest*time_layer2_tile;
%                     end
%                     t_onecycle=t_onecycle+time_layer2_tile;
%                     count_layer_times=count_layer_times+1*(Solution_layer2(Pmax_rpos2,5)*Solution_layer2(Pmax_rpos2,6));
%                     %�����ж�ִ�е�һ�㻹�ǵڶ���
%                     if  layer2_op_times<=count_layer_times
%                         layer1_count=0;
%                         layer2_count=1;
%                         count_layer_times=0;
%                     end
%                 end 
%             end
%             Energy_use_c=((Solution_layer1(Pmax_rpos1,3)+Solution_layer2(Pmax_rpos2,3))*cyc_time)/2;
%             %case2 ����ִ�вɼ�������
%             Energy_collect_c=P_harvest*cyc_time;
%             %case2 ����ִ�е�������
%             Throughput_c=Operand_sum_c/cyc_time;
%         end
%         Energy_Effi_c=working_cycle_ops_c/(P_harvest*working_cycle_time);
%         %------------------------����ִ��end-----------------------%
%         
%         %-----case 2 ����������ѡ��ִ�з�ʽ-----%
%         if Energy_Effi_c>=Energy_Effi_i || Energy_Effi_i==0% ѡ������ִ��
%             Operand_sum=Operand_sum_c;
%             Energy_use=Energy_use_c;
%             Energy_collect=Energy_collect_c; 
%         elseif Energy_Effi_c<Energy_Effi_i% ѡ���Ъִ��
%             Energy_collect=Energy_collect_i;
%             Operand_sum=Operand_sum_i;
%             Energy_use=Energy_use_i;
%         end
%         % ----case 2 ����������ѡ��ִ�з�ʽ end-----%
%     %--------------------------------- case 2 end -----------------------------------%
            
    %--------------------------- case 3 ֻ�ܼ�Ъִ��---------------------------------%
    elseif P_harvest > 0 % ִ�з�ʽͬ case 2 ��Ъִ�з�ʽ
        flag=1;
        flag_size=0;
        Layer1_eta=0;
        Layer2_eta=0;
        
        Layer1_eta_last=0;
        Layer2_eta_last=0;
        
        Pl_Layer1_Tile_Thr=zeros((layer1_rmax-1)/10,3);
        Pl_Layer2_Tile_Thr=zeros(layer2_rmax/10,3);
        
        Layer1_Trans_Efficiency=0;
        Layer2_Trans_Efficiency=0;
        
        eta1_flag=0;
        eta2_flag=0;
        
        Energy_collect=P_harvest*cyc_time;
        count_time=0; %ִ��ʱ��
        t_onecycle=0;
        layer1_trans_r=0;
        layer2_trans_r=0;
        V_present=sqrt(2*Estore/(C*(1e-9)));
        t_total=0;
        t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);

        if cyc_time>t
            while cyc_time>t_onecycle  % case 3 ��ţ���ϣ�ģ��
                % ---------------------�ж��Ƿŵ绹�ǳ��һ��--------------------- %
                if flag==0
                    Solution_1abs=abs(V-Solution_1);
                    [size_2m,size_2n]=find(Solution_1abs==min(Solution_1abs));%��ǰ��ѹ
                    size_n=size_2n(1,1);
                    %ѡ��ǰ�ܼ� �� ��ǰ��ѹ��Ӧ������Tile size��������
                    for idx_l1=1:layer1_rmax/10
                        Pl_Layer1_Tile_Thr(idx_l1,1)=Solution_layer1(pl_ps_size1+10*(idx_l1-1),size_n+1);
                        Pl_Layer1_Tile_Thr(idx_l1,2)=pl_ps_size1+10*(idx_l1-1);
                        Pl_Layer1_Tile_Thr(idx_l1,3)=Solution_layer1(pl_ps_size1+10*(idx_l1-1),size_n);
                    end
                    for idx_l2=1:(layer2_rmax/10)
                        Pl_Layer2_Tile_Thr(idx_l2,1)=Solution_layer2((pl_ps_size1-1)+10*(idx_l2-1),size_n+1);
                        Pl_Layer2_Tile_Thr(idx_l2,2)=(pl_ps_size1-1)+10*(idx_l2-1);
                        Pl_Layer2_Tile_Thr(idx_l2,3)=Solution_layer2((pl_ps_size1-1)+10*(idx_l2-1),size_n);
                    end
                    
                    [Layer1_maxThr,Layer1_max_idx]=max(Pl_Layer1_Tile_Thr(:,1));
                    [Layer2_maxThr,Layer2_max_idx]=max(Pl_Layer2_Tile_Thr(:,1));
                    Layer1_eta=Pl_Layer1_Tile_Thr(Layer1_max_idx,3);
                    Layer2_eta=Pl_Layer2_Tile_Thr(Layer2_max_idx,3);
                    %һ��ʼѡ��size
                    if eta1_flag==0
                        Layer1_Trans_Efficiency=Pl_Layer1_Tile_Thr(Layer1_max_idx,3);
                        
                        Layer1_eta_last=Layer1_Trans_Efficiency;
        
                        layer1_trans_r=Pl_Layer1_Tile_Thr(Layer1_max_idx,2);%ȡ�����size����λ��
                        eta1_flag=1;
                        
                    end
                    if eta2_flag==0
                        Layer2_Trans_Efficiency=Pl_Layer2_Tile_Thr(Layer2_max_idx,3);
                        
                        Layer2_eta_last=Layer2_Trans_Efficiency;
                        layer2_trans_r=Pl_Layer2_Tile_Thr(Layer2_max_idx,2);%ȡ�����size����λ��
                        eta2_flag=1;
                    end
                    %�л�size����
                    if  Layer1_eta_last >Layer1_eta
                        Layer1_Trans_Efficiency=Pl_Layer1_Tile_Thr(Layer1_max_idx,3);
                        layer1_trans_r=Pl_Layer1_Tile_Thr(Layer1_max_idx,2);%ȡ�����size����λ��
                        
                    else
                        Layer1_eta_last=Layer1_eta;
                    end
                    
                    if  Layer2_eta_last >Layer2_eta
                        Layer2_Trans_Efficiency=Pl_Layer2_Tile_Thr(Layer2_max_idx,3);
                        layer2_trans_r=Pl_Layer2_Tile_Thr(Layer2_max_idx,2);%ȡ�����size����λ��
                        
                    else
                        Layer2_eta_last=Layer2_eta;
                    end
%                     Solution_layer1Effi=Solution_layer1(:,size_n);%��ǰ��ѹ��һ���Ӧ��ת��Ч��
%                     Solution_layer2Effi=Solution_layer2(:,size_n);%��ǰ��ѹ�ڶ����Ӧ��ת��Ч��

%                     %��һ�����ת��Ч��
%                     Layer1_Trans_Efficiency=max(Solution_layer1Effi);
%                     %�ڶ������ת��Ч��
%                     Layer2_Trans_Efficiency=max(Solution_layer2Effi);
% 
%                     [layer1_trans_r,layer1_trans_c]=find(Solution_layer1Effi== Layer1_Trans_Efficiency);
%                     [layer2_trans_r,layer2_trans_c]=find(Solution_layer2Effi== Layer2_Trans_Efficiency);

                    %time=(Solution_layer1(layer1_trans_r,1)+Solution_layer2(layer2_trans_r,1))/4*20e-9; % s
                    
                    %time_layer1=layer1_op_times*Solution_layer1(layer1_trans_r,1)/4/(Solution_layer1(layer1_trans_r,5)*Solution_layer1(layer1_trans_r,6))*20e-9;
                    %time_layer2=layer2_op_times*Solution_layer2(layer2_trans_r,1)/4/(Solution_layer2(layer2_trans_r,5)*Solution_layer2(layer2_trans_r,6))*20e-9;
                    
                    time_layer1_tile=Solution_layer1(layer1_trans_r,1)/4*20e-9;
                    time_layer2_tile=Solution_layer2(layer2_trans_r,1)/4*20e-9;
                    
                    %Energy_consume_layer1=(Solution_layer1(layer1_trans_r,3)/(0.01*Trans_Efficiency_layer1_present))*time_layer1;
                    %Energy_consume_layer2=(Solution_layer2(layer2_trans_r,3)/(0.01*Trans_Efficiency_layer2_present))*time_layer2;
                         
                    Energy_consume_layer1_tile=(Solution_layer1(layer1_trans_r,3)/(0.01*Layer1_Trans_Efficiency))*time_layer1_tile;
                    Energy_consume_layer2_tile=(Solution_layer2(layer2_trans_r,3)/(0.01*Layer2_Trans_Efficiency))*time_layer2_tile;
                    
                    if layer1_count==0
                        Max_Energy_consume=Energy_consume_layer1_tile;
                    else
                        Max_Energy_consume=Energy_consume_layer2_tile;
                    end
                    %Max_Energy_consume=max(Energy_consume_layer1,Energy_consume_layer2);
                    
                    if Estore>=Max_Energy_consume %���ݵĴ洢��������������ִ��һ������
                        if layer1_count==0 && Estore>=Energy_consume_layer1_tile
                            Operand_sum=Operand_sum+(Solution_layer1(layer1_trans_r,4)*Solution_layer1(layer1_trans_r,5)*Solution_layer1(layer1_trans_r,6));
                            Energy_use=Energy_use+Energy_consume_layer1_tile;
                            Estore=Estore-Energy_consume_layer1_tile;
                            count_time=count_time+time_layer1_tile;
                            if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer1_tile)
                                Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
                            else
                                Estore=Estore+P_harvest*time_layer1_tile;
                            end
                            t_onecycle=t_onecycle+time_layer1_tile;
                            count_time= count_time+time_layer1_tile;
                            count_layer_times=count_layer_times+1*(Solution_layer1(layer1_trans_r,5)*Solution_layer1(layer1_trans_r,6));
                            %�����ж�ִ�е�һ�㻹�ǵڶ���
                            if  layer1_op_times<=count_layer_times
                                layer1_count=1;
                                layer2_count=0;
                                count_layer_times=0;
                            end
                        end
                        if layer2_count==0 && Estore>=Energy_consume_layer2_tile
                            Operand_sum=Operand_sum+(Solution_layer2(layer2_trans_r,4)*Solution_layer2(layer2_trans_r,5)*Solution_layer2(layer2_trans_r,6));
                            Energy_use=Energy_use+Energy_consume_layer2_tile;
                            Estore=Estore-Energy_consume_layer2_tile;
                            count_time=count_time+time_layer2_tile;
                            
                            if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer2_tile)
                                Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
                            else
                                Estore=Estore+P_harvest*time_layer2_tile;
                            end
                            t_onecycle=t_onecycle+time_layer2_tile;
                            count_time= count_time+time_layer2_tile;
                           count_layer_times=count_layer_times+1*(Solution_layer2(layer2_trans_r,5)*Solution_layer2(layer2_trans_r,6));
                            %�����ж�ִ�е�һ�㻹�ǵڶ���
                            if  layer2_op_times<=count_layer_times
                                layer1_count=0;
                                layer2_count=1;
                                count_layer_times=0;
                            end
                        end
                    elseif  Estore==(1/2*C*1e-9*0.48*0.48) && Estore<Max_Energy_consume 
                        break;
                    end
                    V_up=sqrt(2*Estore/(C*(1e-9)));

                else %���
                    V_present=sqrt(2*Estore/(C*(1e-9)));
                    t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);%���ʱ��
                    Estore=1/2*C*1e-9*0.48*0.48;%��絽0.48V���ݵ����� 
                    V_up=0.48;
                    V_down=0;
                end
                % --------------------- ��ŵ� end     --------------------- %
                V=V_up-V_down;
                if V>=0.255 && Estore>=Max_Energy_consume %�ŵ��ж�
                    flag=0;
                else %����ж�
                    flag=1;
                    t_total=t_total+t;%һ��power cycle���ʱ���ܺ�
                    t_onecycle=t_onecycle+t;%һ��power cycle���ʱ���ִ��ʱ���ܺ�
                    count_time=0;
                end   
            end
        else
            Operand_sum=0;
            Energy_use=0;
            Estore=Estore+P_harvest*cyc_time;
        end
    end
    %-------------------- case 3 end ---------------------%
    
    %-------�����һ��cycle����Ч�������ʣ�����������-------%
    if P_harvest == 0
        Energy_efficiency(i,1)= 0;
        Throughput_efficiency(i,1)=0;
        Energy_utilization(i,1)=0;
    else
        if Energy_collect~=0
            Energy_efficiency(i,1)= Operand_sum/Energy_collect;
        else 
            Energy_efficiency(i,1)=0;
        end
        Throughput_efficiency(i,1)=Operand_sum/cyc_time;
        if Energy_collect~=0 
            Energy_utilization(i,1)=Energy_use/Energy_collect;
        else 
            Energy_utilization(i,1)=0;
        end
        All_Operand_sum=All_Operand_sum+Operand_sum;
        E_use_sum=E_use_sum+Energy_use;
        E_collect_sum=E_collect_sum+Energy_collect;
        
    end
    %-------�����һ��cycle����Ч�������ʣ����������� end-------%
end

%--------����power trace end--------%
if E_collect_sum ~=0
    Energy_efficiency_final=All_Operand_sum/E_collect_sum;
else 
     Energy_efficiency_final=0;
end
if cyc_time ~=0
    Throughput_efficiency_final=All_Operand_sum/(cyc_time*m_ph);
else
    Throughput_efficiency_final=0;
end

Esum_uti=E_use_sum/E_collect_sum;
Out(:,1)=Power_harvest(:,1);
Out(:,2)=Energy_efficiency;
Out(:,3)=Throughput_efficiency;
Out(:,4)=Energy_utilization;

%�޸ĵ����ļ����ļ���
%csvwrite('Maxt3_FR_Piezo222.csv',Out);
%csvwrite('Maxt3_FR_TV-RF222.csv',Out);
%csvwrite('Maxt3_FR_Thermal.csv',Out);
%csvwrite('Maxt3_FR_Wifi-home.csv',Out);

% xlswrite('result_lenet.xls',Power_harvest(:,1),sheet1,'A2');
% xlswrite('result_lenet.xls',Energy_efficiency,sheet1,'B2');
% xlswrite('result_lenet.xls',Throughput_efficiency,sheet1,'C2');
% xlswrite('result_lenet.xls',Energy_utilization,sheet1,'D2');