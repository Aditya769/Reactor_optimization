CA0 = [2 5 6 6 11 14 16 24];
CA = [0.5 3 1 2 6 10 8 4];
tau = [30 1 50 8 4 20 20 4];
ra = tau./(CA0 - CA);
xa = 0.05:0.01:10;
ya = spline(CA,ra,xa);
pp = spline(CA,ra);


CA_in = input('Enter the inlet concentration:');
CA_out = input('Enter the exit concentration:');
vo = input('Enter the flow rate:');
disp('(1) for Single PFR ');
disp('(2) for single CSTR ');
disp('(3) for 2 CSTRs ');
disp('(4) for MFR followed by PFR ');
disp('(5) for PFR with recycle');
n = input('Enter the part to solve :');

%for a single PFR
if n == 1
    ind = CA_out:0.1:CA_in;
    ra_ind = spline(CA,ra,ind);
    Area = trapz(ind, ra_ind);
    V = vo*Area;
    x = ind;
    y = ra_ind;
    area(x,y);
    disp(['The mimimum volume for PFR required is (in Litres): ', num2str(V)]);
    hold on;
    
    plot(xa, ya,'r', 'LineWidth', 2);
    hold on;
    plot(CA,ra,'ko','LineWidth',2,'MarkerSize',2);
    %labelling the graph
    xlabel('CA')
    ylabel('-1/ra')
    title('Single PFR')
    grid on
end

%for a single CSTR
if n == 2
        ra_f = spline(CA,ra,CA_out);
        V = vo*(CA_in - CA_out)*ra_f;
        disp(['The minimum volume for CSTR required is (in Litres): ', num2str(V)]);
        x = [CA_in, CA_out];
        y = [ra_f, ra_f];
        area(x,y);
        hold on;
        plot(xa, ya,'r', 'LineWidth', 2);
        hold on;
        plot(CA,ra,'ko','LineWidth',2,'MarkerSize',2);
        xlabel('CA')
        ylabel('-1/ra')
        title('Single CSTR')
        grid on
        
end



%for two CSTRs of any size
if n == 3
        ra_in = spline(CA,ra,CA_in);
        ra_out = spline(CA,ra,CA_out);
        %using minimization of rectangles to find minimum area/volume
        Area = @(C) (CA_in - C).*(spline(CA,ra,C)) + (C-CA_out).*((spline(CA,ra,CA_out)));
        [min_area, Ca_int] = min(Area(xa));
%         Ca_int
        V1 = (CA_in - xa(Ca_int))*(spline(CA,ra,xa(Ca_int)))*vo;
        V2 = (xa(Ca_int)-CA_out)*(spline(CA,ra,CA_out))*vo;
        Vtot = min_area*vo;
        disp(['The total minimum value in case of two CSTRs is ', num2str(Vtot)]);
        disp(['The volume of CSTR1 is: ', num2str(V1)]);
        disp(['The volume of CSTR2 is: ', num2str(V2)]);
        x = [CA_in, xa(Ca_int)];
        y = [spline(CA,ra,xa(Ca_int)) , spline(CA,ra,xa(Ca_int))];
        area(x,y);
        X1 = [xa(Ca_int),CA_out];
        Y1 = [ra_out, ra_out];
        hold on;
        area(X1,Y1);
        hold on;
        plot(xa, ya,'k', 'LineWidth', 2);
        hold on;
        plot(CA,ra,'ko','LineWidth',2,'MarkerSize',2);
        xlabel('Ca')
        ylabel('-1/rA')
        title('for two CSTRs of any size')
        grid on

        
end

%combination of PFR and CSTR
if n == 4
        f = @(x) spline(CA,ra,x) ;
        [min_area2, Ca_int2] = min(f(xa));
        V_1 = (CA_in - xa(Ca_int2))*(spline(CA,ra,xa(Ca_int2)))*vo;
        x_values = CA_out:0.01:xa(Ca_int2);
        ra_x = spline(CA,ra,x_values);
        V_2 = trapz(x_values, ra_x)*vo;
        V_tot = V_1 + V_2;
        disp(['The total minimum value in case MFR followed by PFR ', num2str(V_tot)]);
        disp(['The volume of MFR is: ', num2str(V_1)]);
        disp(['The volume of PFR is: ', num2str(V_2)]);
        X1 = [CA_in; xa(Ca_int2)];
        Y1 = [ya(Ca_int2),ya(Ca_int2) ];
        hold on;
        area(X1,Y1);        
        hold on;
        area(x_values,ra_x);
        hold on;
        plot(xa, ya,'k', 'LineWidth', 2);
        hold on;
        plot(CA,ra,'ko','LineWidth',2,'MarkerSize',2);
        xlabel('CA')
        ylabel('-1/ra')
        title('combination of PFR and CSTR')
        grid on
end

% PFR with recycle
if n == 5
        C1 =fsolve(@(C1) (C1 - CA_out).*ppval(pp,C1) - trapz((CA_out: 0.01:C1),ppval(pp,(CA_out: 0.01:C1))), 4);
        z=(C1 - CA_out).*ppval(pp,C1);
        z
        V_rec = (CA_in - CA_out)*ppval(pp,C1)*vo;
        disp(['The minimum volume of PFR with recycle is: ', num2str(V_rec)]);
        x = [CA_out, CA_in];
        y = [ppval(pp,C1), ppval(pp,C1) ];
        hold on;
        area(x,y);        
        hold on;
        plot(xa, ya,'k', 'LineWidth', 2);
        hold on;
        plot(CA,ra,'ko','LineWidth',2,'MarkerSize',2);
        xlabel('CA')
        ylabel('-1/ra')
        title('PFR with recycle')
        grid on
end