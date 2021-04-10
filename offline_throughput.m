%���߼���������

cyc_time=0.1; % piezo��������
%����ֵ
C=10;
%tile size,V,eta
Solution=xlsread('E:\matlab\ICCAD\networks\fr-TVRF-tt.xlsx');
%Solution=xlsread('E:\matlab\ICCAD\networks\tv-rf\hg-TVRF-tt.xlsx');
%Solution=xlsread('E:\matlab\ICCAD\networks\pv-Thermal-tt.xlsx');

V_pos=31;   %7-31
%�ܼ����ܼ��������
Power_level=zeros(10,2);
%piezo
% Power_level(1,1)=1;
% Power_level(1,2)=1;
% 
% Power_level(2,1)=2;
% Power_level(2,2)=100;
% 
% Power_level(3,1)=3;
% Power_level(3,2)=200;
% 
% Power_level(4,1)=4;
% Power_level(4,2)=300;
% 
% Power_level(5,1)=5;
% Power_level(5,2)=400;
% 
% Power_level(6,1)=6;
% Power_level(6,2)=500;
% 
% Power_level(7,1)=7;
% Power_level(7,2)=600;
% 
% Power_level(8,1)=8;
% Power_level(8,2)=700;
% 
% Power_level(9,1)=9;
% Power_level(9,2)=800;
% 
% Power_level(10,1)=10;
% Power_level(10,2)=900;

%tvrf
Power_level(1,1)=1;
Power_level(1,2)=1;

Power_level(2,1)=2;
Power_level(2,2)=2000;

Power_level(3,1)=3;
Power_level(3,2)=4000;

Power_level(4,1)=4;
Power_level(4,2)=6000;

Power_level(5,1)=5;
Power_level(5,2)=8000;

Power_level(6,1)=6;
Power_level(6,2)=10000;

Power_level(7,1)=7;
Power_level(7,2)=12000;

Power_level(8,1)=8;
Power_level(8,2)=14000;

Power_level(9,1)=9;
Power_level(9,2)=16000;

Power_level(10,1)=10;
Power_level(10,2)=18000;

% Power_level(1,1)=1;
% Power_level(1,2)=1;
% 
% Power_level(2,1)=2;
% Power_level(2,2)=300;
% 
% Power_level(3,1)=3;
% Power_level(3,2)=600;
% 
% Power_level(4,1)=4;
% Power_level(4,2)=900;
% 
% Power_level(5,1)=5;
% Power_level(5,2)=1200;
% 
% Power_level(6,1)=6;
% Power_level(6,2)=1500;
% 
% Power_level(7,1)=7;
% Power_level(7,2)=1800;
% 
% Power_level(8,1)=8;
% Power_level(8,2)=2100;
% 
% Power_level(9,1)=9;
% Power_level(9,2)=2400;

% Power_level(10,1)=10;
% Power_level(10,2)=2700;

[m_ts,n_ts]=size(Solution);
[m_pl,n_pl]=size(Power_level);

Throughput_efficiency=zeros(m_pl*(m_ts-1),1); 

for i=2:m_ts % ����tile size
    
    for j=1:m_pl  %�����ܼ�
        P_harvest=Power_level(j,2)*(1e-6);
        Ops=0;
        
        P_present=Solution(i,3)/(Solution(i,V_pos)*0.01);
        if P_harvest>=P_present %����ִ�е�������
            Ops_times=cyc_time/(Solution(i,1)*5e-9);
            Ops=Solution(i,4)*Solution(i,5)*Solution(i,6)*Ops_times;
            Throughput_efficiency(j+10*(i-2),1)=Ops/cyc_time;
        else  %��Ъִ�е�������
            flag=1; %���ͷŵ��жϲ���
            Estore=0;
            t_onecycle=0; %���ʱ��+ִ��ʱ��
            charge_flag=0;%һ��cycle��һ��
            t_total=0; %һ��power cycle���ʱ���ܺ�
            %��Ъִ�вɼ�������
            
            V_present=0;%��ǰ���ݵĵ�ѹֵ
            t=(C*1e-9*(Solution(1,V_pos)*Solution(1,V_pos)-V_present*V_present))/(2*P_harvest);%���ʱ��
            working_cycle_time1=0;
            working_cycle_time2=0;
            working_cycle_ops_i=0;
            Energy_consume_tile=0;
            if cyc_time>t %������ʱ����ڲ���ʱ�䣬�������һ��power cacle
                while cyc_time>t_onecycle % �����ŵ�ʱ�䳬������ʱ�䣬�������һ��power cacle
                    % ---------------------�ж��Ƿŵ绹�Ƿŵ�--------------------- %
                    if flag==0

                        Solution_Effi=Solution(i,V_pos);%��ǰ��ѹ��һ���Ӧ��ת��Ч��

                        time_tile=Solution(i,1)/4*20e-9;
                        
                        Energy_consume_tile=(Solution(i,3)/(0.01*Solution_Effi))*time_tile;

                        if Estore>=Energy_consume_tile %��һ��ִ������
                            Ops=Ops+Solution(i,4)*Solution(i,5)*Solution(i,6);
                            %ִ�е�һ������ʣ������
                            Estore=Estore-Energy_consume_tile;
                 
                            if (1/2*C*1e-9*Solution(1,V_pos)*Solution(1,V_pos))<=(Estore+P_harvest*time_tile)
                                Estore=1/2*C*1e-9*Solution(1,V_pos)*Solution(1,V_pos);%�߷ű߳�
                            else
                                Estore=Estore+P_harvest*time_tile;
                            end
                            if charge_flag==1
                                working_cycle_time2=working_cycle_time2+time_tile;
                                working_cycle_ops_i=working_cycle_ops_i+(Solution(i,4)*Solution(i,5)*Solution(i,6));
                            end
                            t_onecycle=t_onecycle+time_tile;  
                        elseif  Estore==(1/2*C*1e-9*Solution(1,V_pos)*Solution(1,V_pos)) && Estore<Energy_consume_tile %���������������֧��һ������
                            break;
                        end
                        V_up=sqrt(2*Estore/(C*(1e-9)));
                    else %���
           
                        V_present=0;
                        t=(C*1e-9*(Solution(1,V_pos)*Solution(1,V_pos)-V_present*V_present))/(2*P_harvest);%���ʱ��
                        Estore=1/2*C*1e-9*Solution(1,V_pos)*Solution(1,V_pos);%���֮����ݴ洢������
 
                        if charge_flag==0
                            working_cycle_time1=t;
                        end
                        charge_flag=charge_flag+1; 
                        V_up=Solution(1,V_pos);
                        V_down=0;
                    end
                    % --------------------- ���ͷŵ� end  --------------------- %
                    V=V_up-V_down;
                    %ִ��һ�ηŵ���ж��Ƿ�����ŵ����ִ�г��
                    if V>(Solution(1,V_pos)-0.01) && Estore>=Energy_consume_tile %�ŵ��ж�
                        flag=0; 
                    else %����ж�
                        flag=1;
                        t_total=t_total+t;%һ��power cycle���ʱ���ܺ�
                        t_onecycle=t_onecycle+t;%һ��power cycle���ʱ���ִ��ʱ���ܺͣ�������������ʱ��������һ��power cycle
                    end
                end
            else
                working_cycle_time1=t;
            end
            if working_cycle_time1>=cyc_time
                working_cycle_time=cyc_time;
            elseif working_cycle_time2>=cyc_time
                working_cycle_time=cyc_time;
            else
                working_cycle_time=working_cycle_time1+working_cycle_time2;
            end
            Throughput_efficiency(j+10*(i-2),1)=Ops/working_cycle_time;
        end
    end
end