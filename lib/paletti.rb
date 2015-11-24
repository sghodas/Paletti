require 'mini_magick'

class Paletti

  def initialize(path_to_image)
    @image = MiniMagick::Image.open(path_to_image)
  end

end
