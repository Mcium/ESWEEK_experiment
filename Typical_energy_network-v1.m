% Power_harvest1=xlsread('E:\matlab\ICCAD\energy\Piezo.xlsx');% power trace read
% Power_harvest=Power_harvest1(:,1);%ע��power trace�ļ��ɼ����������п��ܲ�ͬ

Power_harvest1=xlsread('E:\matlab\ICCAD\energy\TV-RF.xlsx');
Power_harvest=Power_harvest1(1:900,1);%ע��power trace�ļ��ɼ����������п��ܲ�ͬ

%Power_harvest1=xlsread('E:\matlab\ICCAD\energy\Thermal.xlsx');
%Power_harvest=Power_harvest1(:,1);%ע��power trace�ļ��ɼ����������п��ܲ�ͬ

%Power_harvest1=xlsread('E:\matlab\ICCAD\energy\WiFi-home.xlsx');
%Power_harvest=Power_harvest1(1:10000,4);%ע��power trace�ļ��ɼ����������п��ܲ�ͬ

% TV-RF Piezo Thermal WiFi-home WiFi-office

%��ͬ�����Ĳ������ڲ�һ������Ҫ�ֶ��޸�
%cyc_time=0.0001; % piezo��������
cyc_time=0.1; % TV-RF��������
%cyc_time=0.2; % Thermal��������
%cyc_time=0.2; % WiFi-home��������

%Solution=xlsread('E:\matlab\ICCAD\networks\fr-piezo-tt.xlsx');%
Solution=xlsread('E:\matlab\ICCAD\networks\fr-TVRF-tt.xlsx');%
%---------FR�������----------%
FR_Conv1=[4,28,28];
FR_Conv2=[16,10,10];

%tile sizeΪ25x1x1ʱ����һ��ִ�еĴ���
layer1_op_times=FR_Conv1(1)*FR_Conv1(2)*FR_Conv1(3);
%tile sizeΪ64x1x1ʱ���ڶ���ִ�еĴ���
layer2_op_times=FR_Conv2(1)*FR_Conv2(2)*FR_Conv2(3);

% Solution_layer1=Solution(1:7,:);%��һ��tile size
% Solution_layer2=Solution(8:10,:);%�ڶ���tile size
Solution_layer1=Solution(1:43,:);%��һ��tile size
Solution_layer2=Solution(44:56,:);%�ڶ���tile size

% %LeNet
% %Solution=xlsread('E:\matlab\ICCAD\networks\lenet-piezo-tt.xlsx');
% Solution=xlsread('E:\matlab\ICCAD\networks\lenet-TVRF-tt.xlsx');
% %Solution=xlsread('E:\matlab\ICCAD\networks\lenet-thermal.xlsx');
% %Solution=xlsread('E:\matlab\ICCAD\networks\lenet-WifiHome.xlsx');
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
% % Solution_layer1=Solution(1:7,:);%��һ��tile size
% % Solution_layer2=Solution(8:9,:);%�ڶ���tile size
% %LeNet-TVRF��ȡÿһ���tile size����
% Solution_layer1=Solution(1:43,:);%��һ��tile size
% Solution_layer2=Solution(44:52,:);%�ڶ���tile size
% % LeNet-thermal��ȡÿһ���tile size����
% % Solution_layer1=Solution(1:15,:);%��һ��tile size
% % Solution_layer2=Solution(16:21,:);%�ڶ���tile size
% 
% %---------end LeNet�������-----------%

% %-------------------HG�������--------------------%
% % %HG
% Solution=xlsread('E:\matlab\ICCAD\networks\hg-piezo-tt.xlsx');
% %Solution=xlsread('E:\matlab\ICCAD\networks\hg-TVRF-tt.xlsx');
% %------------HG�������-------------%
% HG_Conv1=[6,24,24];
% HG_Conv2=[12,8,8];
% 
% %tile sizeΪ25x1x1ʱ����һ��ִ�еĴ���
% layer1_op_times=HG_Conv1(1)*HG_Conv1(2)*HG_Conv1(3);
% %tile sizeΪ150x1x1ʱ���ڶ���ִ�еĴ���
% layer2_op_times=HG_Conv2(1)*HG_Conv2(2)*HG_Conv2(3);
% %LeNet-piezo��ȡÿһ���tile size����
% Solution_layer1=Solution(1:8,:);%��һ��tile size
% Solution_layer2=Solution(9:12,:);%�ڶ���tile size
% % Solution_layer1=Solution(1:44,:);%��һ��tile size
% % Solution_layer2=Solution(45:61,:);%�ڶ���tile size
% 
% %--------------end HG�������----------------%

[layer1_rsize,layer1_csize]=size(Solution_layer1);
[layer2_rsize,layer2_csize]=size(Solution_layer2);
% lenet fr pv hg

Power_search=Solution(:,3);% ��ͬ�ֿ鸺�ع���
Solution_1=Solution(1,:);% ���ݷŵ��ѹ
[m_ph,n_ph]=size(Power_harvest);
Energy_efficiency=zeros(m_ph,1); %��Ч
Throughput_efficiency=zeros(m_ph,1); %������
Energy_utilization=zeros(m_ph,1); %����������
Out=zeros(m_ph,4);
C=47; %����
C1=22;
Estore1=0;%���ݴ洢����
cyc_time_typical=cyc_time;

% FRÿ���tile size
Power_search_layer1=Solution_layer1(:,3);
[psl1r,psl1c]=size(Power_search_layer1);%ѡ���һ��size��Ҫ�õ��Ĳ���
Power_search_layer2=Solution_layer2(:,3);
[psl2r,psl2c]=size(Power_search_layer2);%ѡ��ڶ���size��Ҫ�õ��Ĳ���


%���size��λ��
[layer1_rmax,layer1_cmax]=size(Solution_layer1);%��һ��
[layer2_rmax,layer2_cmax]=size(Solution_layer2);%�ڶ���

%-----FR ��ѯ����ʶ�Ӧ����Сת��Ч�ʺ���С���ʶ�Ӧ�����ת��Ч��,��Ҫ���ڲ�ͬ���磬�ò����ֶ��޸�-----%
%-----�����ж���������Ĳ���-----%
Psl_layer1=Solution_layer1(2,3)/(0.01*max(Solution_layer1(2,7:31)));
Psl_layer2=Solution_layer2(1,3)/(0.01*max(Solution_layer2(1,7:31)));
Psl=max(Psl_layer1,Psl_layer2); %min ��Сsize��Ӧ��õ�ת��Ч�ʵĹ���

Pll_layer1=Solution_layer1(layer1_rmax,3)/(0.01*min(Solution_layer1(layer1_rmax,7:31)));
Pll_layer2=Solution_layer2(layer2_rmax,3)/(0.01*min(Solution_layer2(layer2_rmax,7:31)));
Pll=max(Pll_layer1,Pll_layer2); %max ���size��Ӧ����ת��Ч�ʵĹ���
%-----�����ж���������Ĳ���-----%


All_Operand_sum=0;
E_use_sum=0;
E_collect_sum=0;
V=0;
layer1_count=0;
layer2_count=1;
power_level=zeros(10,1);
count_layer_times=0;
%-------------�����߼���-------ͳ���ܼ� ��������ˮƽ�����ܼ�--------------%
%Piezo
for i=1:m_ph
%     P_harv=Power_harvest(i,1);
%     if P_harv<=100
%         power_level(1,1)=power_level(1,1)+1;  
%     elseif P_harv<=200
%         power_level(2,1)=power_level(2,1)+1;  
%     elseif P_harv<=300
%        power_level(3,1)=power_level(3,1)+1;  
%     elseif P_harv<=400
%         power_level(4,1)=power_level(4,1)+1;  
%     elseif P_harv<=500
%         power_level(5,1)=power_level(5,1)+1;  
%     elseif P_harv<=600
%         power_level(6,1)=power_level(6,1)+1;  
%     elseif P_harv<=700
%         power_level(7,1)=power_level(7,1)+1;  
%     elseif P_harv<=800
%         power_level(8,1)=power_level(8,1)+1;   
%     elseif P_harv<=900
%         power_level(9,1)=power_level(9,1)+1;  
%     else
%         power_level(10,1)=power_level(10,1)+1;
%     end
%     %TVRF
    P_harv=Power_harvest(i,1);
    if P_harv<=2000
        power_level(1,1)=power_level(1,1)+1;  
    elseif P_harv<=4000
        power_level(2,1)=power_level(2,1)+1;  
    elseif P_harv<=6000
       power_level(3,1)=power_level(3,1)+1;  
    elseif P_harv<=8000
        power_level(4,1)=power_level(4,1)+1;  
    elseif P_harv<=10000
        power_level(5,1)=power_level(5,1)+1;  
    elseif P_harv<=12000
        power_level(6,1)=power_level(6,1)+1;  
    elseif P_harv<=14000
        power_level(7,1)=power_level(7,1)+1;  
    elseif P_harv<=16000
        power_level(8,1)=power_level(8,1)+1;   
    elseif P_harv<=18000
        power_level(9,1)=power_level(9,1)+1;  
    else
        power_level(10,1)=power_level(10,1)+1;
    end
end
%--------------end ͳ���ܼ� ��������ˮƽ�����ܼ�-----------%

%------------------��������ܼ��͸��ܼ���С����----------------%
[level_m,level_n]=max(power_level);%level_m:���ֵ,level_n:����λ�ã�������ܼ�
%�ܼ����ʷ�Χ
% Power_level_n=(100+(100*(level_n-1)));%��Ӧ�ܼ��������
% Power_level_n1=100*(level_n-1);%��Ӧ�ܼ�����С����

Power_level_n=(2000+(2000*(level_n-1)));%��Ӧ�ܼ��������
Power_level_n1=2000*(level_n-1);%��Ӧ�ܼ�����С����
%------�������ܼ�����С����-------%
Power_level_min=max(Power_harvest);%��ʼ��
for i=1:m_ph
    if Power_harvest(i,1)<Power_level_n && Power_harvest(i,1)>Power_level_n1
        if Power_harvest(i,1)<Power_level_min && Power_harvest(i,1)~=0
            Power_level_min=Power_harvest(i,1);
        end
    end
end
%----------�ܼ�����---------%
Power_level_mid=Power_level_min*1e-6;

%------------------end ��������ܼ��͸��ܼ���С����----------------%

%layer1_EE=zeros(layer1_rmax,1);
%layer1_EEmax=0;
%layer2_EE=zeros(layer2_rmax,1);
%layer2_EEmax=0;
%for i=1:layer1_rmax
%   layer1_EEmax=(Solution_layer1(i,4)*Solution_layer1(i,5)*Solution_layer1(i,6))/Power_level_mid;
%    layer1_EE(i,1)=layer1_EEmax;
%end
%[EE1,EE1_index]=max(layer1_EEmax);
%for j=1:layer2_rmax
%    layer2_EEmax=(Solution_layer2(j,4)*Solution_layer2(j,5)*Solution_layer2(j,6))/Power_level_mid;
%    layer2_EE(j,1)=layer2_EEmax;
%end
%[EE2,EE2_index]=max(layer2_EEmax);
%typical_layer1_size=EE1_index;
%typical_layer2_size=EE2_index;

%�������㲻ͬsize��Ϸ�ʽ�Ĺ���
typical_index=zeros(1,3)*nan;
count_index=0;
for i=2:psl1r
    for j=1:psl2r
        poweri=Solution_layer1(i,3)/min(min(Solution_layer1(i,7:31)));
        powerj=Solution_layer2(j,3)/min(min(Solution_layer2(j,7:31)));
        if (max(poweri,powerj))<=Power_level_mid
            count_index=count_index+1;
            typical_index(count_index,1)=i;
            typical_index(count_index,2)=j;
            typical_index(count_index,3)=poweri+powerj;
        end
    end
end
[index_r,index_c]=size(typical_index);

[typical_power_max,index_max]=max(typical_index(:,3));%�������е����size

working_cycle_layer1_time1=0;
working_cycle_layer1_time2=0;
working_cycle_ops_i1=0;
working_cycle_layer2_time1=0;
working_cycle_layer2_time2=0;
working_cycle_ops_i2=0;
working_cycle_ops_c=0;

typical_EETH_index=zeros(1,4)*nan;

count_index=0;
typical_layer1_csize=2;
typical_layer2_csize=1;

if ~isnan(typical_index)
    typical_layer1_csize=typical_index(index_max,1);
    typical_layer2_csize=typical_index(index_max,2);

    time_layer1_tile=Solution_layer1(typical_layer1_csize,1)/4*20e-9;
    time_layer2_tile=Solution_layer2(typical_layer2_csize,1)/4*20e-9;

    while cyc_time>t_onecycle
        %��һ��
        if layer1_count==0 %��һ��ִ������
            Operand_sum=Operand_sum+(Solution_layer1(typical_layer1_csize,4)*Solution_layer1(typical_layer1_csize,5)*Solution_layer1(typical_layer1_csize,6));

            count_time=count_time+time_layer1_tile;
            if (1/2*C*1e-9*0.48*0.48)<(Estore+P_harvest*time_layer1_tile)
                Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
            else
                Estore=Estore+P_harvest*time_layer1_tile;
            end
            t_onecycle=t_onecycle+time_layer1_tile;
            count_layer_times=count_layer_times+1*(Solution_layer1(typical_layer1_csize,5)*Solution_layer1(typical_layer1_csize,6));
            %�����ж�ִ�е�һ�㻹�ǵڶ���
            if  layer1_op_times<=count_layer_times
                layer1_count=1;
                layer2_count=0;
                count_layer_times=0;
            end
        end
        %�ڶ���
        if layer2_count==0 %�ڶ���ִ������
            Operand_sum=Operand_sum+(Solution_layer2(typical_layer2_csize,4)*Solution_layer2(typical_layer2_csize,5)*Solution_layer2(typical_layer2_csize,6));   
            count_time=count_time+time_layer2_tile;
            if (1/2*C*1e-9*0.48*0.48)<(Estore+P_harvest*time_layer2_tile)
                Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
            else
                Estore=Estore+P_harvest*time_layer2_tile;
            end
            t_onecycle=t_onecycle+time_layer2_tile;
            count_layer_times=count_layer_times+1*(Solution_layer2(typical_layer2_csize,5)*Solution_layer2(typical_layer2_csize,6));
            %�����ж�ִ�е�һ�㻹�ǵڶ���
            if  layer2_op_times<=count_layer_times
                layer1_count=0;
                layer2_count=1;
                count_layer_times=0;
            end
        end 
    end

    Energy_use=((Solution_layer1(typical_layer1_csize,3)+Solution_layer2(typical_layer2_csize,3))*cyc_time_typical)/2;
    Energy_collect=Power_level_mid*cyc_time_typical;
    EnergyEffi_typical=Operand_sum/Energy_collect;
    Throughput_typical=Operand_sum/cyc_time_typical;

    count_index=count_index+1;
    typical_EETH_index(count_index,1)=typical_layer1_csize;
    typical_EETH_index(count_index,2)=typical_layer2_csize;
    typical_EETH_index(count_index,3)=EnergyEffi_typical;
    typical_EETH_index(count_index,4)=Throughput_typical;
end

%------��������ܼ���tile size����Ч��������----------%
for i=typical_layer1_csize+1:layer1_rsize
    for j=typical_layer2_csize:layer2_rsize 
        layer1_count=0;
        layer2_count=1;
        Cycle_cnt=0;
        Operand_sum=0;
        Energy_use=0;
        Power_typical=0;
        Energy_collect2=0;
        count_time=0;
        Power_present=0;
        Throughput_i=0;
        Throughput_c=0;
        t_onecycle=0;
        t_count=0;%һ��cycle�ĳ�����


        Energy_consume_layer1=0;
        Energy_consume_layer2=0;
        Max_Energy_consume=0;
        Energy_present_layer1=0;
        Energy_present_layer2=0;
        
        flag=1;
        Estore1=0;
        Energy_collect=Power_level_mid*cyc_time_typical;
        V_present=sqrt(2*Estore1/(C1*(1e-9)));
        t=(C1*1e-9*(0.48*0.48-V_present*V_present))/(2*Power_level_mid);
        t_total=0;
        if cyc_time_typical>t
            while cyc_time_typical>t_onecycle % case 3 ��ţ���ϣ�ģ��
                % ---------------------�ж��Ƿŵ绹�ǳ��һ��--------------------- %
                 if flag==0
                    Solution_1abs=abs(V-Solution_1);
                    [size_m,size_n]=find(Solution_1abs==min(Solution_1abs));%��ǰ��ѹ

                    %��һ�����ת��Ч��
                    Layer1_Trans_Efficiency=Solution_layer1(i,size_n);
                    %�ڶ������ת��Ч��
                    Layer2_Trans_Efficiency=Solution_layer2(j,size_n);

                    time=(Solution_layer1(i,1)+Solution_layer2(j,1))/4*20e-9; % s
                    time_layer1_tile=Solution_layer1(i,1)/4*20e-9;
                    time_layer2_tile=Solution_layer2(j,1)/4*20e-9;

                    %��ǰ����������������
                    Energy_consume_layer1_tile=(Solution_layer1(i,3)/(0.01*Layer1_Trans_Efficiency))*time_layer1_tile;
                    Energy_consume_layer2_tile=(Solution_layer2(j,3)/(0.01*Layer2_Trans_Efficiency))*time_layer2_tile;

                    if layer1_count==0
                        Max_Energy_consume=Energy_consume_layer1_tile;
                    else
                        Max_Energy_consume=Energy_consume_layer2_tile;
                    end

                    %Energy_present_layer1=Solution_layer1(i,3)*time_layer1;
                    %Energy_present_layer2=Solution_layer2(j,3)*time_layer2;

                    if Estore1>=Max_Energy_consume
                        if layer1_count==0 && Estore1>=Energy_consume_layer1_tile
                            Operand_sum=Operand_sum+(Solution_layer1(i,4)*Solution_layer1(i,5)*Solution_layer1(i,6));
                            Estore1=Estore1-Energy_consume_layer1_tile;
                            Energy_use=Energy_use+Energy_consume_layer1_tile;
                            count_time=count_time+time_layer1_tile;
                            if (1/2*C1*1e-9*0.48*0.48)<(Estore1+Power_level_mid*time_layer1_tile)
                                Estore1=1/2*C1*1e-9*0.48*0.48;%�߷ű߳�
                            else
                                Estore1=Estore1+Power_level_mid*time_layer1_tile;
                            end
                            t_onecycle=t_onecycle+time_layer1_tile;
                            count_time= count_time+time_layer1_tile;
                            count_layer_times=count_layer_times+1*(Solution_layer1(i,5)*Solution_layer1(i,6));
                            %�����ж�ִ�е�һ�㻹�ǵڶ���
                            if  layer1_op_times<=count_layer_times
                                layer1_count=1;
                                layer2_count=0;
                                count_layer_times=0;
                            end
                        end
                        if layer2_count==0 && Estore1>=Energy_consume_layer2_tile
                            Operand_sum=Operand_sum+(Solution_layer2(j,4)*Solution_layer2(j,5)*Solution_layer2(j,6));
                            Energy_use=Energy_use+Energy_consume_layer2_tile;
                            Estore1=Estore1-Energy_consume_layer2_tile;
                            if (1/2*C1*1e-9*0.48*0.48)<(Estore1+Power_level_mid*time_layer2_tile)
                                Estore1=1/2*C1*1e-9*0.48*0.48;%�߷ű߳�
                            else
                                Estore1=Estore1+Power_level_mid*time_layer2_tile;
                            end
                            t_onecycle=t_onecycle+time_layer2_tile;
                            count_time= count_time+time_layer2_tile;
                            count_layer_times=count_layer_times+1*(Solution_layer2(j,5)*Solution_layer2(j,6));
                            %�����ж�ִ�е�һ�㻹�ǵڶ���
                            if  layer2_op_times<=count_layer_times
                                layer1_count=1;
                                layer2_count=0;
                                count_layer_times=0;
                            end
                        end
                    elseif  Estore1>=(1/2*C1*1e-9*0.48*0.48) && Estore1<Max_Energy_consume 
                        Operand_sum=0;
                        Energy_use=0;
                        break;
                    end
                    V_up=sqrt(2*Estore1/(C1*(1e-9)));
                else
                    %Estore
                    V_present=sqrt(2*Estore1/(C1*(1e-9)));
                    t=(C1*1e-9*(0.48*0.48-V_present*V_present))/(2*Power_level_mid);
                    Estore1=1/2*C1*1e-9*0.48*0.48;
                    V_up=0.48;
                    V_down=0;
                end
                % ---------------------     end     --------------------- %
                V=V_up-V_down;
                if V>=0.24 && Estore1>=Max_Energy_consume %�ŵ��ж�
                    flag=0;
                else %����ж�
                    flag=1;
                    t_total=t_total+t;
                    t_onecycle=t_onecycle+t;
                    count_time=0;
                    if Estore1>=(1/2*C1*1e-9*0.48*0.48) && Estore1<Max_Energy_consume                   
                        break;
                    end
                end
            end
        else
            Operand_sum=0;
            Energy_use=0;
            Estore1=Estore1+P_harvest*cyc_time_typical;
        end
        EnergyEffi_typical=Operand_sum/Energy_collect;
        Throughput_typical=Operand_sum/cyc_time_typical;
        count_index=count_index+1;
        typical_EETH_index(count_index,1)=i;
        typical_EETH_index(count_index,2)=j;
        typical_EETH_index(count_index,3)=EnergyEffi_typical;
        typical_EETH_index(count_index,4)=Throughput_typical;
    end
end
%------��������ܼ���ѵ�tile size----------%


[typical_EE_max,index_EE]=max(typical_EETH_index(:,4));

typical_layer1_size=typical_EETH_index(index_EE,1);
typical_layer2_size=typical_EETH_index(index_EE,2);

%typical_layer1_size=16;
%typical_layer2_size=1;

Estore=0;
layer1_count=0;
layer2_count=1;
count_layer_times=0;
for i=1:m_ph
    
    P_harvest=Power_harvest(i,1)*(1e-6); % ��ǰcycle��Pload ��λW
    
    test_cnt=1;
    Cycle_cnt=0;
    Operand_sum=0;
    Power_Fullsize=0;
    Energy_use=0;
    Energy_collect=0;
    Energy_collect2=0;
    Energy_collect3=0;
    Power_present=0;
    Throughput_i=0;
    Throughput_c=0;
    t=0;%���ʱ��
    t_onecycle=0;
    t_count=0;%һ��cycle�ĳ�����
    count_time=0;
    Energy_consume_layer1=0;
    Energy_consume_layer2=0;
    Max_Energy_consume=0;
    
    %------------------------- case 1 �������� ����Full size��ѡ����Ҫ���ۣ���--------------------------%
    if P_harvest >= Pll % case 1
        
        %Cycle_cnt_time=((Solution_layer1(layer1_rmax,1)/4/(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6)))+...
        %(Solution_layer2(layer2_rmax,1)/4/(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6))))*20e-9;%ִ��һ����Ҫ��ʱ��
        %op_cycle=cyc_time/Cycle_cnt_time;%һ��power cycle����˳��ִ�еĴ���
        
        %��һ��+�ڶ�����󼤻���Ĳ�����
        %Operand_sum=(Solution_layer1(layer1_rmax,4)*Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6)...
        %+Solution_layer2(layer2_rmax,4)*Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6))*op_cycle;
        
        %time_layer1=layer1_op_times*Solution_layer1(layer1_rmax,1)/4/(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6))*20e-9;
        %time_layer2=layer2_op_times*Solution_layer2(layer2_rmax,1)/4/(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6))*20e-9;

        time_layer1_tile=Solution_layer1(typical_layer1_size,1)/4*20e-9;
        time_layer2_tile=Solution_layer2(typical_layer2_size,1)/4*20e-9;
        while cyc_time>t_onecycle
            %��һ��
            if layer1_count==0 %��һ��ִ������
                Operand_sum=Operand_sum+(Solution_layer1(typical_layer1_size,4)*Solution_layer1(typical_layer1_size,5)*Solution_layer1(typical_layer1_size,6));
         
                count_time=count_time+time_layer1_tile;
                if (1/2*C*1e-9*0.48*0.48)<(Estore+P_harvest*time_layer1_tile)
                    Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
                else
                    Estore=Estore+P_harvest*time_layer1_tile;
                end
                t_onecycle=t_onecycle+time_layer1_tile;
                count_layer_times=count_layer_times+1*(Solution_layer1(typical_layer1_size,5)*Solution_layer1(typical_layer1_size,6));
                %�����ж�ִ�е�һ�㻹�ǵڶ���
                if  layer1_op_times<=count_layer_times
                    layer1_count=1;
                    layer2_count=0;
                    count_layer_times=0;
                end
            end
            %�ڶ���
            if layer2_count==0 %�ڶ���ִ������
                Operand_sum=Operand_sum+(Solution_layer2(typical_layer2_size,4)*Solution_layer2(typical_layer2_size,5)*Solution_layer2(typical_layer2_size,6));   
                count_time=count_time+time_layer2_tile;
                if (1/2*C*1e-9*0.48*0.48)<(Estore+P_harvest*time_layer2_tile)
                    Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
                else
                    Estore=Estore+P_harvest*time_layer2_tile;
                end
                t_onecycle=t_onecycle+time_layer2_tile;
                count_layer_times=count_layer_times+1*(Solution_layer2(typical_layer2_size,5)*Solution_layer2(typical_layer2_size,6));
                %�����ж�ִ�е�һ�㻹�ǵڶ���
                if  layer2_op_times<=count_layer_times
                    layer1_count=0;
                    layer2_count=1;
                    count_layer_times=0;
                end
            end 
        end
        Energy_use=((Solution_layer1(typical_layer1_size,3)+Solution_layer2(typical_layer2_size,3))*cyc_time)/2;
        Energy_collect=P_harvest*cyc_time;
   %-------------------------- case 1 end ------------------------------%
   
   %----------------- case 2  ����ִ�л��Ъִ�� ѡ��������ִ�з�ʽ�ϸߵ� --------------%
   %-----------------������Թ̶�size ��case 2����ѡ��ִ�з�ʽ������ִ��������>��Ъִ�������ʣ���Ҫ���ۣ���-----------%
    elseif P_harvest >= Psl % ��ţ���ϣ�ģ��
    
        Trans_Efficiency_L1Fullsize=Solution_layer1(typical_layer1_size,7:31);
        Trans_Efficiency_L2Fullsize=Solution_layer2(typical_layer2_size,7:31);

        Trans_Efficiency_L1min=min(Trans_Efficiency_L1Fullsize);
        Trans_Efficiency_L2min=min(Trans_Efficiency_L2Fullsize);

        Power_L1Fullsize=Solution_layer1(typical_layer1_size,3);
        Power_L2Fullsize=Solution_layer2(typical_layer2_size,3);
        
        Power_present_max=max((Power_L1Fullsize/(Trans_Efficiency_L1min*0.01)),(Power_L2Fullsize/(Trans_Efficiency_L2min*0.01)));

        if P_harvest>=Power_present_max %����ִ��
            
            %Cycle_cnt_time=((Solution_layer1(layer1_rmax,1)/4/(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6)))+...
            %(Solution_layer2(layer2_rmax,1)/4/(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6))))*20e-9;%ִ��һ����Ҫ��ʱ��
            %op_cycle=cyc_time/Cycle_cnt_time;%һ��power cycle����˳��ִ�еĴ���
            
            %Operand_sum=(Solution_layer1(layer1_rmax,4)*Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6)...
            %+Solution_layer2(layer2_rmax,4)*Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6))*op_cycle;
            
            %time_layer1=layer1_op_times*Solution_layer1(layer1_rmax,1)/4/(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6))*20e-9;
            %time_layer2=layer2_op_times*Solution_layer2(layer2_rmax,1)/4/(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6))*20e-9;

            time_layer1_tile=Solution_layer1(typical_layer1_size,1)/4*20e-9;
            time_layer2_tile=Solution_layer2(typical_layer2_size,1)/4*20e-9;
            while cyc_time>t_onecycle
                %��һ��
                if layer1_count==0 %��һ��ִ������
                    Operand_sum=Operand_sum+(Solution_layer1(typical_layer1_size,4)*Solution_layer1(typical_layer1_size,5)*Solution_layer1(typical_layer1_size,6));

                    count_time=count_time+time_layer1_tile;
                    if (1/2*C*1e-9*0.48*0.48)<(Estore+P_harvest*time_layer1_tile)
                        Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
                    else
                        Estore=Estore+P_harvest*time_layer1_tile;
                    end
                    t_onecycle=t_onecycle+time_layer1_tile;
                    count_layer_times=count_layer_times+1*(Solution_layer1(typical_layer1_size,5)*Solution_layer1(typical_layer1_size,6));
                    %�����ж�ִ�е�һ�㻹�ǵڶ���
                    if  layer1_op_times<=count_layer_times
                        layer1_count=1;
                        layer2_count=0;
                        count_layer_times=0;
                    end
                end
                %�ڶ���
                if layer2_count==0 %�ڶ���ִ������
                    Operand_sum=Operand_sum+(Solution_layer2(typical_layer2_size,4)*Solution_layer2(typical_layer2_size,5)*Solution_layer2(typical_layer2_size,6));   
                    count_time=count_time+time_layer2_tile;
                    if (1/2*C*1e-9*0.48*0.48)<(Estore+P_harvest*time_layer2_tile)
                        Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
                    else
                        Estore=Estore+P_harvest*time_layer2_tile;
                    end
                    t_onecycle=t_onecycle+time_layer2_tile;
                    count_layer_times=count_layer_times+1*(Solution_layer2(typical_layer2_size,5)*Solution_layer2(typical_layer2_size,6));
                    %�����ж�ִ�е�һ�㻹�ǵڶ���
                    if  layer2_op_times<=count_layer_times
                        layer1_count=0;
                        layer2_count=1;
                        count_layer_times=0;
                    end
                end 
            end
            
            Energy_use=((Solution_layer1(typical_layer1_size,3)+Solution_layer2(typical_layer2_size,3))*cyc_time)/2;
            Energy_collect=P_harvest*cyc_time;
        else %��Ъִ��
            flag=1;
            V_present=sqrt(2*Estore/(C*(1e-9)));
            Energy_collect=P_harvest*cyc_time;
            t_total=0;
            t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);
            if cyc_time>t
                while cyc_time>t_onecycle % case 3 ��ţ���ϣ�ģ��
                    % ---------------------�ж��Ƿŵ绹�Ƿŵ�--------------------- %
                    if flag==0
                        Solution_1abs=abs(V-Solution_1);
                        [size_m,size_n]=find(Solution_1abs==min(Solution_1abs));%��ǰ��ѹ

                        %��һ�����ת��Ч��
                        Layer1_Trans_Efficiency=Solution_layer1(typical_layer1_size,size_n);
                        %�ڶ������ת��Ч��
                        Layer2_Trans_Efficiency=Solution_layer2(typical_layer2_size,size_n);

                        %time=(Solution_layer1(layer1_rmax,1)+Solution_layer2(layer2_rmax,1))/4*20e-9; % s
                        
                        time_layer1=Solution_layer1(typical_layer1_size,1)/4/(Solution_layer1(typical_layer1_size,5)*Solution_layer1(typical_layer1_size,6))*20e-9;
                        time_layer2=Solution_layer2(typical_layer2_size,1)/4/(Solution_layer2(typical_layer2_size,5)*Solution_layer2(typical_layer2_size,6))*20e-9;

                        time_layer1_tile=Solution_layer1(typical_layer1_size,1)/4*20e-9;
                        time_layer2_tile=Solution_layer2(typical_layer2_size,1)/4*20e-9;
                        
                        %��ǰ����������������
                        %Energy_collect3=((Solution_layer1(layer1_rmax,3)/(0.01*Layer1_Trans_Efficiency))+(Solution_layer2(layer2_rmax,3)/(0.01*Layer2_Trans_Efficiency)))*time;
                        
                        %Energy_consume_layer1=(Solution_layer1(layer1_rmax,3)/(0.01*Layer1_Trans_Efficiency))*time_layer1;
                        %Energy_consume_layer2=(Solution_layer2(layer2_rmax,3)/(0.01*Layer2_Trans_Efficiency))*time_layer2;
                        
                        Energy_consume_layer1_tile=(Solution_layer1(typical_layer1_size,3)/(0.01*Layer1_Trans_Efficiency))*time_layer1_tile;
                        Energy_consume_layer2_tile=(Solution_layer2(typical_layer2_size,3)/(0.01*Layer2_Trans_Efficiency))*time_layer2_tile;
                    
                        if layer1_count==0
                            Max_Energy_consume=Energy_consume_layer1_tile;
                        else
                            Max_Energy_consume=Energy_consume_layer2_tile;
                        end
                        
                        %Max_Energy_consume=max(Energy_consume_layer1,Energy_consume_layer2);

                        if Estore>=Max_Energy_consume
                            if layer1_count==0 && Estore>=Energy_consume_layer1_tile
                                Operand_sum=Operand_sum+(Solution_layer1(typical_layer1_size,4)*Solution_layer1(typical_layer1_size,5)*Solution_layer1(typical_layer1_size,6));
                                Estore=Estore-Energy_consume_layer1_tile;
                                Energy_use=Energy_use+Energy_consume_layer1_tile;
                                count_time=count_time+time_layer1_tile;
                                if (1/2*C*1e-9*0.48*0.48)<(Estore+P_harvest*time_layer1_tile)
                                    Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
                                else
                                    Estore=Estore+P_harvest*time_layer1_tile;
                                end
                                t_onecycle=t_onecycle+time_layer1_tile;
                                count_layer_times=count_layer_times+1*(Solution_layer1(typical_layer1_size,5)*Solution_layer1(typical_layer1_size,6));
                                %�����ж�ִ�е�һ�㻹�ǵڶ���
                                if  layer1_op_times<=count_layer_times
                                    layer1_count=1;
                                    layer2_count=0;
                                    count_layer_times=0;
                                end
                            end
                            if layer2_count==0 && Estore>=Energy_consume_layer2_tile
                                Operand_sum=Operand_sum+(Solution_layer2(typical_layer2_size,4)*Solution_layer2(typical_layer2_size,5)*Solution_layer2(typical_layer2_size,6));
                                Energy_use=Energy_use+Energy_consume_layer2_tile;
                                Estore=Estore-Energy_consume_layer2_tile;
                                if (1/2*C*1e-9*0.48*0.48)<(Estore+P_harvest*time_layer2_tile)
                                    Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
                                else
                                    Estore=Estore+P_harvest*time_layer2_tile;
                                end
                                t_onecycle=t_onecycle+time_layer2_tile;
                                count_time=count_time+time_layer2_tile;
                                count_layer_times=count_layer_times+1*(Solution_layer2(typical_layer2_size,5)*Solution_layer2(typical_layer2_size,6));
                                %�����ж�ִ�е�һ�㻹�ǵڶ���
                                if  layer2_op_times<=count_layer_times
                                    layer1_count=1;
                                    layer2_count=0;
                                    count_layer_times=0;
                                end
                            end
                        elseif  Estore>=(1/2*C*1e-9*0.48*0.48) && Estore<Max_Energy_consume 
                           
                            break;
                        end
                        V_up=sqrt(2*Estore/(C*(1e-9)));
                    else
                        %Estore
                        V_present=sqrt(2*Estore/(C*(1e-9)));
                        t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);%���ʱ��
                        Estore=1/2*C*1e-9*0.48*0.48;
                        V_up=0.48;
                        V_down=0;
                    end
                    % ---------------------     end     --------------------- %
                    V=V_up-V_down;
                    if V>=0.24 && Estore>=Max_Energy_consume %�ŵ��ж�
                        flag=0;
                    else %����ж�
                        flag=1;
                        t_total=t_total+t;
                        t_onecycle=t_onecycle+t;
                        count_time=0;
                    end
                end 
            else
                Operand_sum=0;
                Estore=Estore+P_harvest*cyc_time;
            end
        end
    %--------------------------- case 3 ---------------------------------%
    elseif P_harvest > 0 %ֻ�ܼ�Ъִ�� ִ�з�ʽͬ case 2 ��Ъִ�з�ʽ
        flag=1;
        Energy_collect=P_harvest*cyc_time;
        V_present=sqrt(2*Estore/(C*(1e-9)));
        t_total=0;
        t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);%���ʱ��
        if cyc_time>t
            while cyc_time>t_onecycle % case 3 ��ţ���ϣ�ģ��
                    % ---------------------�ж��Ƿŵ绹�Ƿŵ�--------------------- %
                if flag==0
                    Solution_1abs=abs(V-Solution_1);
                    [size_m,size_n]=find(Solution_1abs==min(Solution_1abs));%��ǰ��ѹ

                    %��һ�����ת��Ч��
                    Layer1_Trans_Efficiency=Solution_layer1(typical_layer1_size,size_n);
                    %�ڶ������ת��Ч��
                    Layer2_Trans_Efficiency=Solution_layer2(typical_layer2_size,size_n);

                    %time=(Solution_layer1(layer1_rmax,1)+Solution_layer2(layer2_rmax,1))/4*20e-9; % s

                    %time_layer1=Solution_layer1(layer1_rmax,1)/4/(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6))*20e-9;
                    %time_layer2=Solution_layer2(layer2_rmax,1)/4/(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6))*20e-9;

                    time_layer1_tile=Solution_layer1(typical_layer1_size,1)/4*20e-9;
                    time_layer2_tile=Solution_layer2(typical_layer2_size,1)/4*20e-9;

                    %��ǰ����������������
                    
                    %Energy_consume_layer1=(Solution_layer1(layer1_rmax,3)/(0.01*Layer1_Trans_Efficiency))*time_layer1;
                    %Energy_consume_layer2=(Solution_layer2(layer2_rmax,3)/(0.01*Layer2_Trans_Efficiency))*time_layer2;

                    Energy_consume_layer1_tile=(Solution_layer1(typical_layer1_size,3)/(0.01*Layer1_Trans_Efficiency))*time_layer1_tile;
                    Energy_consume_layer2_tile=(Solution_layer2(typical_layer2_size,3)/(0.01*Layer2_Trans_Efficiency))*time_layer2_tile;

                    if layer1_count==0
                        Max_Energy_consume=Energy_consume_layer1_tile;
                    else
                        Max_Energy_consume=Energy_consume_layer2_tile;
                    end

                    %Max_Energy_consume=max(Energy_consume_layer1,Energy_consume_layer2);

                    if Estore>=Max_Energy_consume
                        if layer1_count==0 && Estore>=Energy_consume_layer1_tile
                            Operand_sum=Operand_sum+(Solution_layer1(typical_layer1_size,4)*Solution_layer1(typical_layer1_size,5)*Solution_layer1(typical_layer1_size,6));
                            Estore=Estore-Energy_consume_layer1_tile;
                            Energy_use=Energy_use+Energy_consume_layer1_tile;
                            count_time=count_time+time_layer1_tile;
                            if (1/2*C*1e-9*0.48*0.48)<(Estore+P_harvest*time_layer1_tile)
                                Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
                            else
                                Estore=Estore+P_harvest*time_layer1_tile;
                            end
                            t_onecycle=t_onecycle+time_layer1_tile;
                            count_layer_times=count_layer_times+1*(Solution_layer1(typical_layer1_size,5)*Solution_layer1(typical_layer1_size,6));
                            %�����ж�ִ�е�һ�㻹�ǵڶ���
                            if  layer1_op_times<=count_layer_times
                                layer1_count=1;
                                layer2_count=0;
                                count_layer_times=0;
                            end
                        end
                        if layer2_count==0 && Estore>=Energy_consume_layer2_tile
                            Operand_sum=Operand_sum+(Solution_layer2(typical_layer2_size,4)*Solution_layer2(typical_layer2_size,5)*Solution_layer2(typical_layer2_size,6));
                            Energy_use=Energy_use+Energy_consume_layer2_tile;
                            Estore=Estore-Energy_consume_layer2_tile;
                            if (1/2*C*1e-9*0.48*0.48)<(Estore+P_harvest*time_layer2_tile)
                                Estore=1/2*C*1e-9*0.48*0.48;%�߷ű߳�
                            else
                                Estore=Estore+P_harvest*time_layer2_tile;
                            end
                            t_onecycle=t_onecycle+time_layer2_tile;
                            count_time=count_time+time_layer2_tile;
                            count_layer_times=count_layer_times+1*(Solution_layer2(typical_layer2_size,5)*Solution_layer2(typical_layer2_size,6));
                            %�����ж�ִ�е�һ�㻹�ǵڶ���
                            if  layer2_op_times<=count_layer_times
                                layer1_count=1;
                                layer2_count=0;
                                count_layer_times=0;
                            end
                        end
                    elseif  Estore>=(1/2*C*1e-9*0.48*0.48) && Estore<Max_Energy_consume 
                        Operand_sum=0;
                        Energy_use=0;
                        break;
                    end
                    V_up=sqrt(2*Estore/(C*(1e-9)));
                else
                    %Estore
                    V_present=sqrt(2*Estore/(C*(1e-9)));
                    t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);%���ʱ��
                    Estore=1/2*C*1e-9*0.48*0.48;
                    V_up=0.48;
                    V_down=0;
                end
                % ---------------------     end     --------------------- %
                V=V_up-V_down;
                if V>=0.24 && Estore>=Max_Energy_consume %�ŵ��ж�
                    flag=0;
                else %����ж�
                    flag=1;
                    t_total=t_total+t;
                    t_onecycle=t_onecycle+t;
                    count_time=0;
                end
            end 
        else
            Operand_sum=0;
            Energy_use=0;
            Estore=Estore+P_harvest*cyc_time;
        end   
    end
    %--------------------------- case 3 end ------------------------------%

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
        E_use_sum=E_use_sum+Energy_use;
        E_collect_sum=E_collect_sum+Energy_collect;
        All_Operand_sum=All_Operand_sum+Operand_sum;
    end
end

Energy_efficiency_final=All_Operand_sum/E_collect_sum;
Throughput_efficiency_final=All_Operand_sum/(cyc_time*m_ph);
Esum_uti=E_use_sum/E_collect_sum;
%Throughtput_average=All_Operand_sum/(cyc_time*m_ph);
%Energy_Effi_average=All_Operand_sum/E_use_sum;

Out(:,1)=Power_harvest(:,1);
Out(:,2)=Energy_efficiency;
Out(:,3)=Throughput_efficiency;
Out(:,4)=Energy_utilization;

%csvwrite('Typ3_fr_Pizeo.csv',Out);
csvwrite('Typ3_fr_TV-RF.csv',Out);
%csvwrite('Typ3_fr_Thermal.csv',Out);
%csvwrite('Typ3_fr_WiFi-home.csv',Out);

% xlswrite('result_lenet.xls',Power_harvest(:,1),sheet1,'A2');
% xlswrite('result_lenet.xls',Energy_efficiency,sheet1,'B2');
% xlswrite('result_lenet.xls',Throughput_efficiency,sheet1,'C2');
% xlswrite('result_lenet.xls',Energy_utilization,sheet1,'D2');