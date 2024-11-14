function [i_pk,i_rms,isw_prim14_pk,isw_prim23_pk,isw_prim14_rms,isw_prim23_rms,...
    isw_sec14_pk,isw_sec23_pk,isw_sec14_rms,isw_sec23_rms]...
    = calc_i(f,Va,Vb,N,phi,L)

T = 1./f;
%inputs
for k = 1:length(phi)
    for j = 1:length(Va)
        
        phi = phi.*pi;
        
        g = (N.*Vb)./(Va(j))
        tstep = 1e-12; 
        omega = 2.*pi.*f;

        endtime1 = T.*(phi(k))./(2.*pi); % phi
        endtime2 = T./2; % pi
        endtime3 = endtime2+endtime1; %pi+phi
        endtime4 = T;

        t1 = [0:tstep:endtime1];
        t2 = [endtime1:tstep:endtime2];
        t3 = [endtime2:tstep:endtime3];
        t4 = [endtime3:tstep:endtime4];
        t5 = [endtime4:tstep:endtime4+endtime1];
        t6 = [endtime4+endtime1:tstep:endtime4+endtime2];
        t7 = [endtime4+endtime2:tstep:endtime4+endtime3];
        t8 = [endtime4+endtime3:tstep:endtime4+endtime4];

        M1 = (Va(j))./(2.*omega.*L);
        M2 = pi.*(1-g);
        M3 = 2.*g.*phi(k);

        i1 = M1.*(2.*(1+g).*(omega.*(t1))-M2-M3); 
        i2 = M1.*(2.*(1-g).*(omega.*(t2))-M2+M3);

        t = [t1 t2 t3 t4 t5 t6 t7 t8];
        i = [i1 i2 -i1 -i2 i1 i2 -i1 -i2];
        
        isw_prim14 = [i1 i2 -i1.*0 -i2.*0 i1 i2 -i1.*0 -i2.*0];
        isw_prim23 = [i1.*0 i2.*0 -i1 -i2 i1.*0 i2.*0 -i1 -i2];
        isw_sec14 = [i1.*0 i2.*0 -i1 -i2 i1 i2 -i1.*0 -i2.*0];
        isw_sec23 = [i1 i2 -i1.*0 -i2.*0 i1.*0 i2.*0 -i1 -i2];
        
        
        i_pk(k,j) = max(i);
        i_rms(k,j) = rms(i);
        
        isw_prim14_pk(k,j) = max(max(isw_prim14),abs(min(isw_prim14)));
        isw_prim23_pk(k,j) = max(max(isw_prim23),abs(min(isw_prim23)));
        isw_prim14_rms(k,j) = rms(isw_prim14);
        isw_prim23_rms(k,j) = rms(isw_prim23);
        
        isw_sec14_pk(k,j) = max(max(isw_sec14),abs(min(isw_sec14)));
        isw_sec23_pk(k,j) = max(max(isw_sec23),abs(min(isw_sec23)));
        isw_sec14_rms(k,j) = rms(isw_sec14);
        isw_sec23_rms(k,j) = rms(isw_sec23);
        
        
        
        plot(t, i)
        title("Inductor Current")
        ylabel("i(A)")
        xlabel("t(us)")
        hold on
%         
%         plot(isw_prim14)
%         title("Primary Switch Current 1/4")
%         ylabel("i(A)")
%         xlabel("t(us)")
%         hold on
%         

%         plot(isw_prim23)
%         title("Primary Switch Current 2/3")
%         ylabel("i(A)")
%         xlabel("t(us)")
%         hold on
    end
    
end




