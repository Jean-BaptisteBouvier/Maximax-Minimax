clear variables
clc

%%% Inputs

polygon = [-2, 4;
           3, 4;
           5, 0.5;
           4, -3;
           -1, -4;
           -4, 0];
vector = [1, 0.5;
          -1, -0.5];

step = 0.02;
video_recording = true;
fontsize = 14;
text_offset = 0.2;
transp = 1; % transparency of X

%%% Code
[nb_vertices, dim] = size(polygon);
if dim ~= 2
    error('Only works for 2D')
end
polygon(end+1, :) = polygon(1, :); % closing the polygon

pointsAreCollinear = @(xy) rank(xy(2:end,:) - xy(1,:)) == 1;
if ~pointsAreCollinear( [vector; 0,0])
    error('vector must contain the origin')
end

%%% Detailled polygon for video
detailed_poly = []; % polygon with a lot of intermediary points on faces
id_min_x = []; % id of points with x very close to 0
y_min_x = []; % y coordinate of those points

for i = 1:nb_vertices
    v1 = polygon(i,:);
    v2 = polygon(i+1,:);
    dv = (v2 - v1)*step/norm(v2 - v1);
    j = 0;
    while j < floor( norm(v2 - v1)/step )
        detailed_poly(end+1, :) = v1 + j*dv;
        if abs(detailed_poly(end, 1)) < 0.6*step
            id_min_x(end+1) = length(detailed_poly(:,1));
            y_min_x(end+1) = detailed_poly(end, 2);
        end
        j = j + 1;
    end
end
nb_pts = length(detailed_poly(:,1));
[~, id_max] = max(y_min_x);
id_start = id_min_x(id_max);
detailed_poly = [detailed_poly(id_start:end, :); detailed_poly(1:id_start-1, :)];




%%%%
max_norm = 0;
for i = 1:nb_vertices
    n = norm(polygon(i,:));
    if n > max_norm
        max_norm = n;
    end
end
max_norm = max_norm + max(norm(vector(1,:)), norm(vector(2,:))) + 0.1;

eps = 1e-3;

if video_recording
    video = VideoWriter('maximax.avi');
    open(video);
end

[max_x, id_max_x] = max(detailed_poly(:,1));

t = zeros(1, nb_pts);
beta = zeros(1, nb_pts);
aligned = zeros(1, nb_pts);

for i = 1:nb_pts
    p = detailed_poly(i,:);
    dp = p*eps;
    
    L = zeros(size(vector));
    for j = 1:2
        v = -vector(j,:);
        
        
        min_dist_poly = Inf;
        for nb_dp = 0:round(2/eps)
            
            dist_poly = Inf;
            
            for k = 1:nb_pts
                dist = norm(v - detailed_poly(k,:));
                if dist < dist_poly
                    dist_poly = dist;
                end
            end
            if dist_poly < min_dist_poly
                min_dist_poly = dist_poly;
                id_min = nb_dp;
            end
            v = v + dp;
        end
        L(j,:) = dp*id_min;
    end
    norm_L = [norm(L(1,:)), norm(L(2,:))];
    t(i) = max(norm_L)/min(norm_L);
    
    figure(1)
    set(gcf, 'Position',  [50, 50, 1800, 900])
    %%% Polygon
    subplot(1,3,[1,2])
    hold on
    grid on
    xlim([-max_norm, max_norm])
    ylim([-max_norm, max_norm])
    
    plot(polygon(:,1), polygon(:,2), 'black', 'LineWidth', 2) % polygon Y
    if norm(p - detailed_poly(id_max_x,:)) > max(norm(vector(1,:)), norm(vector(2,:))) % if current point p is far from the place where we want to display Y
        text(max_x + text_offset, detailed_poly(id_max_x, 2), 'Y', 'Color', 'black', 'Fontsize', fontsize) % display Y next to polygon
    end
    
    quiver(0,0, vector(1,1), vector(1,2), 0, 'Color', [0 0.6 0.8 transp], 'LineWidth', 2, 'MaxHeadSize', 0.6) % polygon X
    quiver(0,0, vector(2,1), vector(2,2), 0, 'Color', [0.9 0.2 0.1 transp], 'LineWidth', 2, 'MaxHeadSize', 0.6) % polygon X
    X_position = [vector(1,1) - text_offset, vector(1,2) - 2*text_offset]; % position of where to display X
    if norm(p*norm(vector(1,:))/norm(p) - X_position) > 2*text_offset % current rays are not too close from where we write X
        text(X_position(1), X_position(2), 'X', 'Color', 'black', 'Fontsize', fontsize) % display X
    end
    
    plot([0 0], [0 max_norm], ':', 'Color', 'black') % reference line for beta
    if norm_L(1) < norm_L(2)
        plot([0 L(1,1)], [0 L(1,2)], 'Color', [0.5 0.2 0.5], 'LineWidth', 3)
        plot([L(1,1) L(2,1)], [L(1,2) L(2,2)], 'Color', [0.4 0.7 0.2],'LineWidth', 3)
        quiver(L(2,1), L(2,2), p(1)/norm(p), p(2)/norm(p), 0, 'black', 'LineWidth', 3, 'MaxHeadSize', 0.5)
        text(L(2,1) + 0.9*p(1)/norm(p) + text_offset, L(2,2) + 0.9*p(2)/norm(p), 'd', 'Color', 'black', 'Fontsize', fontsize)
    else
        plot([0 L(2,1)], [0 L(2,2)], 'Color', [0.5 0.2 0.5], 'LineWidth', 3)
        plot([L(2,1) L(1,1)], [L(2,2) L(1,2)], 'Color', [0.4 0.7 0.2],'LineWidth', 3)
        quiver(L(1,1), L(1,2), p(1)/norm(p), p(2)/norm(p), 0, 'black', 'LineWidth', 3, 'MaxHeadSize', 0.5)
        text(L(1,1) + 0.9*p(1)/norm(p) + text_offset, L(1,2) + 0.9*p(2)/norm(p), 'd', 'Color', 'black', 'Fontsize', fontsize)
    end
    
    angle_start = 90; angle_end = rad2deg(atan2(p(2),p(1))); dif = angle_start - angle_end;
    if dif < 0
        dif = dif + 360;
    end
    r = 1.1*norm(vector(1,:));
    mid_angle = angle_start - dif/2;
    if dif > 8 && i > 2
        circular_arrow(gcf, r, [0,0], mid_angle, dif, 1, 'black', 5)%, head_style)
        text(0.03*r, 1.2*r, '\beta', 'Color', 'black', 'Fontsize', fontsize)
%         text(r*cos(mid_angle), r*sin(mid_angle), '\beta', 'Color', 'black', 'Fontsize', fontsize)
    end
    
    plot([0, L(1,1) - vector(1,1)], [0, L(1,2) - vector(1,2)], 'Color', [0 0.6 0.8 transp], 'LineWidth', 2)
    quiver(  L(1,1) - vector(1,1),  L(1,2) - vector(1,2), vector(1,1), vector(1,2), 0, 'Color', [0 0.6 0.8 transp], 'LineWidth', 2, 'MaxHeadSize', 0.6)
    plot([0, L(2,1) - vector(2,1)], [0, L(2,2) - vector(2,2)], 'Color', [0.9 0.2 0.1 transp], 'LineWidth', 2)
    quiver(  L(2,1) - vector(2,1),  L(2,2) - vector(2,2), vector(2,1), vector(2,2), 0, 'Color', [0.9 0.2 0.1 transp], 'LineWidth', 2, 'MaxHeadSize', 0.6)
    
    
%     if norm_L(1) > norm_L(2) % x_N is vector(1) and x_M is vector(2)
%         text(L(1,1) - 0.5*vector(1,1) + text_offset, L(1,2) - 0.5*vector(1,2) + text_offset, 'x_N^*', 'Color', [0 0.4 0.8 transp], 'Fontsize', fontsize)
%         text(0.5*(L(1,1) - vector(1,1)) + text_offset, 0.5*(L(1,2) - vector(1,2)) + text_offset, 'y_N^*', 'Color', [0 0.4 0.8 transp], 'Fontsize', fontsize)
%         text(L(2,1) - 0.5*vector(2,1) + text_offset, L(2,2) - 0.5*vector(2,2) + text_offset, 'x_M^*', 'Color', [0.9 0.3 0.1 transp], 'Fontsize', fontsize)
%         text(0.5*(L(2,1) - vector(2,1)) + text_offset, 0.5*(L(2,2) - vector(2,2)) + text_offset, 'y_M^*', 'Color', [0.9 0.3 0.1 transp], 'Fontsize', fontsize)
%         
%     else % x_M is vector(1) and x_N is vector(2)
%         
%         text(L(1,1) - 0.5*vector(1,1) + text_offset, L(1,2) - 0.5*vector(1,2) + text_offset, 'x_M^*', 'Color', [0 0.4 0.8 transp], 'Fontsize', fontsize)
%         text(0.5*(L(1,1) - vector(1,1)) + text_offset, 0.5*(L(1,2) - vector(1,2)) + text_offset, 'y_M^*', 'Color', [0 0.4 0.8 transp], 'Fontsize', fontsize)
%         text(L(2,1) - 0.5*vector(2,1) + text_offset, L(2,2) - 0.5*vector(2,2) + text_offset, 'x_N^*', 'Color', [0.9 0.3 0.1 transp], 'Fontsize', fontsize)
%         text(0.5*(L(2,1) - vector(2,1)) + text_offset, 0.5*(L(2,2) - vector(2,2)) + text_offset, 'y_N^*', 'Color', [0.9 0.3 0.1 transp], 'Fontsize', fontsize)
%     end
    set(gca, 'FontSize', fontsize)
    
    %%% t(d)
    beta(i) = deg2rad(dif); beta(1) = 0;
    v = vector(1,:)*norm(p)/norm(vector(1,:));
    if norm(v - p) < step || norm(v + p) < step
        aligned(i) = t(i);
    end
    
    subplot(1,3,3)
    hold on
    grid on
    xlim([0, 2*pi])
    ylim([0, 1.1*max(t)])
    xlabel('\beta')
    xticks([0 pi 2*pi])
    xticklabels({'0', '\pi', '2\pi'})
    plot(beta(1:i), t(1:i), 'LineWidth', 2, 'Color', 'blue')
    plot(beta(1:i), aligned(1:i), 'LineWidth', 2, 'Color', 'red')
    title('{\color{blue}r_{X,Y}} = ({\color[rgb]{0.4 0.7 0.2}green} + {\color[rgb]{0.5 0.2 0.5}purple} )/ {\color[rgb]{0.5 0.2 0.5}purple}')
    set(gca, 'FontSize', fontsize)
    
    
    
    if video_recording
        frame = getframe(gcf);
        writeVideo(video, frame);
    end
    
    close(figure(1))
end

close(video);
