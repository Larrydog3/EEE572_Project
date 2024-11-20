function [ipk,iRMS]...
    = closed_form_calc_i_vectorized(f,Va,Vb,N,phi,L)

    T = 1./f;
    phi = phi.*pi;
        
    g = Vb./(N.*Va);
    omega = 2.*pi.*f;

    endtime1 = T.*phi./(2.*pi); % phi
    endtime2 = T./2; % pi
    endtime3 = endtime2+endtime1; %pi+phi
    endtime4 = T;

    M1 = Va./(2.*omega.*L);
    M2 = pi.*(1-g);
    M3 = 2.*g.*phi;

    i1 = M1.*(2.*(1+g).*(omega.*endtime1)-M2-M3); 
    i2 = M1.*(2.*(1-g).*(omega.*endtime2)-M2+M3);
    
    ipk = max(i1,i2);
    
    B = 2.*(1+g); 
    C = -pi.*(1-g);
    D = -2.*g.*phi;
    E = 2.*(1-g); 
    F = -pi.*(1-g); 
    H = 2.*g.*phi; 

    blue = ((1/3).*(phi).^3.*B.^2)+((1/2).*(phi).^2.*(2.*B.*C+2.*B.*D))+(phi).*(C.^2+D.^2+2.*C.*D);

    rust = ((1/3).*pi.^3.*E.^2+(1/2).*pi.^2.*(2.*E.*F+2.*E.*H)+pi.*(F.^2+H.^2+2.*F.*H))-...
        ((1/3).*(phi).^3.*E.^2+(1/2).*(phi).^2.*(2.*E.*F+2.*E.*H)+(phi).*(F.^2+H.^2+2.*F.*H)); 

    X = sqrt((1/pi).*(blue+rust));

    iRMS = (Va./(2.*omega.*L)).*X;
    
    
%     i_rms = rms(i);
%     
%     isw_prim14_pk = max(max(isw_prim14),abs(min(isw_prim14)));
%     isw_prim23_pk = max(max(isw_prim23),abs(min(isw_prim23)));
%     isw_prim14_rms = rms(isw_prim14);
%     isw_prim23_rms = rms(isw_prim23);
%     
%     isw_sec14_pk = max(max(isw_sec14),abs(min(isw_sec14)));
%     isw_sec23_pk = max(max(isw_sec23),abs(min(isw_sec23)));
%     isw_sec14_rms = rms(isw_sec14);
%     isw_sec23_rms = rms(isw_sec23);
% 
%             plot(t, i)
%         title("Inductor Current")
%         ylabel("i(A)")
%         xlabel("t(us)")
%         hold on
end


