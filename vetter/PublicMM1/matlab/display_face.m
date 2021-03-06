function handle = display_face (shp, tex, tl, rp, mode_az,mode_ev, particle_id)
	
	shp = reshape(shp, [ 3 prod(size(shp))/3 ])'; 
    
    %Affine
    RotAngle = roty(rp.phi);
    'y'
    rp.phi
    RotAngle
    tmp = RotAngle * shp';
    shp = tmp';
    
    RotAngle = rotx(rp.elevation);
    'x'
    rp.elevation
    RotAngle
    tmp = RotAngle * shp';
    shp = tmp';
    
	tex = reshape(tex, [ 3 prod(size(tex))/3 ])'; 
	tex = min(tex, 255);
    
    if isequal(particle_id, []) == 1
        particle_id = 1;
    end
    
    
    handle = figure(particle_id);
    set(handle,'Visible','on');
    set(handle, 'PaperPositionMode','auto');
    
    
	%tk - set(gcf, 'Renderer', 'opengl');
    set(handle, 'Renderer', 'opengl');
    
	%tk fig_pos = get(gcf, 'Position');
	fig_pos = get(handle, 'Position');
	
    fig_pos(3) = rp.width;
	fig_pos(4) = rp.height;
	%tk - set(gcf, 'Position', fig_pos);
	%tk - set(gcf, 'ResizeFcn', @resizeCallback);
    set(handle, 'Position', fig_pos);
	set(handle, 'ResizeFcn', @resizeCallback);
    
	mesh_h = trimesh(...
		tl, shp(:, 1), shp(:, 3), shp(:, 2), ...
		'EdgeColor', 'none', ...
		'FaceVertexCData', tex/255, 'FaceColor', 'interp', ...
		'FaceLighting', 'phong' ...
	);

	set(gca, ...
		'DataAspectRatio', [ 1 1 1 ], ...
		'PlotBoxAspectRatio', [ 1 1 1 ], ...
		'Units', 'pixels', ...
		'GridLineStyle', 'none', ...
		'Position', [ 0 0 fig_pos(3) fig_pos(4) ], ...
		'Visible', 'off', 'box', 'off', ...
		'Projection', 'orthographic' ...
		); 

% ax.YLim
%     xlim([-6,-12])
	
	%tk set(gcf, 'Color', [ 0 0 0 ]); 
    set(handle, 'Color', [ 1 1 1 ]); 
    
%  	view(180 + rp.phi * 180 / pi, rp.elevation*180/pi);
    view(180,0);
    
    ax = gca;
%     ax.ZLim = [-12,6];
    % blender orthographic scale
    scale = 7.314/2/.0000264;
    scale
    ax.ZLim = [-1.405, 1.085] * 1e5;
    ax.YLim = [-2, 2] * 1e5;
    ax.XLim = [-1.375, 1.395] * 1e5;

% 	material([.5, .5, .1 1  ])
	material([.5, .5, .1 1  ])

% 	if mode == 0
%         camlight('headlight');
%     else
%         camlight(-50,45);
%     end
    camlight(mode_az,mode_ev);
%     saveas(gcf, '/Users/Janner/Desktop/face1', 'png');
%     print(gcf, '-dpng','-r0', strcat('/Users/Janner/Desktop/face1', '.png'));
	

%% ------------------------------------------------------------CALLBACK--------
function resizeCallback (obj, eventdata)
	
	fig = gcbf;
	fig_pos = get(fig, 'Position');

	axis = findobj(get(fig, 'Children'), 'Tag', 'Axis.Head');
	set(axis, 'Position', [ 0 0 fig_pos(3) fig_pos(4) ]);
	
