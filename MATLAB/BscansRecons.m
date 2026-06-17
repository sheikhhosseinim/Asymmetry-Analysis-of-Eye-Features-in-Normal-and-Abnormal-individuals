function BscansRecons(bscanfolder, new_bscanfolder, param_roi, u)

%%% modify by AI

r=param_roi(5);

% Read 3D OCT volume
[img3D, bscan_name] = Readdata(bscanfolder);
[num_rows, num_cols, num_bscan] = size(img3D);

% Resize only the lateral displacement to match B-scan width
u_resized =double(imresize(u, [num_bscan, num_cols])); % horizontal displacement per B-scan

for i = 1:num_bscan

    % Extract B-scan
    original_image = squeeze(img3D(:,:,i));
    original_image = im2double(original_image);

    % 1. Apply rotation only
    rotated_image = imrotate(original_image, r, 'bilinear', 'crop');

    % 2. Prepare lateral displacement field
    dx = repmat(u_resized(i,:), [num_rows, 1]);   % apply to all depth rows
    dy = zeros(size(dx));                        % do NOT apply enface vertical shift

    % 3. Coordinates
    [x, y] = meshgrid(1:num_cols, 1:num_rows);

    new_x = x + dx;
    new_y = y + dy;

    % 4. Warp B-scan laterally
    new_image = interp2(x, y, rotated_image, new_x, new_y, 'linear', 0);
new_image=new_image./max(new_image(:));

    % 5. Save output
    tmp = find(bscan_name{i}=='\');
    name = bscan_name{i}(tmp(end)+1:end);
    imagepath = fullfile(new_bscanfolder, name);
    imwrite(uint16(new_image*65535), imagepath);
end
