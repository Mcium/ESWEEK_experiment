%----------------------四种能量：Piezo TV-RF  Thermal WiFi-home----------------------% 
%读取power trace文件

Power_harvest1=xlsread('E:\matlab\ICCAD\energy\Piezo.xlsx');% power trace read
Power_harvest=Power_harvest1(:,1);%注意power trace文件采集功率所在列可能不同

% Power_harvest1=xlsread('E:\matlab\ICCAD\energy\TV-RF.xlsx');
% Power_harvest=Power_harvest1(1:900,1);%注意power trace文件采集功率所在列可能不同

% Power_harvest1=xlsread('E:\matlab\ICCAD\energy\Thermal.xlsx');
% Power_harvest=Power_harvest1(:,1);%注意power trace文件采集功率所在列可能不同

%Power_harvest1=xlsread('E:\matlab\ICCAD\energy\WiFi-home.xlsx');
%Power_harvest=Power_harvest1(1:100,4);%注意power trace文件采集功率所在列可能不同

%----不同能量的采样周期不一样，需要手动修改----%
cyc_time=0.0001; % piezo采样周期
% cyc_time=0.1; % TV-RF采样周期
%cyc_time=0.2; % Thermal采样周期
%cyc_time=0.2; % WiFi-home采样周期
%----不同能量的采样周期不一样，需要手动修改----%

%----------------------end 四种能量：Piezo TV-RF  Thermal WiFi-home------------------------% 

%------------------------------2层网络 每层的tile size和相关参数---------------------------------%

%----------------------------FR每层的tile size文件读取---------------------------%
%---（由于四种能量的能量水平不一致，因此同一网络对应每种能量采用的tile size不同）---%

% Solution=xlsread('E:\matlab\ICCAD\networks\fr-piezo-max-2.xlsx');
% % Solution=xlsread('E:\matlab\ICCAD\networks\fr-TVRF-max.xlsx');
% % Solution=xlsread('E:\matlab\ICCAD\networks\fr-thermal-max.xlsx');
% % Solution=xlsread('E:\matlab\ICCAD\networks\fr-WifiHome.xlsx');
% % -----------------------------end FR每层的tile size文件读取-----------------------%
% 
% % Power_Level=Solution(2:11,7);
% 
% %--------------------------FR网络卷积参数------------------------%
% FR_Conv1=[4,28,28];
% FR_Conv2=[16,10,10];
% 
% %tile size为25x1x1时，第一层执行的次数(最小激活size 时钟周期 4cycles)
% layer1_op_times=FR_Conv1(1)*FR_Conv1(2)*FR_Conv1(3);
% %tile size为64x1x1时，第二层执行的次数(最小激活size 时钟周期 12cycles)
% layer2_op_times=FR_Conv2(1)*FR_Conv2(2)*FR_Conv2(3);
% 
% %FR-piezo读取每一层的tile size参数
% Solution_layer1=Solution(1:61,:);%第一层tile size
% Solution_layer2=Solution(62:91,:);%第二层tile size
% %FR-TVRF读取每一层的tile size参数
% % Solution_layer1=Solution(1:341,:);%第一层tile size
% % Solution_layer2=Solution(342:471,:);%第二层tile size
% %FR-thermal读取每一层的tile size参数
% % Solution_layer1=Solution(1:141,:);%第一层tile size
% % Solution_layer2=Solution(142:201,:);%第二层tile size
% %----------------------------end  FR每层的tile size和相关参数-------------------------------%

% Solution=xlsread('E:\matlab\ICCAD\networks\lenet-piezo-max-2.xlsx');
% % Solution=xlsread('E:\matlab\ICCAD\networks\lenet-TVRF-max.xlsx');
% %------------LeNet网络参数-------------%
% LeNet_Conv1=[6,28,28];
% LeNet_Conv2=[16,10,10];
% 
% %tile size为25x1x1时，第一层执行的次数
% layer1_op_times=LeNet_Conv1(1)*LeNet_Conv1(2)*LeNet_Conv1(3);
% %tile size为150x1x1时，第二层执行的次数
% layer2_op_times=LeNet_Conv2(1)*LeNet_Conv2(2)*LeNet_Conv2(3);
% 
% %LeNet-piezo读取每一层的tile size参数
% Solution_layer1=Solution(1:61,:);%第一层tile size
% Solution_layer2=Solution(62:81,:);%第二层tile size
% %LeNet-TVRF读取每一层的tile size参数
% % Solution_layer1=Solution(1:381,:);%第一层tile size
% % Solution_layer2=Solution(382:471,:);%第二层tile size
% %LeNet-thermal读取每一层的tile size参数
% %Solution_layer1=Solution(1:15,:);%第一层tile size
% %Solution_layer2=Solution(16:21,:);%第二层tile size
% 
% %---------end LeNet网络参数-----------%
% 
%-------------------HG网络参数--------------------%
%HG
 Solution=xlsread('E:\matlab\ICCAD\networks\hg-piezo-max-2.xlsx');
%Solution=xlsread('E:\matlab\ICCAD\networks\lenet-TVRF-max.xlsx');
%------------HG网络参数-------------%
HG_Conv1=[6,24,24];
HG_Conv2=[12,8,8];

%tile size为25x1x1时，第一层执行的次数
layer1_op_times=HG_Conv1(1)*HG_Conv1(2)*HG_Conv1(3);
%tile size为150x1x1时，第二层执行的次数
layer2_op_times=HG_Conv2(1)*HG_Conv2(2)*HG_Conv2(3);
%LeNet-piezo读取每一层的tile size参数
Solution_layer1=Solution(1:71,:);%第一层tile size
Solution_layer2=Solution(72:111,:);%第二层tile size
% Solution_layer1=Solution(1:391,:);%第一层tile size
% Solution_layer2=Solution(392:561,:);%第二层tile size

%--------------end HG网络参数----------------%

%每一层tile size的个数
Size_Solution_layer1=size(Solution_layer1);
Size_Solution_layer2=size(Solution_layer2);

%所求参数
Solution_1=Solution(1,:);%输入电压
[m_ph,n_ph]=size(Power_harvest);
Energy_efficiency=zeros(m_ph,1); %能效
Throughput_efficiency=zeros(m_ph,1); %吞吐率
Energy_utilization=zeros(m_ph,1); %能量利用率
Out=zeros(m_ph,4);

C=0.47; %电容

Power_search_layer1=Solution_layer1(:,3);%第一层tile size的功率
Power_search_layer2=Solution_layer2(:,3);%第二层tile size的功率

%最大size的位置
[layer1_rmax,layer1_cmax]=size(Solution_layer1);%第一层
[layer2_rmax,layer2_cmax]=size(Solution_layer2);%第二层

%-----FR 查询最大功率对应的最小转换效率和最小功率对应的最大转换效率,对于不同网络，该参数需要手动修改-----%
%----------------------------------------用于判断三种情况的参数---------------------------%
Psl_layer1=Solution_layer1(2,3)/(0.01*max(Solution_layer1(2,8:+2:57)));
Psl_layer2=Solution_layer2(1,3)/(0.01*max(Solution_layer2(1,8:+2:57)));
Psl=max(Psl_layer1,Psl_layer2); %min 最小size对应最好的转换效率的功率

Pll_layer1=Solution_layer1(layer1_rmax,3)/(0.01*min(Solution_layer1(layer1_rmax,8:+2:57)));
Pll_layer2=Solution_layer2(layer2_rmax,3)/(0.01*min(Solution_layer2(layer2_rmax,8:+2:57)));
Pll=max(Pll_layer1,Pll_layer2); %max 最大size对应最差的转换效率的功率

%----------------------------------------用于判断三种情况的参数---------------------------%

%统计所有结果总和
All_Operand_sum=0;
E_use_sum=0;
E_collect_sum=0;

V=0;%电容当前电压
Estore=0;%电容存储的能量，全局

%用于判断执行到哪一层
layer1_count=0;
layer2_count=1;
count_layer_times=0;
%---------------------------遍历power trace文件 执行模拟过程-----------------------------%
for i=1:m_ph
    
    P_harvest=Power_harvest(i,1)*1e-6; % 当前cycle的Pload 单位W
    test_cnt=1;
    Cycle_cnt=0;
    Operand_sum=0;
    Energy_use=0;
    Energy_collect=0;
    V_present=0;
    V_down=0;
    V_up=0;
    %间歇执行需要的参数
    Energy_collect_i=0;
    Energy_collect_i1=0;
    Operand_sum_i=0;
    Operand_sum_i1=0;
    Energy_use_i=0;
    Throughput_i=0;
    Energy_use_i1=0;
    Throughput_i1=0;
    %连续执行需要的参数
    Energy_collect_c=0;
    Operand_sum_c=0;
    Energy_use_c=0;
    Throughput_c=0;
    t=0;%充电时间
    t_count=0;%一个cycle的充电次数
    time=0;%执行时间
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
    
    %当前cycle 能级判断
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

%     %当前cycle 能级判断 TVRF
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
% %当前cycle 能级判断 Thermal
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
    %------------------------- case 1 最大size 连续执行-------------------------%
    if P_harvest >= Pll % 
        %[layer1_rmax,layer1_cmax]=size(Solution_layer1);%第一层最大的行和列
        %[layer2_rmax,layer2_cmax]=size(Solution_layer2);
        
        %Cycle_cnt_time=(layer1_op_times*(Solution_layer1(layer1_rmax,1)/4/(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6)))+...
        %(layer2_op_times*Solution_layer2(layer2_rmax,1)/4/(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6))))*20e-9;%执行一次需要的时间
        %op_cycle=cyc_time/Cycle_cnt_time;%一个power cycle两层顺序执行的次数
        
        %第一层+第二层最大激活方案的操作数
        %Operand_sum=(Solution_layer1(layer1_rmax,4)*Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6)...
        % +Solution_layer2(layer2_rmax,4)*Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6))*op_cycle;
         
        %time_layer1=layer1_op_times*Solution_layer1(layer1_rmax,1)/4/(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6))*20e-9;
        %time_layer2=layer2_op_times*Solution_layer2(layer2_rmax,1)/4/(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6))*20e-9;
        
        %选中的Tile size的时钟周期
        time_layer1_tile=Solution_layer1(layer1_rmax,1)/4*20e-9;
        time_layer2_tile=Solution_layer2(layer2_rmax,1)/4*20e-9;
        while cyc_time>t_onecycle
            %第一层
            if layer1_count==0 %第一层执行条件
                Operand_sum=Operand_sum+(Solution_layer1(layer1_rmax,4)*Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6));

                count_time=count_time+time_layer1_tile;
                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer1_tile)
                    Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                else
                    Estore=Estore+P_harvest*time_layer1_tile;
                end
                t_onecycle=t_onecycle+time_layer1_tile;
                count_layer_times=count_layer_times+1*(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6));
                %用于判断执行第一层还是第二层
                if  layer1_op_times<=count_layer_times
                    layer1_count=1;
                    layer2_count=0;
                    count_layer_times=0;
                end
            end
            %第二层
            if layer2_count==0 %第二层执行条件
                Operand_sum=Operand_sum+(Solution_layer2(layer2_rmax,4)*Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6));   
                count_time=count_time+time_layer2_tile;
                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer2_tile)
                    Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                else
                    Estore=Estore+P_harvest*time_layer2_tile;
                end
                t_onecycle=t_onecycle+time_layer2_tile;
                count_layer_times=count_layer_times+1*(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6));
                %用于判断执行第一层还是第二层
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
        
%     %-------------------------case 2  连续执行或间歇执行 选择吞吐率执行方式较高的-----------------------------%
%     elseif P_harvest >= Psl % 充放（间断）模型
%         
%         %-------------------------case 2 连续运行的最大size-------------------------%
%         %根据功率选择可以连续执行的tile size
%         %P_layer1=find(Power_search_layer1<=(P_harvest*0.595382245764776));%第一层可以激活功率
%         %P_layer2=find(Power_search_layer2<=(P_harvest*0.641726047596523));%第二层可以激活功率
%         
%         %------------第一层可以激活的最大Tile size------------%
%         for m=Size_Solution_layer1(1,1):-1:2
%             Sizem_Effi=min(min(Solution_layer1(m,7:52)))*0.01;
%             if Power_search_layer1(m,1)/Sizem_Effi<P_harvest
%                 P_layer1=m;
%                 break;
%             end
%         end
%         %------------第二层可以激活的最大Tile size-------------%
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
%         %--------------------------case 2 间歇执行--------------------------%
%          %------根据功率选择不可以连续执行的tile size-----------%
%          if P_layer1==0 || P_layer2==0
%              P_layer1=0;
%              P_layer2=0;
%          end
%          %case2 间歇执行的size
%          P_layer1i=zeros(Size_Solution_layer1(1,1)-P_layer1(1,1),1);
%          P_layer2i=zeros(Size_Solution_layer2(1,1)-P_layer2(1,1),1);
%          x=0;    
%          for m=P_layer1(1,1)+1:Size_Solution_layer1(1,1)
%             x=x+1;
%             P_layer1i(x,1)=P_layer1(1,1)+x;%第一层不可以激活功率
%          end
%           y=0;
%          for n=P_layer2(1,1)+1:Size_Solution_layer2(1,1)
%             y=y+1;
%             P_layer2i(y,1)=P_layer2(1,1)+y;%第二层不可以激活功率
%          end
%             
%         [P_layer1_ri,P_layer1_ci]=size(P_layer1i);
%         [P_layer2_ri,P_layer2_ci]=size(P_layer2i);
%         Solution_layer1i=Solution_layer1(P_layer1i,:);%第一层不能激活的所有size
%         Solution_layer2i=Solution_layer2(P_layer2i,:);%第二层不能激活的所有size
%         %------根据功率选择不可以连续执行的tile size-----------%
%         
%         %[layer1_rmax,layer1_cmax]=size(Solution_layer1);%第一层最大的行和列
%         %[layer2_rmax,layer2_cmax]=size(Solution_layer2);
%         
%         %没有不能激活的size
%         if P_layer1_ri==0
%             Solution_layer1i=Solution_layer1(layer1_rmax,:); 
%         end
%         
%         if P_layer2_ri==0 
%             Solution_layer2i=Solution_layer2(layer2_rmax,:);
%         end
%         
%         %------------------开始间歇执行----------------------%
%         flag=1; %充电和放电判断参数
%         count_time=0; %执行时间
%         flag_size=0;
%        
%         layer1_trans_r=0;
%         layer2_trans_r=0;
%         Layer1_eta=0;
%         Layer2_eta=0;
%         t_onecycle=0; %充电时间+执行时间
%         charge_flag=0;%一个cycle第一次
%         t_total=0; %一个power cycle充电时间总和
%         %间歇执行采集的能量
%         Energy_collect_i=P_harvest*cyc_time;
%         V_present=sqrt(2*Estore/(C*(1e-9)));%当前电容的电压值
%         t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);%充电时间
%         working_cycle_time1=0;
% 
%         working_cycle_time2=0;
%         working_cycle_ops_i=0;
%         
%         if cyc_time>t %如果充电时间大于采样时间，则进入下一个power cacle
%             while cyc_time>t_onecycle % 如果充放电时间超过采样时间，则进入下一个power cacle
%                 % ---------------------判定是放电还是放电--------------------- %
%                 if flag==0
%                     Solution_1abs=abs(V-Solution_1);
%                     [size_m,size_n]=find(Solution_1abs==min(Solution_1abs));%当前电压与转换效率表最接近的电压
% 
%                     Solution_layer1Effi=Solution_layer1i(:,size_n);%当前电压第一层对应的转换效率
%                     Solution_layer2Effi=Solution_layer2i(:,size_n);%当前电压第二层对应的转换效率
%         
%                     %第一层最佳转换效率
%                     Layer1_Trans_Efficiency=max(Solution_layer1Effi);
%                     %第二层最佳转换效率
%                     Layer2_Trans_Efficiency=max(Solution_layer2Effi);
%                     %获取行位置
%                     [layer1_trans_r,layer1_trans_c]=find(Solution_layer1Effi== Layer1_Trans_Efficiency);
%                     [layer2_trans_r,layer2_trans_c]=find(Solution_layer2Effi== Layer2_Trans_Efficiency);
%                     layer1_trans_r=max(layer1_trans_r);
%                     %time_layer1=layer1_op_times*Solution_layer1i(layer1_trans_r,1)/4/(Solution_layer1i(layer1_trans_r,5)*Solution_layer1i(layer1_trans_r,6))*20e-9;
%                     %time_layer2=layer2_op_times*Solution_layer2i(layer2_trans_r,1)/4/(Solution_layer2i(layer2_trans_r,5)*Solution_layer2i(layer2_trans_r,6))*20e-9;
%                     
%                     time_layer1_tile=Solution_layer1i(layer1_trans_r,1)/4*20e-9;
%                     time_layer2_tile=Solution_layer2i(layer2_trans_r,1)/4*20e-9;
%                     
%                     %每一层的能量消耗
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
%                     if  Estore>=Max_Energy_consume %至少可以执行一层
%                         %第一层
%                         if layer1_count==0 && Estore>=Energy_consume_layer1_tile %第一层执行条件
%                             Operand_sum_i=Operand_sum_i+(Solution_layer1i(layer1_trans_r,4)*Solution_layer1i(layer1_trans_r,5)*Solution_layer1i(layer1_trans_r,6));
%                             Energy_use_i=Energy_use_i+Energy_consume_layer1_tile;
%                             %执行第一层后电容剩余能量
%                             Estore=Estore-Energy_consume_layer1_tile;
%                             count_time=count_time+time_layer1_tile;
%                             if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer1_tile)
%                                 Estore=1/2*C*1e-9*0.48*0.48;%边放边充
%                             else
%                                 Estore=Estore+P_harvest*time_layer1_tile;
%                             end
%                             if charge_flag==1
%                                 working_cycle_time2=working_cycle_time2+time_layer1_tile;
%                                 working_cycle_ops_i=working_cycle_ops_i+(Solution_layer1i(layer1_trans_r,4)*Solution_layer1i(layer1_trans_r,5)*Solution_layer1i(layer1_trans_r,6));
%                             end
%                             t_onecycle=t_onecycle+time_layer1_tile;
%                             count_layer_times=count_layer_times+1*(Solution_layer1i(layer1_trans_r,5)*Solution_layer1i(layer1_trans_r,6));
%                             %用于判断执行第一层还是第二层
%                             if  layer1_op_times<=count_layer_times
%                                 layer1_count=1;
%                                 layer2_count=0;
%                                 count_layer_times=0;
%                             end
%                         end
%                         %第二层
%                         if layer2_count==0 && Estore>=Energy_consume_layer2_tile %第二层执行条件
%                             Operand_sum_i=Operand_sum_i+(Solution_layer2i(layer2_trans_r,4)*Solution_layer2i(layer2_trans_r,5)*Solution_layer2i(layer2_trans_r,6));
%                             Energy_use_i=Energy_use_i+Energy_consume_layer2_tile;
%                             %执行第二层后电容剩余能量
%                             Estore=Estore-Energy_consume_layer2_tile;   
%                             if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer2_tile)
%                                 Estore=1/2*C*1e-9*0.48*0.48;%边放边充
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
%                             %用于判断执行第一层还是第二层
%                             if  layer2_op_times<=count_layer_times
%                                 layer1_count=0;
%                                 layer2_count=1;
%                                 count_layer_times=0;
%                             end
%                         end 
%                     elseif  Estore==(1/2*C*1e-9*0.48*0.48) && Estore<Max_Energy_consume %电容最大容量不够支持一层运行
%                         break;
%                     end
%                     V_up=sqrt(2*Estore/(C*(1e-9)));
%                 else %充电
%                     if Estore<1/2*C*1e-9*0.48*0.48
%                         V_present=sqrt(2*Estore/(C*(1e-9)));
%                         t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);%充电时间
%                         Estore=1/2*C*1e-9*0.48*0.48;%充电之后电容存储的能量
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
%                 % --------------------- 充电和放电 end  --------------------- %
%                 V=V_up-V_down;
%                 %执行一次放电后判断是否继续放电或者执行充电
%                 if V>=0.255 && Estore>=Max_Energy_consume %放电判定
%                     flag=0; 
%                 else %充电判定
%                     flag=1;
%                     t_total=t_total+t;%一个power cycle充电时间总和
%                     t_onecycle=t_onecycle+t;%一个power cycle充电时间和执行时间总和，超过采样周期时，进入下一个power cycle
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
%         Throughput_i=Operand_sum_i/cyc_time;%间歇执行吞吐率
%         %------------------case 2 end 间歇执行----------------------%
%         %---------------------------间歇执行 end------------------------%
%         
%         %------------------------- case2 连续执行--------------------------%
%         %当前power cycle功率不满足最小size的激活功率，不能连续执行
%         if P_layer1==0 || P_layer2==0
%             Operand_sum_c=0;
%             Energy_use_c=0;
%             Energy_collect_c=P_harvest*cyc_time;
%             Throughput_c=0;%连续执行的吞吐率
%             working_cycle_ops_c=0;
%         %选择可以支持连续执行的最大size
%         else
%             %可以连续执行的最大的tile size
%             Pmax_rpos1=P_layer1;
%             Pmax_rpos2=P_layer2;
%             
%             %Cycle_cnt_time=layer1_op_times*(Solution_layer1(Pmax_rpos1,1)/4/(Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6))+layer2_op_times*Solution_layer2(Pmax_rpos2,1)/4/(Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6)))*20e-9;
%             %op_cycle=cyc_time/Cycle_cnt_time;
%             %第一层+第二层最大激活方案的操作数
%             %Operand_sum_c=(Solution_layer1(Pmax_rpos1,4)*Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6)...
%             %+Solution_layer2(Pmax_rpos2,4)*Solution_layer2(Pmax_rpos2,5)*Solution_layer2(Pmax_rpos2,6))*op_cycle;
%             
%             %time_layer1=layer1_op_times*Solution_layer1(Pmax_rpos1,1)/4/(Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6))*20e-9;
%             %time_layer2=layer2_op_times*Solution_layer2(Pmax_rpos2,1)/4/(Solution_layer2(Pmax_rpos2,5)*Solution_layer2(Pmax_rpos2,6))*20e-9;
% 
%             time_layer1_tile=Solution_layer1(Pmax_rpos1,1)/4*20e-9;
%             time_layer2_tile=Solution_layer2(Pmax_rpos2,1)/4*20e-9;
%             while cyc_time>t_onecycle
%                 %第一层
%                 if layer1_count==0 %第一层执行条件
%                     Operand_sum_c=Operand_sum_c+(Solution_layer1(Pmax_rpos1,4)*Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6));
%                     count_time=count_time+time_layer1_tile;
%                     if working_cycle_time>count_time
%                         working_cycle_ops_c=working_cycle_ops_c+(Solution_layer1(Pmax_rpos1,4)*Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6));
%                     end
%                     if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer1_tile)
%                         Estore=1/2*C*1e-9*0.48*0.48;%边放边充
%                     else
%                         Estore=Estore+P_harvest*time_layer1_tile;
%                     end
%                     t_onecycle=t_onecycle+time_layer1_tile;
%                     count_layer_times=count_layer_times+1*(Solution_layer1(Pmax_rpos1,5)*Solution_layer1(Pmax_rpos1,6));
%                     %用于判断执行第一层还是第二层
%                     if  layer1_op_times<=count_layer_times
%                         layer1_count=1;
%                         layer2_count=0;
%                         count_layer_times=0;
%                     end
%                 end
%                 %第二层
%                 if layer2_count==0 %第二层执行条件
%                     Operand_sum_c=Operand_sum_c+(Solution_layer2(Pmax_rpos2,4)*Solution_layer2(Pmax_rpos2,5)*Solution_layer2(Pmax_rpos2,6));
%                     count_time=count_time+time_layer2_tile;
%                     if working_cycle_time>=count_time
%                         working_cycle_ops_c=working_cycle_ops_c+(Solution_layer2(Pmax_rpos2,4)*Solution_layer2(Pmax_rpos2,5)*Solution_layer2(Pmax_rpos2,6));
%                     end 
%                     if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer2_tile)
%                         Estore=1/2*C*1e-9*0.48*0.48;%边放边充
%                     else
%                         Estore=Estore+P_harvest*time_layer2_tile;
%                     end
%                     t_onecycle=t_onecycle+time_layer2_tile;
%                     count_layer_times=count_layer_times+1*(Solution_layer2(Pmax_rpos2,5)*Solution_layer2(Pmax_rpos2,6));
%                     %用于判断执行第一层还是第二层
%                     if  layer2_op_times<=count_layer_times
%                         layer1_count=0;
%                         layer2_count=1;
%                         count_layer_times=0;
%                     end
%                 end 
%             end
%             Energy_use_c=((Solution_layer1(Pmax_rpos1,3)+Solution_layer2(Pmax_rpos2,3))*cyc_time)/2;
%             %case2 连续执行采集的能量
%             Energy_collect_c=P_harvest*cyc_time;
%             %case2 连续执行的吞吐率
%             Throughput_c=Operand_sum_c/cyc_time;
%         end
%         Energy_Effi_c=working_cycle_ops_c/(P_harvest*working_cycle_time);
%         %------------------------连续执行end-----------------------%
%         
%         %-----case 2 根据吞吐率选择执行方式-----%
%         if Energy_Effi_c>=Energy_Effi_i || Energy_Effi_i==0% 选择连续执行
%             Operand_sum=Operand_sum_c;
%             Energy_use=Energy_use_c;
%             Energy_collect=Energy_collect_c; 
%         elseif Energy_Effi_c<Energy_Effi_i% 选择间歇执行
%             Energy_collect=Energy_collect_i;
%             Operand_sum=Operand_sum_i;
%             Energy_use=Energy_use_i;
%         end
%         % ----case 2 根据吞吐率选择执行方式 end-----%
%     %--------------------------------- case 2 end -----------------------------------%
            
    %--------------------------- case 3 只能间歇执行---------------------------------%
    elseif P_harvest > 0 % 执行方式同 case 2 间歇执行方式
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
        count_time=0; %执行时间
        t_onecycle=0;
        layer1_trans_r=0;
        layer2_trans_r=0;
        V_present=sqrt(2*Estore/(C*(1e-9)));
        t_total=0;
        t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);

        if cyc_time>t
            while cyc_time>t_onecycle  % case 3 充放（间断）模型
                % ---------------------判定是放电还是充放一起--------------------- %
                if flag==0
                    Solution_1abs=abs(V-Solution_1);
                    [size_2m,size_2n]=find(Solution_1abs==min(Solution_1abs));%当前电压
                    size_n=size_2n(1,1);
                    %选择当前能级 和 当前电压对应的所有Tile size的吞吐率
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
                    %一开始选择size
                    if eta1_flag==0
                        Layer1_Trans_Efficiency=Pl_Layer1_Tile_Thr(Layer1_max_idx,3);
                        
                        Layer1_eta_last=Layer1_Trans_Efficiency;
        
                        layer1_trans_r=Pl_Layer1_Tile_Thr(Layer1_max_idx,2);%取到最佳size的行位置
                        eta1_flag=1;
                        
                    end
                    if eta2_flag==0
                        Layer2_Trans_Efficiency=Pl_Layer2_Tile_Thr(Layer2_max_idx,3);
                        
                        Layer2_eta_last=Layer2_Trans_Efficiency;
                        layer2_trans_r=Pl_Layer2_Tile_Thr(Layer2_max_idx,2);%取到最佳size的行位置
                        eta2_flag=1;
                    end
                    %切换size条件
                    if  Layer1_eta_last >Layer1_eta
                        Layer1_Trans_Efficiency=Pl_Layer1_Tile_Thr(Layer1_max_idx,3);
                        layer1_trans_r=Pl_Layer1_Tile_Thr(Layer1_max_idx,2);%取到最佳size的行位置
                        
                    else
                        Layer1_eta_last=Layer1_eta;
                    end
                    
                    if  Layer2_eta_last >Layer2_eta
                        Layer2_Trans_Efficiency=Pl_Layer2_Tile_Thr(Layer2_max_idx,3);
                        layer2_trans_r=Pl_Layer2_Tile_Thr(Layer2_max_idx,2);%取到最佳size的行位置
                        
                    else
                        Layer2_eta_last=Layer2_eta;
                    end
%                     Solution_layer1Effi=Solution_layer1(:,size_n);%当前电压第一层对应的转换效率
%                     Solution_layer2Effi=Solution_layer2(:,size_n);%当前电压第二层对应的转换效率

%                     %第一层最佳转换效率
%                     Layer1_Trans_Efficiency=max(Solution_layer1Effi);
%                     %第二层最佳转换效率
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
                    
                    if Estore>=Max_Energy_consume %电容的存储的能量可以至少执行一层网络
                        if layer1_count==0 && Estore>=Energy_consume_layer1_tile
                            Operand_sum=Operand_sum+(Solution_layer1(layer1_trans_r,4)*Solution_layer1(layer1_trans_r,5)*Solution_layer1(layer1_trans_r,6));
                            Energy_use=Energy_use+Energy_consume_layer1_tile;
                            Estore=Estore-Energy_consume_layer1_tile;
                            count_time=count_time+time_layer1_tile;
                            if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer1_tile)
                                Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                            else
                                Estore=Estore+P_harvest*time_layer1_tile;
                            end
                            t_onecycle=t_onecycle+time_layer1_tile;
                            count_time= count_time+time_layer1_tile;
                            count_layer_times=count_layer_times+1*(Solution_layer1(layer1_trans_r,5)*Solution_layer1(layer1_trans_r,6));
                            %用于判断执行第一层还是第二层
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
                                Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                            else
                                Estore=Estore+P_harvest*time_layer2_tile;
                            end
                            t_onecycle=t_onecycle+time_layer2_tile;
                            count_time= count_time+time_layer2_tile;
                           count_layer_times=count_layer_times+1*(Solution_layer2(layer2_trans_r,5)*Solution_layer2(layer2_trans_r,6));
                            %用于判断执行第一层还是第二层
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

                else %充电
                    V_present=sqrt(2*Estore/(C*(1e-9)));
                    t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);%充电时间
                    Estore=1/2*C*1e-9*0.48*0.48;%充电到0.48V电容的能量 
                    V_up=0.48;
                    V_down=0;
                end
                % --------------------- 充放电 end     --------------------- %
                V=V_up-V_down;
                if V>=0.255 && Estore>=Max_Energy_consume %放电判定
                    flag=0;
                else %充电判定
                    flag=1;
                    t_total=t_total+t;%一个power cycle充电时间总和
                    t_onecycle=t_onecycle+t;%一个power cycle充电时间和执行时间总和
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
    
    %-------计算机一个cycle的能效，吞吐率，能量利用率-------%
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
    %-------计算机一个cycle的能效，吞吐率，能量利用率 end-------%
end

%--------遍历power trace end--------%
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

%修改导出文件的文件名
%csvwrite('Maxt3_FR_Piezo222.csv',Out);
%csvwrite('Maxt3_FR_TV-RF222.csv',Out);
%csvwrite('Maxt3_FR_Thermal.csv',Out);
%csvwrite('Maxt3_FR_Wifi-home.csv',Out);

% xlswrite('result_lenet.xls',Power_harvest(:,1),sheet1,'A2');
% xlswrite('result_lenet.xls',Energy_efficiency,sheet1,'B2');
% xlswrite('result_lenet.xls',Throughput_efficiency,sheet1,'C2');
% xlswrite('result_lenet.xls',Energy_utilization,sheet1,'D2');