# frozen_string_literal: true

def display_room(robots, seconds)
  map = @room_height.times.map { Array.new(@room_width, '.') }

  puts "THIS IS: #{seconds}"
  robots.each do |(y, x, vy, vx)|
    x, y = [x, y].zip([vx * seconds, vy * seconds]).map(&:sum)
    x %= @room_height
    y %= @room_width
    map[x][y] = '#'
  end
  puts map.map(&:join),
       "#{'='.rjust(@room_width, '=')}\n\n"
end

@room_height = 103
@room_width = 101
robots = File.read('input.txt').gsub(/-?\d+/).map(&:to_i).each_slice(4).to_a

(@room_height * @room_width).times do
  # system("clear")
  display_room(robots, _1)
  sleep(0.01)
end
