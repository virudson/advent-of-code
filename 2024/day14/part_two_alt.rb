# frozen_string_literal: true

require 'chunky_png'

def save_to_png(robots, seconds)
  png = ChunkyPNG::Image.new(@room_width, @room_height, ChunkyPNG::Color::WHITE)

  robots.each do |(y, x, vy, vx)|
    x, y = [x, y].zip([vx * seconds, vy * seconds]).map(&:sum)
    x %= @room_height
    y %= @room_width
    png[y, x] = ChunkyPNG::Color.rgb(36, 126, 71)
  end
  png.save("image/frame_#{seconds.to_s.rjust(5, '0')}.png", interlace: true)
end

@room_height = 103
@room_width = 101
robots = File.read('input.txt').gsub(/-?\d+/).map(&:to_i).each_slice(4).to_a

(@room_height * @room_width).times do
  save_to_png(robots, _1)
  sleep(0.01)
end
