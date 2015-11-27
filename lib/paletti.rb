require 'rmagick'
require_relative 'paletti/pixel'

class Paletti

  def initialize(path_to_image)
    # Load the image at the given path
    @image = Magick::Image.read(path_to_image)[0]
  end

  def background_pixel
    if @background_pixel
      return @background_pixel
    end

    # Make an array of all the edge/border pixels
    border_pixels = []
    @image.each_pixel do |pixel, col_idx, row_idx|
      if col_idx == 0 || row_idx == 0 || col_idx == @image.columns - 1 || row_idx == @image.rows - 1
        border_pixels.push(pixel)
      end
    end

    # Make a hash of the edge/border pixel frequencies and sort by frequency
    border_pixel_counts = Hash.new(0)
    border_pixels.each { |border_pixel| border_pixel_counts[border_pixel] += 1 }
    sorted_border_pixels = border_pixel_counts.sort_by { |pixel, count| -count }
    sorted_border_pixels = sorted_border_pixels.flatten.select! do |pixel|
      pixel.class == Magick::Pixel
    end

    # Get a non black or white pixel if possible
    pixel = sorted_border_pixels.first
    backup_pixel = pixel.dup
    while !pixel.nil? && pixel.is_black_or_white? && sorted_border_pixels.length > 1
      sorted_border_pixels.delete(pixel)
      pixel = sorted_border_pixels.find { |p| border_pixel_counts[p].to_f / border_pixel_counts[pixel].to_f > 0.05 && !p.is_black_or_white?  }
    end
    return @background_pixel = pixel || backup_pixel
  end

  def text_pixels
    if @text_pixels
      return @text_pixels
    end

    # Make an array of all the pixels and sort by frequency
    pixels = []
    @image.each_pixel { |pixel| pixels.push(pixel) }
    # For speed, just use a random sample of 250,000 pixels max
    pixels = pixels.sample(250_000) if pixels.length > 250_000
    pixel_counts = Hash.new(0)
    pixels.each do |pixel|
      if pixel.to_hsla[1] < 0.15 * 255.to_f
        pixel = Magick::Pixel.from_hsla(pixel.to_hsla[0], 0.15 * 255.to_f, pixel.to_hsla[2], pixel.to_hsla[3])
      end
      pixel_counts[pixel] += 1
    end
    sorted_pixels = pixel_counts.sort_by { |pixel, count| -count }
    sorted_pixels = sorted_pixels.flatten.select! { |pixel| pixel.class == Magick::Pixel }

    # Get the most common three colors that are distinct from each other and the background color
    @text_pixels = []
    while @text_pixels.length < 3
      found = (sorted_pixels.find { |pixel| pixel.is_contrasting?(self.background_pixel) && @text_pixels.all? { |text_pixel| text_pixel.is_distinct?(pixel) } })
      @text_pixels.push(found)
    end
    return @text_pixels
  end

end
