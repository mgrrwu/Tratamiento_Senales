function plotear(I1, I2, str)

figure
subplot(1,2,1),imagesc(I1),axis image
title('Original','FontSize',18)
subplot(1,2,2),imagesc(I2),axis image
title(str,'FontSize',18)
colormap(gray)

end