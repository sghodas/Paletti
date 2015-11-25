class Magick::Pixel

  def is_black_or_white?
    r, g, b = self.red, self.green, self.blue
    black_thresh = 0.09 * Magick::QuantumRange
    white_thresh = 0.91 * Magick::QuantumRange
    (r > white_thresh && g > white_thresh && b > white_thresh) || (r < black_thresh && g < black_thresh && b < black_thresh) ? true : false
  end

end
