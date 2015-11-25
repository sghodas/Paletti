class Magick::Pixel

  def is_black_or_white?
    r, g, b = self.red, self.green, self.blue
    black_thresh = 0.09 * Magick::QuantumRange
    white_thresh = 0.91 * Magick::QuantumRange
    (r > white_thresh && g > white_thresh && b > white_thresh) || (r < black_thresh && g < black_thresh && b < black_thresh) ? true : false
  end

  def is_distinct?(other_pixel)
    # Calculate contrast using the W3C formula
    #   http://www.w3.org/TR/WCAG20-TECHS/G145.html
    lum = 0.2126 * this.red + 0.7152 * this.green + 0.0722 * this.blue
    other_pixel_lum = 0.2126 * other_pixel.red + 0.7152 * other_pixel.green + 0.0722 * other_pixel.blue

    contrast = 0
    if lum > other_pixel_lum
      contrast = (lum.to_f + 0.05) / (other_pixel_lum.to_f + 0.05)
    else
      contrast = (other_pixel_lum.to_f + 0.05) / (lum.to_f + 0.05)
    end

    return contrast.to_f > 3.0
  end

end
