class Magick::Pixel

  def to_norm_rgba
    norm_factor = 255.to_f / Magick::QuantumRange.to_f
    [self.red.to_f * norm_factor, self.green.to_f * norm_factor, self.blue.to_f * norm_factor, self.opacity.to_f * norm_factor]
  end

  def norm_red
    self.red.to_f / Magick::QuantumRange.to_f * 255.to_f
  end

  def norm_green
    self.green.to_f / Magick::QuantumRange.to_f * 255.to_f
  end

  def norm_blue
    self.blue.to_f / Magick::QuantumRange.to_f * 255.to_f
  end

  def norm_opacity
    self.opacity.to_f / Magick::QuantumRange.to_f * 255.to_f
  end

  def self.norm(val)
    val.to_f / Magick::QuantumRange.to_f * 255.to_f
  end

  def is_black_or_white?
    r, g, b = self.norm_red, self.norm_green, self.norm_blue
    black_thresh = 0.09 * 255.to_f
    white_thresh = 0.91 * 255.to_f
    (r > white_thresh && g > white_thresh && b > white_thresh) || (r < black_thresh && g < black_thresh && b < black_thresh) ? true : false
  end

  def is_distinct?(other_pixel)
    r, g, b, a = self.norm_red, self.norm_green, self.norm_blue, self.norm_opacity
    other_r, other_g, other_b, other_a = other_pixel.norm_red, other_pixel.norm_green, other_pixel.norm_blue, other_pixel.norm_opacity
    thresh = 0.25 * 255.to_f

    if (r - other_r).abs > thresh || (g - other_g).abs > thresh || (b - other_b).abs > thresh || (a - other_a).abs > thresh
      if (r - g).abs < 0.03 * 255.to_f && (r - b).abs < 0.03 * 255.to_f && (other_r - other_g).abs < 0.03 * 255.to_f && (other_r - other_b).abs < 0.03 * 255.to_f
        return false
      end
      return true
    end
    return false
  end

  def is_contrasting?(other_pixel)
    # Calculate contrast using the W3C formula
    #   http://www.w3.org/TR/WCAG20-TECHS/G145.html
    lum = self.luminance
    other_pixel_lum = other_pixel.luminance
    contrast = 0
    if lum > other_pixel_lum
      contrast = (lum + 0.05) / (other_pixel_lum + 0.05)
    else
      contrast = (other_pixel_lum + 0.05) / (lum + 0.05)
    end

    return contrast.to_f > 4.5
  end

  def is_dark?
    return self.luminance < 0.5
  end

  def luminance
    r, g, b = self.norm_red / 255.to_f, self.norm_green / 255.to_f , self.norm_blue / 255.to_f
    if r <= 0.03928
      r = r / 12.92
    else
      r = ((r + 0.055) / 1.055) ** 2.4
    end

    if g <= 0.03928
      g = g / 12.92
    else
      g = ((g + 0.055) / 1.055) ** 2.4
    end

    if b <= 0.03928
      b = b / 12.92
    else
      b = ((b + 0.055) / 1.055) ** 2.4
    end

    return 0.2126 * r + 0.7152 * g + 0.0722 * b
  end

end
