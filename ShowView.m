function ShowView( pt2d, Npt, width, height )
% show view at upper-left x-y
figure

scatter(pt2d(1, :), pt2d(2, :), 10, 1:Npt);
axis([0, width, 0, height])
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

end

