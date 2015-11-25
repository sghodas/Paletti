require 'rmagick'
require_relative 'paletti/pixel'

class Paletti

  def initialize(path_to_image)
    # Load the image at the given path
    @image = Magick::Image.read(path_to_image)[0]
  end

  def background_color
    # Make an array of all the edge/border colors
    border_colors = []
    @image.each_pixel do |pixel, col_idx, row_idx|
      if col_idx == 0 #|| row_idx == 0 || col_idx == @image.columns - 1 || row_idx == @image.rows - 1
        border_colors.push(pixel)
      end
    end

    # Make a hash of the edge/border color frequencies and sort them in descending order
    border_color_counts = Hash.new(0)
    border_colors.each { |border_color| border_color_counts[border_color] += 1 }
    sorted_border_colors = border_colors.sort_by { |pixel, count| count }

    # Get a non black or white color if possible
    pixel = sorted_border_colors[0]
    backup_pixel = pixel.dup
    while (pixel.is_black_or_white? || border_color_counts[pixel].to_f / border_color_counts[backup_pixel].to_f < 0.3) && sorted_border_colors.length > 0
      sorted_border_colors.delete(pixel)
      pixel = sorted_border_colors[0]
    end
    pixel = backup_pixel if pixel.is_black_or_white? || border_color_counts[pixel].to_f / border_color_counts[backup_pixel].to_f < 0.3
    return pixel
  end

end
